import 'package:flutter/material.dart';
import 'package:putevod/external/library_service.dart';
import 'package:putevod/model/library_trip.dart';

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

  // Mock data for demonstration
  Future<void> loadTripDetails() async {
    if (_trip == null) return;

    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final response = await _libraryService.getRouteDetails(_trip!.id);

      _trip = LibraryTrip.fromJson(response);

      await loadDailyPlans();

      await loadReviews();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadDailyPlans() async  {

  }

  Future<void> loadReviews() async  {

  }

  Future<void> copyRoute() async {
    // Implement copy route logic
    // This would typically involve creating a copy of the trip for the current user
  }

  Future<void> toggleFavorite() async {
    // Implement favorite toggle logic
    // This would typically involve adding/removing the trip from user's favorites
  }
} 