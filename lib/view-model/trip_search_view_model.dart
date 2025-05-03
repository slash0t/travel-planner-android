import 'package:flutter/material.dart';
import 'package:putevod/model/trip_category.dart';
import 'package:putevod/model/trip_item.dart';

/// View model for the trip search screen
class TripSearchViewModel extends ChangeNotifier {
  /// Search query entered by the user
  String _searchQuery = '';
  
  /// List of available trip categories
  final List<TripCategory> _categories = [
    const TripCategory(id: 'all', name: 'Все', isSelected: true),
    const TripCategory(id: 'beach', name: 'Пляжный отдых'),
    const TripCategory(id: 'city', name: 'Городские туры'),
    const TripCategory(id: 'adventure', name: 'Приключения'),
  ];
  
  /// List of trip items in search results
  final List<TripItem> _trips = [
    const TripItem(
      id: '1',
      title: 'Отпуск в Сочи',
      description: 'Прекрасный отдых на черноморском побережье',
      imageUrl: 'assets/images/sochi.jpg',
      rating: 4.7,
      reviewCount: 128,
    ),
    const TripItem(
      id: '2',
      title: 'Экскурсия по Санкт-Петербургу',
      description: 'Исторические достопримечательности северной столицы',
      imageUrl: 'assets/images/spb.jpg',
      rating: 4.9,
      reviewCount: 254,
    ),
    const TripItem(
      id: '3',
      title: 'Поход на Алтай',
      description: 'Активный отдых в горах с потрясающими пейзажами',
      imageUrl: 'assets/images/altai.jpg',
      rating: 4.8,
      reviewCount: 76,
    ),
  ];
  
  /// Current filter - selected category id
  String _currentFilter = 'all';

  /// Gets the current search query
  String get searchQuery => _searchQuery;
  
  /// Gets the list of available categories
  List<TripCategory> get categories => List.unmodifiable(_categories);
  
  /// Gets the filtered list of trips
  List<TripItem> get trips {
    if (_currentFilter == 'all') {
      return List.unmodifiable(_trips);
    }
    
    // In a real app, this would filter by category
    return List.unmodifiable(_trips);
  }

  /// Sets the search query and notifies listeners
  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
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

  /// Toggles the favorite status of a trip and notifies listeners
  void toggleFavorite(String tripId) {
    for (int i = 0; i < _trips.length; i++) {
      final trip = _trips[i];
      if (trip.id == tripId) {
        _trips[i] = trip.copyWith(isFavorite: !trip.isFavorite);
        notifyListeners();
        break;
      }
    }
  }
} 