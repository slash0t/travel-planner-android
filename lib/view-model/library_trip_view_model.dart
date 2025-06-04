import 'package:flutter/material.dart';
import 'package:putevod/external/library_service.dart';
import 'package:putevod/model/library_trip.dart';

import '../external/api_client.dart';
import '../model/trip_day.dart';

class LibraryTripViewModel extends ChangeNotifier {
  final ApiClient _plannerClient = ApiClients.planner;
  final LibraryService _libraryService = LibraryService();
  LibraryTrip? _trip;
  bool _isLoading = false;
  String? _error;
  List<DailyPlan>? _dailyPlans;
  List<TripReview>? _reviews;
  bool _isOwner = false;
  double _newReviewRating = 5.0;
  final TextEditingController commentController = TextEditingController();

  LibraryTrip? get trip => _trip;
  bool get isLoading => _isLoading;
  String? get error => _error;
  List<DailyPlan>? get dailyPlans => _dailyPlans;
  List<TripReview>? get reviews => _reviews;
  bool get isOwner => _isOwner;
  double get newReviewRating => _newReviewRating;

  void setTrip(LibraryTrip trip) {
    _trip = trip;
    // Here you would check if the current user is the owner of the trip
    // For now, we'll simulate that the user is not the owner
    _isOwner = false;
  }

  void updateRating(double rating) {
    _newReviewRating = rating;
    notifyListeners();
  }

  Future<void> checkOwnerShip() async {
    if (_trip == null) return;

    try {
      final userResponse = await _plannerClient.get(
          '/users/me'
      );

      if (userResponse.statusCode == 200) {
        _isOwner = trip!.author.id == (userResponse.data["id"] as int);
      }

      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
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

  Future<void> addComment() async {
    if (_trip == null || commentController.text.isEmpty) return;

    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await _libraryService.addReview(
        _trip!.id,
        _newReviewRating.round(),
        comment: commentController.text,
      );

      // Clear the comment field after successful submission
      commentController.clear();
      
      // Reload reviews to show the new comment
      await loadReviews();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> copyRoute() async {

  }

  @override
  void dispose() {
    commentController.dispose();
    super.dispose();
  }
} 