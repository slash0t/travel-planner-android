import 'package:flutter/material.dart';

/// Enum for place types
enum PlaceType {
  /// Generic place
  place,
  
  /// Restaurant
  restaurant,
  
  /// Event
  event,
}

/// Model class for places in the journey
class Place {
  /// Unique identifier for the place
  final String id;
  
  /// Name of the place
  final String name;
  
  /// Type of place (place, restaurant, event)
  final PlaceType type;
  
  /// Flag indicating if this place has a specified visit time
  final bool hasTime;
  
  /// Start time for the visit (null if hasTime is false)
  final TimeOfDay? startTime;
  
  /// End time for the visit (null if hasTime is false)
  final TimeOfDay? endTime;
  
  /// Latitude coordinate
  final double? latitude;
  
  /// Longitude coordinate
  final double? longitude;
  
  /// Notes about the place
  final String? notes;
  
  /// List of attached file paths
  final List<String> attachedFiles;

  /// Creates a new place
  const Place({
    required this.id,
    required this.name,
    required this.type,
    this.hasTime = false,
    this.startTime,
    this.endTime,
    this.latitude,
    this.longitude,
    this.notes,
    this.attachedFiles = const [],
  });
  
  /// Creates a copy of this place with the given fields replaced
  Place copyWith({
    String? id,
    String? name,
    PlaceType? type,
    bool? hasTime,
    TimeOfDay? startTime,
    TimeOfDay? endTime,
    double? latitude,
    double? longitude,
    String? notes,
    List<String>? attachedFiles,
  }) {
    return Place(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      hasTime: hasTime ?? this.hasTime,
      startTime: hasTime == false ? null : (startTime ?? this.startTime),
      endTime: hasTime == false ? null : (endTime ?? this.endTime),
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      notes: notes ?? this.notes,
      attachedFiles: attachedFiles ?? this.attachedFiles,
    );
  }
  
  /// Factory method to create a new empty place
  factory Place.empty() {
    return Place(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: '',
      type: PlaceType.place,
      hasTime: false,
    );
  }
} 