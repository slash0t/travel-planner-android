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

  /// Creates a new trip instance
  const Trip({
    required this.id,
    required this.name,
    required this.startDate,
    required this.endDate,
    required this.status,
    required this.imageUrl,
    required this.destination,
  });
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