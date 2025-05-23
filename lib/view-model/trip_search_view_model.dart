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
      imageUrl: 'https://cdn.tripster.ru/photos/b212a6d5-a872-4c9b-a7dd-6d8f99f0a9a4.jpg',
      rating: 4.7,
      reviewCount: 128,
    ),
    const TripItem(
      id: '2',
      title: 'Экскурсия по Санкт-Петербургу',
      description: 'Исторические достопримечательности северной столицы',
      imageUrl: 'https://etu.ru/assets/cache/images/en/why-us/cultural-capital/1280x854-spb-view-bridges01.0cb.jpg',
      rating: 4.9,
      reviewCount: 254,
    ),
    const TripItem(
      id: '3',
      title: 'Поход на Алтай',
      description: 'Активный отдых в горах с потрясающими пейзажами',
      imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/f/fa/%D0%A1%D0%BA%D0%B0%D0%B7%D0%BA%D0%B0%2C%D0%9C%D0%B5%D1%87%D1%82%D0%B0%2C%D0%9A%D1%80%D0%B0%D1%81%D0%B0%D0%B2%D0%B8%D1%86%D0%B0.jpg/1200px-%D0%A1%D0%BA%D0%B0%D0%B7%D0%BA%D0%B0%2C%D0%9C%D0%B5%D1%87%D1%82%D0%B0%2C%D0%9A%D1%80%D0%B0%D1%81%D0%B0%D0%B2%D0%B8%D1%86%D0%B0.jpg',
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