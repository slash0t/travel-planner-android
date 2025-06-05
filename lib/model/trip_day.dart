import 'package:putevod/model/trip_event.dart';

class TripDay {
  final int id;
  
  final int tripId;
  
  final int dayNumber;
  
  final DateTime date;
  
  final List<TripEvent> events;
  
  TripDay({
    required this.id,
    required this.tripId,
    required this.dayNumber,
    required this.date,
    required this.events,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'tripId': tripId,
    'dayNumber': dayNumber,
    'date': date.toIso8601String(),
    'events': events.map((event) => event.toJson()).toList(),
  };

  factory TripDay.fromJson(Map<String, dynamic> json) => TripDay(
    id: json['id'] as int,
    tripId: json['tripId'] as int,
    dayNumber: json['dayNumber'] as int,
    date: DateTime.parse(json['date'] as String),
    events: (json['events'] as List<dynamic>)
        .map((e) => TripEvent.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}