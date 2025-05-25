import 'package:flutter/foundation.dart';
import 'package:putevod/model/trip.dart';
import 'package:flutter/material.dart';
import 'package:putevod/model/app_colors.dart';
import 'package:putevod/external/sync_service.dart';

/// ViewModel for the trips screen
class TripsViewModel extends ChangeNotifier {
  TripStatus _currentFilter = TripStatus.upcoming;
  bool _isLoading = false;
  String? _errorMessage;
  
  /// List of all trips
  List<Trip> _trips = [];

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
      
  /// Get loading state
  bool get isLoading => _isLoading;
  
  /// Get error message
  String? get errorMessage => _errorMessage;
  
  /// Load trips from API/cache
  Future<void> loadTrips({bool forceRefresh = false}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    
    try {
      final tripsResponse = await SyncService.instance.getTrips(forceRefresh: forceRefresh);
      // Преобразуем List<dynamic> в List<Trip>
      _trips = tripsResponse.map((tripData) => Trip.fromJson(tripData)).toList();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Creates a new trip
  Future<void> createTrip(Map<String, dynamic> tripData) async {
    try {
      await SyncService.instance.createTrip(tripData);
      await loadTrips(forceRefresh: true);
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  /// Deletes a trip by id
  Future<void> deleteTrip(int id) async {
    try {
      await SyncService.instance.deleteTrip(id);
      _trips.removeWhere((trip) => trip.id == id);
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
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
        return AppColors.secondary; // Yellow
      case TripStatus.ongoing:
        return const Color(0xFF84BA83); // Green
      case TripStatus.completed:
        return const Color(0xFF4B5563); // Gray
    }
  }

  /// Add a new trip to the list
  Future<void> addTrip(Map<String, dynamic> tripData) async {
    await createTrip(tripData);
  }

  /// Update an existing trip in the list
  Future<void> updateTrip(int tripId, Map<String, dynamic> tripData) async {
    try {
      await SyncService.instance.updateTrip(tripId, tripData);
      await loadTrips(forceRefresh: true);
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