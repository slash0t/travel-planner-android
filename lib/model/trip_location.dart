import 'package:latlong2/latlong.dart';

/// Model class representing a location on a trip
class TripLocation {
  /// Unique identifier of the trip location
  final String id;
  
  /// Name of the location
  final String name;
  
  /// Geographic coordinates of the location
  final LatLng coordinates;
  
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
    required this.coordinates,
    required this.dayNumber,
    required this.startTime,
    required this.endTime,
    required this.orderInDay,
  });

  /// Returns the formatted time range as a string
  String get timeRange => '$startTime - $endTime';
} 