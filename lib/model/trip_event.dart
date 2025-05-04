import 'package:flutter/material.dart';

/// Model class for trip events
class TripEvent {
  /// Unique identifier for the event
  final String id;
  
  /// Time of the event in 24-hour format (e.g., "09:00")
  final String time;
  
  /// Title of the event
  final String title;
  
  /// Address where the event takes place
  final String address;
  
  /// Day this event belongs to (date only)
  final DateTime day;

  /// Creates a new trip event
  const TripEvent({
    required this.id,
    required this.time,
    required this.title,
    required this.address,
    required this.day,
  });
  
  /// Creates a copy of this event with the given fields replaced
  TripEvent copyWith({
    String? id,
    String? time,
    String? title,
    String? address,
    DateTime? day,
  }) {
    return TripEvent(
      id: id ?? this.id,
      time: time ?? this.time,
      title: title ?? this.title,
      address: address ?? this.address,
      day: day ?? this.day,
    );
  }
} 