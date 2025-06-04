import 'package:flutter/material.dart';
import 'package:putevod/model/trip_category.dart';
import 'package:putevod/model/library_trip.dart';
import 'package:putevod/external/library_service.dart';

/// View model for the trip search screen
class TripSearchViewModel extends ChangeNotifier {
  final LibraryService _libraryService = LibraryService();
  
  /// Search query entered by the user
  String _searchQuery = '';
  
  /// List of available trip categories
  final List<TripCategory> _categories = [
    const TripCategory(id: 'all', name: 'Все', isSelected: true),
    const TripCategory(id: 'beach', name: 'Пляжный отдых'),
    const TripCategory(id: 'city', name: 'Городские туры'),
    const TripCategory(id: 'adventure', name: 'Приключения'),
  ];
  
  /// List of library trips in search results
  List<LibraryTrip> _trips = [];
  
  /// Loading state
  bool _isLoading = false;
  
  /// Error message
  String? _errorMessage;
  
  /// Current filter - selected category id
  String _currentFilter = 'all';

  /// Gets the current search query
  String get searchQuery => _searchQuery;
  
  /// Gets the list of available categories
  List<TripCategory> get categories => List.unmodifiable(_categories);
  
  /// Gets the filtered list of trips
  List<LibraryTrip> get trips => List.unmodifiable(_trips);
  
  /// Gets the loading state
  bool get isLoading => _isLoading;
  
  /// Gets the error message
  String? get errorMessage => _errorMessage;

  /// Constructor that initializes the view model
  TripSearchViewModel() {
    init();
  }

  /// Sets the search query and notifies listeners
  void setSearchQuery(String query) {
    _searchQuery = query;
    if (query.isNotEmpty) {
      _performSearch(query);
    } else {
      _loadPopularTrips();
    }
    notifyListeners();
  }
  
  /// Load popular trips from library
  Future<void> _loadPopularTrips() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    
    try {
      final response = await _libraryService.getPopularRoutes();
      final routes = response['content'] as List<dynamic>? ?? [];
      
      _trips = _parseTripsFromResponse(routes);
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  /// Perform search
  Future<void> _performSearch(String query) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    
    try {
      final response = await _libraryService.searchRoutes(query: query);
      final routes = response['content'] as List<dynamic>? ?? [];
      
      _trips =  _parseTripsFromResponse(routes);
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  /// Parse trips from API response
  List<LibraryTrip> _parseTripsFromResponse(List<dynamic> routes) {
    return routes.map((route) => LibraryTrip.fromJson(route)).toList();
  }
  
  /// Parse a list of strings from dynamic data
  List<String> _parseStringList(dynamic data) {
    if (data == null) return [];
    if (data is List) {
      return data.map((item) => item.toString()).toList();
    }
    return [];
  }
  
  /// Initialize and load data
  void init() {
    _loadPopularTrips();
  }

  /// Selects a category and notifies listeners
  void selectCategory(String categoryId) {
    if (_currentFilter == categoryId) {
      return;
    }
    
    _currentFilter = categoryId;
    
    for (int i = 0; i < _categories.length; i++) {
      final category = _categories[i];
      _categories[i] = category.copyWith(isSelected: category.id == categoryId);
    }
    
    notifyListeners();
  }

  /// Copy trip to user's trips (instead of favorites)
  Future<void> copyTripToUser(int tripId) async {
    // TODO: Реализовать копирование поездки из библиотеки в свои поездки
    // Это будет заменой избранному - пользователь сможет скопировать понравившийся маршрут
    try {
      // Здесь должен быть вызов API для копирования маршрута
      // await LibraryService.copyRouteToTrips(tripId);
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }
  
  /// Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
} 