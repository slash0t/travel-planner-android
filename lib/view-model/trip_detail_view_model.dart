import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:putevod/model/trip.dart';
import 'package:putevod/model/trip_detail.dart';
import 'package:putevod/model/trip_event.dart';
import 'package:uuid/uuid.dart';

/// ViewModel for the trip detail screen
class TripDetailViewModel with ChangeNotifier {
  /// Current trip detail
  TripDetail? _tripDetail;
  
  /// Selected day to view events
  DateTime? _selectedDay;
  
  /// Loading state indicator
  bool _isLoading = false;
  
  /// Getter for trip detail
  TripDetail? get tripDetail => _tripDetail;
  
  /// Getter for selected day
  DateTime? get selectedDay => _selectedDay;
  
  /// Getter for loading state
  bool get isLoading => _isLoading;
  
  /// Getter for events of the selected day
  List<TripEvent> get eventsForSelectedDay {
    if (_tripDetail == null || _selectedDay == null) {
      return [];
    }
    
    return _tripDetail!.getEventsForDay(_selectedDay!);
  }
  
  /// Loads trip detail data for the provided trip ID
  Future<void> loadTripDetail(String tripId) async {
    _isLoading = true;
    notifyListeners();
    
    try {
      // In a real app, this would fetch data from a repository
      // For now, we'll create mock data
      await Future.delayed(const Duration(milliseconds: 500));
      _tripDetail = await _createMockTripDetail(tripId);
      
      // Select the first day by default
      if (_tripDetail != null && _tripDetail!.days.isNotEmpty) {
        _selectedDay = _tripDetail!.days.first;
      }
    } catch (e) {
      debugPrint('Error loading trip detail: $e');
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
  void deleteEvent(String eventId) {
    if (_tripDetail == null) return;
    
    final List<TripEvent> updatedEvents = _tripDetail!.events
        .where((event) => event.id != eventId)
        .toList();
    
    _tripDetail = _tripDetail!.copyWith(events: updatedEvents);
    notifyListeners();
  }
  
  /// Helper to check if two dates are the same day
  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
  
  /// Creates mock trip detail data for demo
  Future<TripDetail> _createMockTripDetail(String tripId) async {
    // Create a mock trip
    final trip = Trip(
      id: tripId,
      name: 'Путешествие в Париж',
      startDate: DateTime(2025, 3, 15),
      endDate: DateTime(2025, 3, 22),
      status: TripStatus.upcoming,
      imageUrl: 'assets/images/paris.jpg',
      destination: 'Париж, Франция',
    );
    
    // Create mock events
    final events = [
      // Day 1 - March 15
      TripEvent(
        id: const Uuid().v4(),
        time: '09:00',
        title: 'Эйфелева башня',
        address: 'Champ de Mars, 5 Avenue',
        day: DateTime(2025, 3, 15),
      ),
      TripEvent(
        id: const Uuid().v4(),
        time: '12:30',
        title: 'Лувр',
        address: 'Rue de Rivoli, 75001',
        day: DateTime(2025, 3, 15),
      ),
      
      // Day 2 - March 16
      TripEvent(
        id: const Uuid().v4(),
        time: '10:00',
        title: 'Собор Парижской Богоматери',
        address: '6 Parvis Notre-Dame',
        day: DateTime(2025, 3, 16),
      ),
      
      // Day 3 - March 17
      TripEvent(
        id: const Uuid().v4(),
        time: '11:00',
        title: 'Триумфальная арка',
        address: 'Place Charles de Gaulle',
        day: DateTime(2025, 3, 17),
      ),
      
      // Day 4 - March 18
      TripEvent(
        id: const Uuid().v4(),
        time: '09:30',
        title: 'Монмартр',
        address: 'Montmartre, 75018',
        day: DateTime(2025, 3, 18),
      ),
    ];
    
    return TripDetail(trip: trip, events: events);
  }
} 