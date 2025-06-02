import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:putevod/model/trip_day.dart';
import 'package:putevod/model/trip_location.dart';

part 'trip.g.dart';

/// Model representing a trip
@JsonSerializable()
class Trip {
  /// Unique identifier for the trip
  final int id;
  
  /// Name/title of the trip
  @JsonKey(name: 'title')
  final String name;
  
  /// Trip start date
  final DateTime startDate;
  
  /// Trip end date
  final DateTime endDate;
  
  /// Trip status (upcoming, ongoing, completed)
  @JsonKey(includeFromJson: false, includeToJson: false)
  final TripStatus status;
  
  /// URL of the trip image
  final String imageUrl;
  
  /// Destination of the trip
  @JsonKey(includeFromJson: false, includeToJson: false)
  final String destination;

  /// Country of the trip
  final String country;
  
  /// City of the trip
  final String city;
  
  /// Description of the trip
  final String description;

  final List<TripDay> days;

  final List<TripLocation> locations;
  
  /// Version for conflict resolution
  final int? version;
  
  /// Whether the trip is published
  final bool? published;

  /// Creates a new trip instance
  const Trip({
    required this.id,
    required this.name,
    required this.startDate,
    required this.endDate,
    required this.days,
    required this.locations,
    this.status = TripStatus.upcoming,
    required this.imageUrl,
    this.destination = '',
    this.country = '',
    this.city = '',
    this.description = '',
    this.version,
    this.published,
  });

  /// Creates a copy of this trip with the given fields replaced
  Trip copyWith({
    int? id,
    String? name,
    DateTime? startDate,
    DateTime? endDate,
    TripStatus? status,
    String? imageUrl,
    String? destination,
    String? country,
    String? city,
    String? description,
    int? version,
    bool? published,
    List<TripDay>? days,
    List<TripLocation>? locations,
  }) {
    return Trip(
      id: id ?? this.id,
      name: name ?? this.name,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      status: status ?? this.status,
      imageUrl: imageUrl ?? this.imageUrl,
      destination: destination ?? this.destination,
      country: country ?? this.country,
      city: city ?? this.city,
      description: description ?? this.description,
      version: version ?? this.version,
      published: published ?? this.published,
      days: days ?? this.days,
      locations: locations ?? this.locations,
    );
  }
  
  /// Create a Trip from JSON
  factory Trip.fromJson(Map<String, dynamic> json) {
    final trip = _$TripFromJson(json);
    // Определяем статус на основе дат
    final now = DateTime.now();
    TripStatus status;
    if (trip.startDate.isAfter(now)) {
      status = TripStatus.upcoming;
    } else if (trip.endDate.isBefore(now)) {
      status = TripStatus.completed;
    } else {
      status = TripStatus.ongoing;
    }
    
    return trip.copyWith(
      status: status,
      destination: '${trip.city}, ${trip.country}',
    );
  }
  
  /// Convert Trip to JSON
  Map<String, dynamic> toJson() => _$TripToJson(this);

  getLocationsForDay(int selectedDayNumber) {}
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