import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:putevod/model/app_colors.dart';
import 'package:putevod/model/trip.dart';
import 'package:putevod/model/trip_day.dart';
import 'package:putevod/model/trip_event.dart';

import '../model/place.dart';

class TripMapViewModel extends ChangeNotifier {
  Trip? _trip;
  
  int _selectedDayNumber = 1;

  TripEvent? _selectedLocation;

  double _mapZoom = 13.0;

  LatLng _mapCenter = LatLng(48.859939001968996, 2.31719161871743); // Default to Moscow coordinates

  List<TripDay> get mockDays => [];

  List<TripEvent> get mockLocations => [];

  TripMapViewModel() {
    _trip = null;
    
    _mapCenter = LatLng(48.859939001968996, 2.31719161871743);
    _mapZoom = 13.0;
  }

  Trip? get trip => _trip;
  
  int get selectedDayNumber => _selectedDayNumber;

  TripEvent? get selectedLocation => _selectedLocation;

  double get mapZoom => _mapZoom;

  LatLng get mapCenter => _mapCenter;

  List<TripDay> get days => _trip?.days ?? [];
  
  TripDay? get selectedDay {
    return days.firstWhere(
      (day) => day.dayNumber == _selectedDayNumber,
      orElse: () => days.first,
    );
  }

  /// Getter for the locations of the selected day
  List<TripEvent> get locationsForSelectedDay {
    for (final day in _trip!.days) {
      if (day.dayNumber == _selectedDayNumber) {
        return day.events;
      }
    }
    return [];
  }

  /// Select a day by its day number
  void selectDay(int dayNumber) {
    if (_selectedDayNumber != dayNumber) {
      _selectedDayNumber = dayNumber;
      _selectedLocation = null;
      notifyListeners();
    }
  }

  /// Select a location
  void selectLocation(TripEvent location) {
    _selectedLocation = location;
    _mapCenter = LatLng(location.place.latitude!, location.place.longitude!);
    notifyListeners();
  }

  /// Clear the selected location
  void clearSelectedLocation() {
    _selectedLocation = null;
    notifyListeners();
  }

  /// Navigate to a location (like centering the map on it)
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
    _mapZoom = zoom;
    notifyListeners();
  }
} 