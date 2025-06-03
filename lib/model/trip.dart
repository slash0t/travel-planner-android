import 'package:putevod/model/trip_day.dart';

class Trip {
  final int id;
  
  final String title;

  final String description;

  final DateTime startDate;
  
  final DateTime endDate;

  final String country;

  final String city;

  final TripStatus status;

  final bool? published;

  final String? previewUrl;

  final List<TripDay> days;

  const Trip({
    required this.id,
    required this.title,
    required this.startDate,
    required this.endDate,
    required this.days,
    required this.country,
    required this.city,
    required this.description,
    this.status = TripStatus.upcoming,
    this.previewUrl,
    this.published,
  });

  String get destination => "$country, $city";

  /// Creates a copy of this trip with the given fields replaced
  Trip copyWith({
    int? id,
    String? title,
    DateTime? startDate,
    DateTime? endDate,
    List<TripDay>? days,
    TripStatus? status,
    String? previewUrl,
    String? country,
    String? city,
    String? description,
    bool? published,
  }) {
    return Trip(
      id: id ?? this.id,
      title: title ?? this.title,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      days: days ?? this.days,
      status: status ?? this.status,
      previewUrl: previewUrl ?? this.previewUrl,
      country: country ?? this.country,
      city: city ?? this.city,
      description: description ?? this.description,
      published: published ?? this.published,
    );
  }

  static int compareTwo(Trip a, Trip b) {
    if (a.status == b.status) {
      return a.startDate.compareTo(b.startDate);
    }

    if (a.status == TripStatus.ongoing) {
      return -1;
    } else if (b.status == TripStatus.ongoing) {
      return 1;
    } else if (a.status == TripStatus.upcoming) {
      return -1;
    } else {
      return 1;
    }
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'startDate': startDate.toIso8601String(),
    'endDate': endDate.toIso8601String(),
    'country': country,
    'city': city,
    'status': status.name,
    'published': published,
    'previewUrl': previewUrl,
    'days': days.map((day) => day.toJson()).toList(),
  };

  factory Trip.fromJson(Map<String, dynamic> json) => Trip(
    id: json['id'] as int,
    title: json['title'] as String,
    description: json['description'] as String,
    startDate: DateTime.parse(json['startDate'] as String),
    endDate: DateTime.parse(json['endDate'] as String),
    country: json['country'] as String,
    city: json['city'] as String,
    status: TripStatus.values.firstWhere(
      (status) => status.name == json['status'],
      orElse: () => TripStatus.upcoming,
    ),
    published: json['published'] as bool?,
    previewUrl: json['previewUrl'] as String?,
    days: (json['days'] as List<dynamic>)
        .map((e) => TripDay.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

/// Enum representing the status of a trip
enum TripStatus {
  /// Trip that hasn't started yet
  upcoming,
  
  /// Trip that is currently in progress
  ongoing,
  
  /// Trip that has been completed
  completed
} 