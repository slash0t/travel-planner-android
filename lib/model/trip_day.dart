import 'package:flutter/material.dart';

/// Model class representing a day in a trip
class TripDay {
  /// Unique identifier of the trip day
  final String id;
  
  /// Day number in the trip sequence (e.g. 1, 2, 3)
  final int dayNumber;
  
  /// Display name for the day (e.g. "День 1")
  final String name;
  
  /// Color assigned to the day for visual identification
  final Color color;

  /// Constructor for TripDay
  TripDay({
    required this.id,
    required this.dayNumber,
    required this.name,
    required this.color,
  });
} 