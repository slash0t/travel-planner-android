import 'package:flutter/material.dart';
import 'package:putevod/model/app_colors.dart';

/// A custom search bar widget for the trip search screen
class SearchBarWidget extends StatelessWidget {
  /// The current search query
  final String searchQuery;
  
  /// Callback when the search query changes
  final Function(String) onQueryChanged;
  
  /// Callback when the filter button is pressed
  final VoidCallback? onFilterPressed;

  /// Creates a search bar widget
  const SearchBarWidget({
    super.key,
    required this.searchQuery,
    required this.onQueryChanged,
    this.onFilterPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: const Offset(0, 1),
            blurRadius: 2,
          ),
        ],
      ),
      child: Row(
        children: [
          const SizedBox(width: 12),
          Icon(
            Icons.search,
            size: 16,
            color: Colors.grey[600],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: TextEditingController(text: searchQuery)
                ..selection = TextSelection.fromPosition(
                  TextPosition(offset: searchQuery.length),
                ),
              onChanged: onQueryChanged,
              decoration: const InputDecoration(
                hintText: 'Поиск путешествий...',
                hintStyle: TextStyle(
                  color: Color(0xFFADAFBC),
                  fontFamily: 'NotoSans',
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
              ),
              style: const TextStyle(
                fontFamily: 'NotoSans',
              ),
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.filter_list,
              color: AppColors.accent,
              size: 16,
            ),
            constraints: const BoxConstraints(
              minWidth: 40,
              minHeight: 40,
            ),
            onPressed: onFilterPressed,
          ),
        ],
      ),
    );
  }
} 