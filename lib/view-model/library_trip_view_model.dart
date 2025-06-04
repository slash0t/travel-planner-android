import 'package:flutter/material.dart';
import 'package:putevod/external/library_service.dart';
import 'package:putevod/model/library_trip.dart';

import '../model/trip_day.dart';

class LibraryTripViewModel extends ChangeNotifier {
  final LibraryService _libraryService = LibraryService();
  LibraryTrip? _trip;
  bool _isLoading = false;
  String? _error;
  List<DailyPlan>? _dailyPlans;
  List<TripReview>? _reviews;

  LibraryTrip? get trip => _trip;
  bool get isLoading => _isLoading;
  String? get error => _error;
  List<DailyPlan>? get dailyPlans => _dailyPlans;
  List<TripReview>? get reviews => _reviews;

  void setTrip(LibraryTrip trip) {
    _trip = trip;
  }

  // Mock data for demonstration
  Future<void> loadTripDetails() async {
    if (_trip == null) return;

    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final response = await _libraryService.getRouteDetails(_trip!.id);

      _trip = LibraryTrip.fromJson(response);

      _dailyPlans = (response["days"] as List<dynamic>)
          .map((a) => DailyPlan.fromJson(a as Map<String, dynamic>))
          .toList();

      await loadReviews();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadReviews() async  {
    if (_trip == null) return;

    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final response = await _libraryService.getRouteReviews(_trip!.id);
      _reviews = (response["content"] as List<dynamic>)
          .map((a) => TripReview.fromJson(a as Map<String, dynamic>))
          .toList();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> copyRoute() async {
    // Implement copy route logic
    // This would typically involve creating a copy of the trip for the current user
  }
} 