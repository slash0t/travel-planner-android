import 'package:flutter/material.dart';
import 'package:putevod/model/library_trip.dart';

class LibraryTripViewModel extends ChangeNotifier {
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
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      // Create author
      final author = Author(
        id: 1,
        username: "Александр Петров",
        // avatarUrl: "https://via.placeholder.com/100",
      );

      // Create trip
      _trip = LibraryTrip(
        id: 1,
        title: "Путешествие по Европе",
        description: "Незабываемое путешествие по историческим городам Европы с посещением главных достопримечательностей",
        author: author,
        countries: ["Франция", "Италия", "Испания"],
        cities: ["Париж", "Рим", "Барселона", "Венеция", "Мадрид", "Флоренция"],
        duration: 14,
        rating: 4.8,
        reviewsCount: 42,
        previewImageUrl: "https://via.placeholder.com/390x200",
        tags: ["Европа", "Культура", "История", "Архитектура"],
      );

      // Create daily plans
      _dailyPlans = [
        DailyPlan(
          day: 1,
          city: "Париж",
          details: "5 мест • 8 часов",
        ),
        DailyPlan(
          day: 2,
          city: "Париж",
          details: "3 места • 6 часов",
        ),
        DailyPlan(
          day: 3,
          city: "Рим",
          details: "4 места • 7 часов",
        ),
      ];

      // Create reviews
      _reviews = [
        TripReview(
          reviewerName: "Мария К.",
          rating: 5,
          reviewText: "Отличный маршрут! Все достопримечательности подобраны идеально.",
        ),
        TripReview(
          reviewerName: "Иван С.",
          rating: 4,
          reviewText: "Хороший маршрут, но немного утомительный. Рекомендую добавить больше времени на отдых.",
        ),
      ];

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