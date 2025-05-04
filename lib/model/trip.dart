import 'package:flutter/material.dart';

/// Model representing a trip
class Trip {
  /// Unique identifier for the trip
  final String id;
  
  /// Name of the trip
  final String name;
  
  /// Trip start date
  final DateTime startDate;
  
  /// Trip end date
  final DateTime endDate;
  
  /// Trip status (upcoming, ongoing, completed)
  final TripStatus status;
  
  /// URL of the trip image
  final String imageUrl;
  
  /// Destination of the trip
  final String destination;

  /// Country of the trip
  final String country;
  
  /// City of the trip
  final String city;
  
  /// Description of the trip
  final String description;

  /// Creates a new trip instance
  const Trip({
    required this.id,
    required this.name,
    required this.startDate,
    required this.endDate,
    required this.status,
    required this.imageUrl,
    required this.destination,
    this.country = '',
    this.city = '',
    this.description = '',
  });

  /// Creates a copy of this trip with the given fields replaced
  Trip copyWith({
    String? id,
    String? name,
    DateTime? startDate,
    DateTime? endDate,
    TripStatus? status,
    String? imageUrl,
    String? destination,
    String? country,
    String? city,
    String? description,
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
    );
  }
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