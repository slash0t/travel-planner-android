import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:putevod/model/app_colors.dart';
import 'package:putevod/model/trip.dart';
import 'package:putevod/model/trip_day.dart';
import 'package:putevod/model/trip_event.dart';

import '../model/place.dart';

/// View model for the trip map screen
class TripMapViewModel extends ChangeNotifier {
  /// The day to display on the map
  final TripDay day;
  
  /// Currently selected event location
  TripEvent? _selectedLocation;

  /// Current map zoom level
  double _mapZoom = 13.0;

  /// Current map center coordinates
  late LatLng _mapCenter;
  
  /// Map controller to programmatically control the map
  final MapController mapController = MapController();

  /// Constructor that takes a single day
  TripMapViewModel({required this.day}) {
    _initializeMapCenter();
  }

  /// Initialize map center based on the first event with coordinates
  void _initializeMapCenter() {
    // Find the first event with a place that has coordinates
    final eventWithPlace = day.events.firstWhere(
      (event) => event.place != null && 
                 event.place!.latitude != null && 
                 event.place!.longitude != null,
      orElse: () => TripEvent.empty(),
    );

    // Set map center to the coordinates of the first event or default to Paris if none found
    if (eventWithPlace.place != null && 
        eventWithPlace.place!.latitude != null && 
        eventWithPlace.place!.longitude != null) {
      _mapCenter = LatLng(eventWithPlace.place!.latitude!, eventWithPlace.place!.longitude!);
    } else {
      // Default coordinates (Paris)
      _mapCenter = LatLng(48.859939001968996, 2.31719161871743);
    }
  }

  /// Currently selected event location
  TripEvent? get selectedLocation => _selectedLocation;

  /// Current map zoom level
  double get mapZoom => _mapZoom;

  /// Current map center coordinates
  LatLng get mapCenter => _mapCenter;

  /// Get all events for the day
  List<TripEvent> get events => day.events;

  /// Select a location
  void selectLocation(TripEvent location) {
    if (location.place != null && 
        location.place!.latitude != null && 
        location.place!.longitude != null) {
      _selectedLocation = location;
      _mapCenter = LatLng(location.place!.latitude!, location.place!.longitude!);
      
      // Move map to the selected location
      mapController.move(_mapCenter, _mapZoom);
      
      notifyListeners();
    }
  }

  /// Clear the selected location
  void clearSelectedLocation() {
    _selectedLocation = null;
    notifyListeners();
  }

  /// Navigate to a location (center the map on it)
  void navigateToLocation(TripEvent location) {
    selectLocation(location);
  }

  /// Set a reminder for a location
  void setReminder(Place location) {
    // Implementation for setting a reminder would go here
    notifyListeners();
  }

  /// Change the map zoom level
  void setMapZoom(double zoom) {
    if (zoom >= 3 && zoom <= 18) {
      _mapZoom = zoom;
      
      // Update the map zoom using the controller
      mapController.move(_mapCenter, _mapZoom);
      
      notifyListeners();
    }
  }
} 