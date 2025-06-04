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

  const Author({
    required this.id,
    required this.username,
  });

  Author copyWith({
    int? id,
    String? username,
  }) {
    return Author(
      id: id ?? this.id,
      username: username ?? this.username,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'username': username,
  };

  factory Author.fromJson(Map<String, dynamic> json) {
    return Author(
      id: json['id'] as int,
      username: json['username'] as String,
    );
  }

  factory Author.empty() {
    return const Author(
      id: 0,
      username: '',
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
  final int id;
  final int routeId;
  final Author author;
  final double rating;
  final String comment;

  const TripReview({
    required this.id,
    required this.routeId,
    required this.author,
    required this.rating,
    required this.comment,
  });

  TripReview copyWith({
    int? id,
    int? routeId,
    Author? author,
    double? rating,
    String? comment,
  }) {
    return TripReview(
      id: id ?? this.id,
      routeId: routeId ?? this.routeId,
      author: author ?? this.author,
      rating: rating ?? this.rating,
      comment: comment ?? this.comment,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'routeId': routeId,
    'author': author.toJson(),
    'rating': rating,
    'comment': comment,
  };

  factory TripReview.fromJson(Map<String, dynamic> json) {
    return TripReview(
      id: json['id'] as int,
      routeId: json['routeId'] as int,
      author: Author.fromJson(json['author'] as Map<String, dynamic>),
      rating: (json['rating'] as num).toDouble(),
      comment: json['comment'] as String,
    );
  }

  factory TripReview.empty() {
    return TripReview(
      id: 0,
      routeId: 0,
      author: Author.empty(),
      rating: 0.0,
      comment: '',
    );
  }
}