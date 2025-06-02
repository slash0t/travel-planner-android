import 'package:json_annotation/json_annotation.dart';
import 'package:latlong2/latlong.dart';

part 'trip_location.g.dart';

/// Model class representing a location on a trip
@JsonSerializable()
class TripLocation {
  /// Unique identifier of the trip location
  final String id;
  
  /// Name of the location
  final String name;
  
  /// Geographic coordinates of the location
  @JsonKey(includeFromJson: false, includeToJson: false)
  final LatLng coordinates;
  
  /// Latitude of the location
  final double latitude;
  
  /// Longitude of the location
  final double longitude;
  
  /// Day number this location belongs to
  final int dayNumber;
  
  /// Start time in 24-hour format (HH:MM)
  final String startTime;
  
  /// End time in 24-hour format (HH:MM)
  final String endTime;
  
  /// Order of this location in the day's schedule
  final int orderInDay;

  /// Constructor for TripLocation
  TripLocation({
    required this.id,
    required this.name,
    LatLng? coordinates,
    required this.latitude,
    required this.longitude,
    required this.dayNumber,
    required this.startTime,
    required this.endTime,
    required this.orderInDay,
  }) : this.coordinates = coordinates ?? LatLng(latitude, longitude);

  /// Create a TripLocation from JSON
  factory TripLocation.fromJson(Map<String, dynamic> json) => _$TripLocationFromJson(json);
  
  /// Convert TripLocation to JSON
  Map<String, dynamic> toJson() => _$TripLocationToJson(this);

  /// Returns the formatted time range as a string
  String get timeRange => '$startTime - $endTime';
} 