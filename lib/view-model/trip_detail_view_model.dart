import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:putevod/model/trip.dart';
import 'package:putevod/model/trip_detail.dart';
import 'package:putevod/model/trip_event.dart';
import 'package:putevod/external/trip_service.dart';

/// ViewModel for the trip detail screen
class TripDetailViewModel with ChangeNotifier {
  final TripService _tripService = TripService();
  
  /// Current trip detail
  TripDetail? _tripDetail;
  
  /// Selected day to view events
  DateTime? _selectedDay;
  
  /// Loading state indicator
  bool _isLoading = false;
  
  /// Error message
  String? _errorMessage;
  
  /// Getter for trip detail
  TripDetail? get tripDetail => _tripDetail;
  
  /// Getter for selected day
  DateTime? get selectedDay => _selectedDay;
  
  /// Getter for loading state
  bool get isLoading => _isLoading;
  
  /// Getter for error message
  String? get errorMessage => _errorMessage;
  
  /// Getter for events of the selected day
  List<TripEvent> get eventsForSelectedDay {
    if (_tripDetail == null || _selectedDay == null) {
      return [];
    }
    
    return _tripDetail!.getEventsForDay(_selectedDay!);
  }
  
  /// Loads trip detail data for the provided trip ID
  Future<void> loadTripDetail(int tripId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    
    try {
      final tripResponse = await _tripService.getTripById(tripId);
      
      if (tripResponse != null) {
        final trip = Trip.fromJson(tripResponse);
        
        // Получить все события поездки
        final eventsResponse = await _tripService.getTripEvents(tripId);
        final events = eventsResponse.map((eventData) => TripEvent(
          id: eventData['eventId'].toString(),
          time: eventData['startTime'] ?? '00:00',
          title: eventData['title'] ?? 'Без названия',
          address: eventData['place']?['address'] ?? '',
          day: DateTime.parse(eventData['day']['date']),
        )).toList();
        
        _tripDetail = TripDetail(trip: trip, events: events);
        
        // Select the first day by default
        if (_tripDetail != null && _tripDetail!.days.isNotEmpty) {
          _selectedDay = _tripDetail!.days.first;
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
  void selectDay(DateTime day) {
    _selectedDay = DateTime(day.year, day.month, day.day);
    notifyListeners();
  }
  
  /// Reorders events within the same day
  void reorderEvents(int oldIndex, int newIndex) {
    if (_tripDetail == null || _selectedDay == null) return;
    
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    
    final List<TripEvent> allEvents = List.from(_tripDetail!.events);
    final List<TripEvent> dayEvents = eventsForSelectedDay;
    
    if (oldIndex >= dayEvents.length || newIndex >= dayEvents.length) return;
    
    // Get the event to move
    final TripEvent event = dayEvents[oldIndex];
    
    // Remove all events for the selected day
    allEvents.removeWhere((e) => _isSameDay(e.day, _selectedDay!));
    
    // Create a new day event list with the reordering
    final List<TripEvent> newDayEvents = List.from(dayEvents);
    newDayEvents.removeAt(oldIndex);
    newDayEvents.insert(newIndex, event);
    
    // Add the reordered day events back to all events
    allEvents.addAll(newDayEvents);
    
    _tripDetail = _tripDetail!.copyWith(events: allEvents);
    notifyListeners();
  }
  
  /// Deletes an event by its ID
  Future<void> deleteEvent(String eventId) async {
    if (_tripDetail == null) return;
    
    try {
      // Найти событие для получения tripId и dayId
      final event = _tripDetail!.events.firstWhere((e) => e.id == eventId);
      final tripId = _tripDetail!.trip.id;
      
      // Найти dayId (пока используем простую логику)
      // TODO: Получить правильный dayId из API
      final dayId = 1; // Placeholder
      
      await _tripService.deleteEvent(tripId, dayId, int.parse(eventId));
      
      // Обновить локальный список
      final List<TripEvent> updatedEvents = _tripDetail!.events
          .where((event) => event.id != eventId)
          .toList();
      
      _tripDetail = _tripDetail!.copyWith(events: updatedEvents);
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Ошибка удаления события: ${e.toString()}';
      notifyListeners();
    }
  }
  
  /// Create a new event
  Future<void> createEvent(Map<String, dynamic> eventData) async {
    if (_tripDetail == null) return;
    
    try {
      final tripId = _tripDetail!.trip.id;
      // TODO: Получить правильный dayId
      final dayId = 1; // Placeholder
      
      final newEventResponse = await _tripService.createEvent(tripId, dayId, eventData);
      final newEvent = TripEvent(
        id: newEventResponse['eventId'].toString(),
        time: newEventResponse['startTime'] ?? '00:00',
        title: newEventResponse['title'] ?? 'Без названия',
        address: newEventResponse['place']?['address'] ?? '',
        day: DateTime.parse(newEventResponse['day']['date']),
      );
      
      final updatedEvents = List<TripEvent>.from(_tripDetail!.events)..add(newEvent);
      _tripDetail = _tripDetail!.copyWith(events: updatedEvents);
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Ошибка создания события: ${e.toString()}';
      notifyListeners();
    }
  }
  
  /// Update an existing event
  Future<void> updateEvent(String eventId, Map<String, dynamic> eventData) async {
    if (_tripDetail == null) return;
    
    try {
      final tripId = _tripDetail!.trip.id;
      // TODO: Получить правильный dayId
      final dayId = 1; // Placeholder
      
      final updatedEventResponse = await _tripService.updateEvent(tripId, dayId, int.parse(eventId), eventData);
      final updatedEvent = TripEvent(
        id: updatedEventResponse['eventId'].toString(),
        time: updatedEventResponse['startTime'] ?? '00:00',
        title: updatedEventResponse['title'] ?? 'Без названия',
        address: updatedEventResponse['place']?['address'] ?? '',
        day: DateTime.parse(updatedEventResponse['day']['date']),
      );
      
      final events = _tripDetail!.events.map((event) {
        return event.id == eventId ? updatedEvent : event;
      }).toList();
      
      _tripDetail = _tripDetail!.copyWith(events: events);
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Ошибка обновления события: ${e.toString()}';
      notifyListeners();
    }
  }
  
  /// Helper to check if two dates are the same day
  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
  
  /// Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
} 