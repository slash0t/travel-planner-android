import 'package:flutter/foundation.dart';
import 'package:putevod/model/trip.dart';
import 'package:flutter/material.dart';

/// ViewModel for the trips screen
class TripsViewModel extends ChangeNotifier {
  TripStatus _currentFilter = TripStatus.upcoming;
  
  /// List of all trips
  final List<Trip> _trips = [
    Trip(
      id: '1',
      name: 'Путешествие в Париж',
      startDate: DateTime(2025, 3, 15),
      endDate: DateTime(2025, 3, 22),
      status: TripStatus.upcoming,
      imageUrl: 'assets/images/paris.jpg',
      destination: 'Париж, Франция',
    ),
    Trip(
      id: '2',
      name: 'Выходные в Барселоне',
      startDate: DateTime(2024, 12, 10),
      endDate: DateTime(2024, 12, 12),
      status: TripStatus.upcoming,
      imageUrl: 'assets/images/barcelona.jpg',
      destination: 'Барселона, Испания',
    ),
    Trip(
      id: '3',
      name: 'Поездка в Рим',
      startDate: DateTime(2023, 6, 10),
      endDate: DateTime(2023, 6, 20),
      status: TripStatus.ongoing,
      imageUrl: 'assets/images/rome.jpg',
      destination: 'Рим, Италия',
    ),
    Trip(
      id: '4',
      name: 'Тур по Японии',
      startDate: DateTime(2023, 7, 5),
      endDate: DateTime(2023, 7, 20),
      status: TripStatus.ongoing,
      imageUrl: 'assets/images/japan.jpg',
      destination: 'Токио, Япония',
    ),
    Trip(
      id: '5',
      name: 'Поездка в Грецию',
      startDate: DateTime(2022, 10, 5),
      endDate: DateTime(2022, 10, 15),
      status: TripStatus.completed,
      imageUrl: 'assets/images/greece.jpg',
      destination: 'Афины, Греция',
    ),
    Trip(
      id: '6',
      name: 'Отдых в Турции',
      startDate: DateTime(2022, 8, 10),
      endDate: DateTime(2022, 8, 20),
      status: TripStatus.completed,
      imageUrl: 'assets/images/turkey.jpg',
      destination: 'Стамбул, Турция',
    ),
  ];

  /// Get the current filter
  TripStatus get currentFilter => _currentFilter;
  
  /// Set the current filter
  set currentFilter(TripStatus filter) {
    _currentFilter = filter;
    notifyListeners();
  }

  /// Get all trips
  List<Trip> get trips => List.unmodifiable(_trips);
  
  /// Get filtered trips based on status
  List<Trip> get filteredTrips => 
      _trips.where((trip) => trip.status == _currentFilter).toList();

  /// Creates a new trip
  void createTrip(Trip trip) {
    _trips.add(trip);
    notifyListeners();
  }

  /// Deletes a trip by id
  void deleteTrip(String id) {
    _trips.removeWhere((trip) => trip.id == id);
    notifyListeners();
  }

  /// Returns a human-readable date range for a trip
  String getFormattedDateRange(Trip trip) {
    final startMonth = _getMonthAbbreviation(trip.startDate.month);
    final endMonth = _getMonthAbbreviation(trip.endDate.month);
    
    return '$startMonth ${trip.startDate.day} - $endMonth ${trip.endDate.day}, ${trip.endDate.year}';
  }

  String _getMonthAbbreviation(int month) {
    const months = ['Янв', 'Фев', 'Мар', 'Апр', 'Май', 'Июн', 'Июл', 'Авг', 'Сен', 'Окт', 'Ноя', 'Дек'];
    return months[month - 1];
  }
  
  /// Get status text based on trip status
  String getStatusText(TripStatus status) {
    switch (status) {
      case TripStatus.upcoming:
        return 'Скоро начнётся';
      case TripStatus.ongoing:
        return 'В процессе';
      case TripStatus.completed:
        return 'Завершено';
    }
  }
  
  /// Get status color based on trip status
  Color getStatusColor(TripStatus status) {
    switch (status) {
      case TripStatus.upcoming:
        return const Color(0xFFF1C021); // Yellow
      case TripStatus.ongoing:
        return const Color(0xFF84BA83); // Green
      case TripStatus.completed:
        return const Color(0xFF4B5563); // Gray
    }
  }
} 