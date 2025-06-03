import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:putevod/model/trip.dart';
import 'package:putevod/model/trip_day.dart';
import 'package:putevod/model/trip_event.dart';
import 'package:putevod/external/trip_service.dart';

import '../model/place.dart';

/// ViewModel for the trip detail screen
class TripDetailViewModel with ChangeNotifier {
  final TripService _tripService = TripService();
  
  /// Current trip
  Trip? _trip;
  
  /// Selected day to view events
  TripDay? _selectedDay;
  
  /// Loading state indicator
  bool _isLoading = false;
  
  /// Error message
  String? _errorMessage;
  
  /// Getter for trip
  Trip? get trip => _trip;
  
  /// Getter for selected day
  TripDay? get selectedDay => _selectedDay;
  
  /// Getter for loading state
  bool get isLoading => _isLoading;
  
  /// Getter for error message
  String? get errorMessage => _errorMessage;
  
  /// Getter for events of the selected day
  List<TripEvent> get eventsForSelectedDay {
    if (_selectedDay == null) {
      return [];
    }

    return _selectedDay!.events;
  }
  
  /// Loads trip detail data for the provided trip ID
  Future<void> loadTripDetail(int tripId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    
    try {
      final tripResponse = await _tripService.getTripById(tripId);
      
      if (tripResponse != null) {
        _trip = Trip.fromJson(tripResponse);
        
        // Получить все события поездки
        // final eventsResponse = await _tripService.getTripEvents(tripId);
        // _events = eventsResponse.map((eventData) => TripEvent(
        //   id: eventData['eventId'].toString(),
        //   time: eventData['startTime'] ?? '00:00',
        //   title: eventData['title'] ?? 'Без названия',
        //   address: eventData['place']?['address'] ?? '',
        //   day: DateTime.parse(eventData['day']['date']),
        // )).toList();
        
        // Select the first day by default
        if (_trip != null && _trip!.days.isNotEmpty) {
          _selectedDay = _trip!.days.first;
        }
      } else {
        _errorMessage = 'Поездка не найдена';
      }
    } catch (e) {
      _errorMessage = 'Ошибка загрузки поездки: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  /// Selects a specific day to view events
  void selectDay(TripDay day) {
    _selectedDay = day;
    notifyListeners();
  }
  
  /// Reorders events within the same day
  void reorderEvents(int oldIndex, int newIndex) {
    if (_selectedDay == null) return;
    
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    
    final List<TripEvent> dayEvents = eventsForSelectedDay;

    final List<TripEvent> newDayEvents = List.from(dayEvents);
    final TripEvent event = dayEvents[oldIndex];
    newDayEvents.removeAt(oldIndex);
    newDayEvents.insert(newIndex, event);

    notifyListeners();
  }
  
  /// Deletes an event by its ID
  Future<void> deleteEvent(int eventId) async {
    if (_trip == null) return;
    
    try {
      final tripId = _trip!.id;

      
      await _tripService.deleteEvent(tripId, _selectedDay!.id, eventId);
      
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Ошибка удаления события: ${e.toString()}';
      notifyListeners();
    }
  }
  
  /// Create a new event
  Future<void> createEvent(Map<String, dynamic> eventData) async {
    if (_trip == null || _selectedDay == null) return;
    
    try {
      final tripId = _trip!.id;
      final dayId = _selectedDay!.id;
      
      final newEventResponse = await _tripService.createEvent(tripId, dayId, eventData);
      final newEvent = TripEvent(
        id: newEventResponse['event_id'] as int,
        dayId: newEventResponse['day_id'] as int,
        startTime: DateTime.parse(newEventResponse['start_time']),
        endTime: DateTime.parse(newEventResponse['end_time']),
        hasSpecificTime: newEventResponse['has_specific_time'] as bool,
        title: newEventResponse['title'],
        description: newEventResponse['description'],
        orderPosition: newEventResponse['orderPosition'] as int,
        place: Place(
            id: newEventResponse['place']?['id'] as int,
            name: newEventResponse['place']?['name'] ?? '',
            address: newEventResponse['place']?['address'] ?? '',
            placeType: newEventResponse['place']?['placeType'] ?? '',
            latitude: newEventResponse['place']?['latitude'] as double,
            longitude: newEventResponse['place']?['longitude'] as double,
        ),
      );

      // _events = List<TripEvent>.from(_events)..add(newEvent);
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Ошибка создания события: ${e.toString()}';
      notifyListeners();
    }
  }
  
  /// Update an existing event
  Future<void> updateEvent(String eventId, Map<String, dynamic> eventData) async {
    if (_trip == null || _selectedDay == null) return;
    
    try {
      final tripId = _trip!.id;
      final dayId = _selectedDay!.id;
      
      final updatedEventResponse = await _tripService.updateEvent(tripId, dayId, int.parse(eventId), eventData);
      final updatedEvent = TripEvent(
        id: updatedEventResponse['event_id'] as int,
        dayId: updatedEventResponse['day_id'] as int,
        startTime: DateTime.parse(updatedEventResponse['start_time']),
        endTime: DateTime.parse(updatedEventResponse['end_time']),
        hasSpecificTime: updatedEventResponse['has_specific_time'] as bool,
        title: updatedEventResponse['title'],
        description: updatedEventResponse['description'],
        orderPosition: updatedEventResponse['orderPosition'] as int,
        place: Place(
          id: updatedEventResponse['place']?['id'] as int,
          name: updatedEventResponse['place']?['name'] ?? '',
          address: updatedEventResponse['place']?['address'] ?? '',
          placeType: updatedEventResponse['place']?['placeType'] ?? '',
          latitude: updatedEventResponse['place']?['latitude'] as double,
          longitude: updatedEventResponse['place']?['longitude'] as double,
        ),
      );
      
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Ошибка обновления события: ${e.toString()}';
      notifyListeners();
    }
  }
  
  /// Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
} 