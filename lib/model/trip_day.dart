import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'trip_day.g.dart';

/// Model class representing a day in a trip
@JsonSerializable()
class TripDay {
  /// Unique identifier of the trip day
  final int id;
  
  /// ID of the trip this day belongs to
  final int tripId;
  
  /// Day number in the trip sequence (e.g. 1, 2, 3)
  final int dayNumber;
  
  /// Date of this trip day
  final DateTime date;
  
  /// When this trip day was created
  final DateTime createdAt;
  
  /// When this trip day was last updated
  final DateTime updatedAt;
  
  /// Display name for the day (e.g. "День 1")
  @JsonKey(includeFromJson: false, includeToJson: false)
  final String name;
  
  /// Color assigned to the day for visual identification
  @JsonKey(includeFromJson: false, includeToJson: false)
  final Color color;

  /// Constructor for TripDay
  TripDay({
    required this.id,
    required this.tripId,
    required this.dayNumber,
    required this.date,
    required this.createdAt,
    required this.updatedAt,
    String? name,
    Color? color,
  }) : this.name = name ?? "День $dayNumber",
       this.color = color ?? Colors.blue;
       
  /// Create a TripDay from JSON
  factory TripDay.fromJson(Map<String, dynamic> json) => _$TripDayFromJson(json);
  
  /// Convert TripDay to JSON
  Map<String, dynamic> toJson() => _$TripDayToJson(this);
} 