import 'package:flutter/material.dart';
import 'package:putevod/model/library_trip.dart';

class LibraryTripViewModel extends ChangeNotifier {
  LibraryTrip? _trip;
  bool _isLoading = false;
  String? _error;

  LibraryTrip? get trip => _trip;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Mock data for demonstration
  Future<void> loadTripDetails() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      _trip = LibraryTrip(
        tripName: "Путешествие по Европе",
        tripDescription: "Незабываемое путешествие по историческим городам Европы с посещением главных достопримечательностей",
        authorName: "Александр Петров",
        authorTitle: "Опытный путешественник",
        duration: 14,
        citiesCount: 6,
        placesCount: 42,
        rating: 4.8,
        imageUrl: "https://via.placeholder.com/390x200",
        dailyPlans: [
          DailyPlan(
            day: 1,
            city: "Париж",
            details: "5 мест • 8 часов",
          ),
          // Add more daily plans as needed
        ],
        reviews: [
          TripReview(
            reviewerName: "Мария К.",
            rating: 5,
            reviewText: "Отличный маршрут! Все достопримечательности подобраны идеально.",
          ),
          // Add more reviews as needed
        ],
      );

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

  Future<void> toggleFavorite() async {
    // Implement favorite toggle logic
    // This would typically involve adding/removing the trip from user's favorites
  }
} 