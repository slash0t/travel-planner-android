import 'package:putevod/model/trip_day.dart';
import 'package:putevod/model/trip_event.dart';

/// Utility functions for handling trip events
class TripEventUtils {
  /// Returns all unique days with events
  static List<DateTime> getUniqueDays(List<TripEvent> events) {
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
  static List<TripEvent> getEventsForDay(List<TripEvent> events, TripDay day) {
    final dayDate = day.date;
    final dayWithoutTime = DateTime(dayDate.year, dayDate.month, dayDate.day);
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
  
  /// Checks if a TripEvent belongs to a TripDay
  static bool isEventInDay(TripEvent event, TripDay day) {
    final dayDate = day.date;
    return event.day.year == dayDate.year && 
           event.day.month == dayDate.month && 
           event.day.day == dayDate.day;
  }
  
  /// Checks if two dates represent the same day
  static bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
} 