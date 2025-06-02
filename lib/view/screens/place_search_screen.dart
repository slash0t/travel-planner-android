import 'package:flutter/material.dart';
import 'package:putevod/external/external_service.dart';
import 'package:putevod/model/app_colors.dart';
import 'package:putevod/view/widgets/app_header.dart';

class PlaceSearchScreen extends StatefulWidget {
  const PlaceSearchScreen({super.key});

  @override
  State<PlaceSearchScreen> createState() => _PlaceSearchScreenState();
}

class _PlaceSearchScreenState extends State<PlaceSearchScreen> {
  final ExternalService _externalService = ExternalService();
  final TextEditingController _searchController = TextEditingController();
  
  List<dynamic> _searchResults = [];
  List<dynamic> _suggestions = [];
  bool _isLoading = false;
  bool _isLoadingSuggestions = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    // Добавляем задержку для автодополнения
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    if (_searchController.text.isNotEmpty) {
      _debounceAutoComplete();
    } else {
      setState(() {
        _suggestions.clear();
      });
    }
  }

  void _debounceAutoComplete() {
    Future.delayed(const Duration(milliseconds: 300), () {
      if (_searchController.text.isNotEmpty) {
        _getAutoCompleteSuggestions(_searchController.text);
      }
    });
  }

  Future<void> _getAutoCompleteSuggestions(String input) async {
    if (input.length < 2) return;
    
    setState(() {
      _isLoadingSuggestions = true;
      _errorMessage = null;
    });

    try {
      final response = await _externalService.autocompletePlaces(
        input: input,
        limit: 5,
      );
      
      setState(() {
        _suggestions = response['suggestions'] ?? [];
        _isLoadingSuggestions = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoadingSuggestions = false;
      });
    }
  }

  Future<void> _searchPlaces(String query) async {
    if (query.isEmpty) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _searchResults.clear();
    });

    try {
      final response = await _externalService.searchPlaces(
        query: query,
        limit: 20,
      );
      
      setState(() {
        _searchResults = response['places'] ?? [];
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            AppHeader(
              showBackButton: true,
              title: 'Поиск мест',
              onBackPressed: () => Navigator.of(context).pop(),
            ),
            _buildSearchBar(),
            Expanded(
              child: _buildSearchContent(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Поиск мест...',
          prefixIcon: const Icon(Icons.search, color: AppColors.accent),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    setState(() {
                      _suggestions.clear();
                      _searchResults.clear();
                    });
                  },
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
        ),
        onSubmitted: _searchPlaces,
      ),
    );
  }

  Widget _buildSearchContent() {
    if (_errorMessage != null) {
      return _buildErrorWidget();
    }

    if (_searchController.text.isNotEmpty && _suggestions.isNotEmpty) {
      return _buildSuggestionsList();
    }

    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.accent),
      );
    }

    if (_searchResults.isNotEmpty) {
      return _buildSearchResults();
    }

    return _buildEmptyState();
  }

  Widget _buildSuggestionsList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Предложения',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: AppColors.text,
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: _suggestions.length,
            itemBuilder: (context, index) {
              final suggestion = _suggestions[index];
              return ListTile(
                leading: const Icon(Icons.location_on, color: AppColors.accent),
                title: Text(suggestion['name'] ?? ''),
                subtitle: Text(suggestion['address'] ?? ''),
                onTap: () {
                  _searchController.text = suggestion['name'] ?? '';
                  _searchPlaces(suggestion['name'] ?? '');
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSearchResults() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Результаты поиска (${_searchResults.length})',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: AppColors.text,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _searchResults.length,
            itemBuilder: (context, index) {
              final place = _searchResults[index];
              return _buildPlaceCard(place);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPlaceCard(Map<String, dynamic> place) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              place['name'] ?? 'Неизвестное место',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            if (place['address'] != null)
              Text(
                place['address'],
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                ),
              ),
            const SizedBox(height: 8),
            Row(
              children: [
                if (place['rating'] != null) ...[
                  const Icon(Icons.star, color: Colors.amber, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    '${place['rating']}',
                    style: const TextStyle(fontSize: 14),
                  ),
                  const SizedBox(width: 16),
                ],
                if (place['category'] != null)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.accent.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      place['category'],
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.accent,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.error_outline,
            size: 48,
            color: Colors.red,
          ),
          const SizedBox(height: 16),
          const Text(
            'Ошибка поиска',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _errorMessage!,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _errorMessage = null;
              });
              if (_searchController.text.isNotEmpty) {
                _searchPlaces(_searchController.text);
              }
            },
            child: const Text('Повторить'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.search,
            size: 48,
            color: Colors.black26,
          ),
          SizedBox(height: 16),
          Text(
            'Поиск мест',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Введите название места для поиска',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }
} 