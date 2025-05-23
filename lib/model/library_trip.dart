class LibraryTrip {
  final String tripName;
  final String tripDescription;
  final String authorName;
  final String authorTitle;
  final int duration;
  final int citiesCount;
  final int placesCount;
  final double rating;
  final String imageUrl;
  final List<DailyPlan> dailyPlans;
  final List<TripReview> reviews;

  const LibraryTrip({
    required this.tripName,
    required this.tripDescription,
    required this.authorName,
    required this.authorTitle,
    required this.duration,
    required this.citiesCount,
    required this.placesCount,
    required this.rating,
    required this.imageUrl,
    required this.dailyPlans,
    required this.reviews,
  });
}

class DailyPlan {
  final int day;
  final String city;
  final String details;

  const DailyPlan({
    required this.day,
    required this.city,
    required this.details,
  });
}

class TripReview {
  final String reviewerName;
  final int rating;
  final String reviewText;
  final String? avatarUrl;

  const TripReview({
    required this.reviewerName,
    required this.rating,
    required this.reviewText,
    this.avatarUrl,
  });
} 