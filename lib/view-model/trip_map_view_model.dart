import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:putevod/model/app_colors.dart';
import 'package:putevod/model/trip.dart';
import 'package:putevod/model/trip_day.dart';
import 'package:putevod/model/trip_location.dart';

/// ViewModel for the trip map screen
class TripMapViewModel extends ChangeNotifier {
  /// Current trip displayed on the map
  Trip? _trip;
  
  /// Currently selected day number
  int _selectedDayNumber = 1;
  
  /// Currently selected location
  TripLocation? _selectedLocation;

  /// Map zoom level
  double _mapZoom = 13.0;

  /// Map center position
  LatLng _mapCenter = LatLng(48.859939001968996, 2.31719161871743); // Default to Moscow coordinates

  /// List of mock trip days for testing
  List<TripDay> get mockDays => [
    TripDay(
      id: '1',
      dayNumber: 1,
      name: 'День 1',
      color: AppColors.accent,
    ),
    TripDay(
      id: '2',
      dayNumber: 2,
      name: 'День 2',
      color: AppColors.link,
    ),
    TripDay(
      id: '3',
      dayNumber: 3,
      name: 'День 3',
      color: AppColors.secondary,
    ),
  ];

  /// List of mock trip locations for testing
  List<TripLocation> get mockLocations => [
    TripLocation(
      id: '1',
      name: 'Эйфелева башня',
      coordinates: LatLng(48.85834855392802, 2.294449206765905),
      dayNumber: 1,
      startTime: '10:00',
      endTime: '12:00',
      orderInDay: 1,
    ),
    TripLocation(
      id: '2',
      name: 'Лувр',
      coordinates: LatLng(48.86061805585402, 2.3373435763419947),
      dayNumber: 1,
      startTime: '13:00',
      endTime: '15:00',
      orderInDay: 2,
    ),
    TripLocation(
      id: '3',
      name: 'Третьяковская галерея',
      coordinates: LatLng(55.7415, 37.6213),
      dayNumber: 2,
      startTime: '10:00',
      endTime: '13:00',
      orderInDay: 1,
    ),
    TripLocation(
      id: '4',
      name: 'ВДНХ',
      coordinates: LatLng(55.8263, 37.6377),
      dayNumber: 3,
      startTime: '11:00',
      endTime: '16:00',
      orderInDay: 1,
    ),
  ];

  /// Constructor that creates a mock trip for testing
  TripMapViewModel() {
    _trip = Trip(
        id: 1,
        name: 'Путешествие в Париж',
        startDate: DateTime(2025, 3, 15),
        endDate: DateTime(2025, 3, 22),
        status: TripStatus.ongoing,
        imageUrl: 'assets/images/paris.jpg',
        destination: 'Париж, Франция',
        days: [
          TripDay(
              id: '1',
              dayNumber: 1,
              name: 'day 1',
              color: AppColors.accent
          ),
          TripDay(
              id: '2',
              dayNumber: 2,
              name: 'day 2',
              color: AppColors.accent
          )
        ],
        locations: [
          TripLocation(
            id: '1',
            name: 'Эйфелева башня',
            coordinates: LatLng(48.85834855392802, 2.294449206765905),
            dayNumber: 1,
            startTime: '10:00',
            endTime: '12:00',
            orderInDay: 1,
          ),
          TripLocation(
            id: '2',
            name: 'Лувр',
            coordinates: LatLng(48.86061805585402, 2.3373435763419947),
            dayNumber: 1,
            startTime: '13:00',
            endTime: '15:00',
            orderInDay: 2,
          ),
          TripLocation(
              id: '3',
              name: 'name2',
              coordinates: const LatLng(55.751677, 37.629023),
              dayNumber: 2,
              startTime: 'utro',
              endTime: 'utro tozhe',
              orderInDay: 1
          ),
        ]
    );
    
    _mapCenter = LatLng(48.859939001968996, 2.31719161871743);
    _mapZoom = 13.0;
  }

  /// Getter for the current trip
  Trip? get trip => _trip;
  
  /// Getter for the selected day number
  int get selectedDayNumber => _selectedDayNumber;
  
  /// Getter for the selected location
  TripLocation? get selectedLocation => _selectedLocation;

  /// Getter for the map zoom level
  double get mapZoom => _mapZoom;

  /// Getter for the map center position
  LatLng get mapCenter => _mapCenter;

  /// Getter for the list of trip days
  List<TripDay> get days => _trip?.days ?? [];
  
  /// Getter for the selected day
  TripDay? get selectedDay {
    return days.firstWhere(
      (day) => day.dayNumber == _selectedDayNumber,
      orElse: () => days.first,
    );
  }

  /// Getter for the locations of the selected day
  List<TripLocation> get locationsForSelectedDay {
    return _trip?.getLocationsForDay(_selectedDayNumber) ?? [];
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
  void selectLocation(TripLocation location) {
    _selectedLocation = location;
    _mapCenter = location.coordinates;
    notifyListeners();
  }

  /// Clear the selected location
  void clearSelectedLocation() {
    _selectedLocation = null;
    notifyListeners();
  }

  /// Navigate to a location (like centering the map on it)
  void navigateToLocation(TripLocation location) {
    selectDay(location.dayNumber);
    selectLocation(location);
  }

  /// Set a reminder for a location
  void setReminder(TripLocation location) {
    // Implementation for setting a reminder would go here
    notifyListeners();
  }

  /// Change the map zoom level
  void setMapZoom(double zoom) {
    _mapZoom = zoom;
    notifyListeners();
  }
} 