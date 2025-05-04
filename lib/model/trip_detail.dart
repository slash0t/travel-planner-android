import 'package:putevod/model/trip.dart';
import 'package:putevod/model/trip_event.dart';

/// Model representing a detailed trip with events
class TripDetail {
  /// The base trip information
  final Trip trip;
  
  /// List of all events in this trip
  final List<TripEvent> events;
  
  /// Creates a new trip detail instance
  const TripDetail({
    required this.trip,
    required this.events,
  });
  
  /// Returns all unique days in this trip with events
  List<DateTime> get days {
    final uniqueDays = <DateTime>{};
    for (final event in events) {
      // Add only the date part without time
      uniqueDays.add(DateTime(
        event.day.year,
        event.day.month,
        event.day.day,
      ));
    }
    
    // Sort days chronologically
    final result = uniqueDays.toList()
      ..sort((a, b) => a.compareTo(b));
    return result;
  }
  
  /// Returns all events for a specific day
  List<TripEvent> getEventsForDay(DateTime day) {
    final dayWithoutTime = DateTime(day.year, day.month, day.day);
    return events
        .where((event) {
          final eventDay = DateTime(
            event.day.year,
            event.day.month,
            event.day.day,
          );
          return eventDay == dayWithoutTime;
        })
        .toList();
  }
  
  /// Creates a copy of this trip detail with the given fields replaced
  TripDetail copyWith({
    Trip? trip,
    List<TripEvent>? events,
  }) {
    return TripDetail(
      trip: trip ?? this.trip,
      events: events ?? this.events,
    );
  }
} 