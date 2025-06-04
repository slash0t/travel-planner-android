class LibraryTrip {
  final int id;
  final String title;
  final String description;
  final Author author;
  final List<String> countries;
  final List<String> cities;
  final int duration;
  final double rating;
  final int reviewsCount;
  final String previewImageUrl;
  final List<String> tags;

  const LibraryTrip({
    required this.id,
    required this.title,
    required this.description,
    required this.author,
    required this.countries,
    required this.cities,
    required this.duration,
    required this.rating,
    required this.reviewsCount,
    required this.previewImageUrl,
    required this.tags,
  });

  LibraryTrip copyWith({
    int? id,
    String? title,
    String? description,
    Author? author,
    List<String>? countries,
    List<String>? cities,
    int? duration,
    double? rating,
    int? reviewsCount,
    String? previewImageUrl,
    List<String>? tags,
  }) {
    return LibraryTrip(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      author: author ?? this.author,
      countries: countries ?? this.countries,
      cities: cities ?? this.cities,
      duration: duration ?? this.duration,
      rating: rating ?? this.rating,
      reviewsCount: reviewsCount ?? this.reviewsCount,
      previewImageUrl: previewImageUrl ?? this.previewImageUrl,
      tags: tags ?? this.tags,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'author': author.toJson(),
    'countries': countries,
    'cities': cities,
    'duration': duration,
    'rating': rating,
    'reviewsCount': reviewsCount,
    'previewImageUrl': previewImageUrl,
    'tags': tags,
  };

  factory LibraryTrip.fromJson(Map<String, dynamic> json) {
    return LibraryTrip(
      id: json['id'] as int,
      title: json['title'] as String,
      description: json['description'] as String,
      author: Author.fromJson(json['author'] as Map<String, dynamic>),
      countries: List<String>.from(json['countries'] as List),
      cities: List<String>.from(json['cities'] as List),
      duration: json['duration'] as int,
      rating: json['rating'] as double,
      reviewsCount: json['reviewsCount'] as int,
      previewImageUrl: json['previewImageUrl'] as String,
      tags: List<String>.from(json['tags'] as List),
    );
  }

  factory LibraryTrip.empty() {
    return LibraryTrip(
      id: 0,
      title: '',
      description: '',
      author: Author.empty(),
      countries: [],
      cities: [],
      duration: 0,
      rating: 0.0,
      reviewsCount: 0,
      previewImageUrl: '',
      tags: [],
    );
  }
}

class Author {
  final int id;
  final String username;
  final String avatarUrl;

  const Author({
    required this.id,
    required this.username,
    required this.avatarUrl,
  });

  Author copyWith({
    int? id,
    String? username,
    String? avatarUrl,
  }) {
    return Author(
      id: id ?? this.id,
      username: username ?? this.username,
      avatarUrl: avatarUrl ?? this.avatarUrl,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'username': username,
    'avatarUrl': avatarUrl,
  };

  factory Author.fromJson(Map<String, dynamic> json) {
    return Author(
      id: json['id'] as int,
      username: json['username'] as String,
      avatarUrl: json['avatarUrl'] as String,
    );
  }

  factory Author.empty() {
    return const Author(
      id: 0,
      username: '',
      avatarUrl: '',
    );
  }
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

  DailyPlan copyWith({
    int? day,
    String? city,
    String? details,
  }) {
    return DailyPlan(
      day: day ?? this.day,
      city: city ?? this.city,
      details: details ?? this.details,
    );
  }

  Map<String, dynamic> toJson() => {
    'day': day,
    'city': city,
    'details': details,
  };

  factory DailyPlan.fromJson(Map<String, dynamic> json) {
    return DailyPlan(
      day: json['day'] as int,
      city: json['city'] as String,
      details: json['details'] as String,
    );
  }

  factory DailyPlan.empty() {
    return const DailyPlan(
      day: 0,
      city: '',
      details: '',
    );
  }
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

  TripReview copyWith({
    String? reviewerName,
    int? rating,
    String? reviewText,
    String? avatarUrl,
  }) {
    return TripReview(
      reviewerName: reviewerName ?? this.reviewerName,
      rating: rating ?? this.rating,
      reviewText: reviewText ?? this.reviewText,
      avatarUrl: avatarUrl ?? this.avatarUrl,
    );
  }

  Map<String, dynamic> toJson() => {
    'reviewerName': reviewerName,
    'rating': rating,
    'reviewText': reviewText,
    'avatarUrl': avatarUrl,
  };

  factory TripReview.fromJson(Map<String, dynamic> json) {
    return TripReview(
      reviewerName: json['reviewerName'] as String,
      rating: json['rating'] as int,
      reviewText: json['reviewText'] as String,
      avatarUrl: json['avatarUrl'] as String?,
    );
  }

  factory TripReview.empty() {
    return const TripReview(
      reviewerName: '',
      rating: 0,
      reviewText: '',
      avatarUrl: null,
    );
  }
}