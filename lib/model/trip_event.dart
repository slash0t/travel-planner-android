import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'package:putevod/model/place.dart';

class TripEvent {
  final int id;

  final int dayId;

  final Place place;

  final String title;

  final String description;

  final DateTime? startTime;

  final DateTime? endTime;

  final bool hasSpecificTime;

  final int orderPosition;

  const TripEvent({
    required this.id,
    required this.dayId,
    required this.place,
    required this.title,
    required this.description,
    this.startTime,
    this.endTime,
    required this.hasSpecificTime,
    required this.orderPosition,
  });
  
  TripEvent copyWith({
    int? id,
    int? dayId,
    Place? place,
    String? title,
    String? description,
    DateTime? startTime,
    DateTime? endTime,
    bool? hasSpecificTime,
    int? orderPosition,
  }) {
    return TripEvent(
      id: id ?? this.id,
      dayId: dayId ?? this.dayId,
      place: place ?? this.place,
      title: title ?? this.title,
      description: description ?? this.description,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      hasSpecificTime: hasSpecificTime ?? this.hasSpecificTime,
      orderPosition: orderPosition ?? this.orderPosition,
    );
  }

  factory TripEvent.empty() {
    return TripEvent(
      id: 0,
      dayId: 0,
      place: Place.empty(),
      title: "",
      description: "",
      hasSpecificTime: false,
      orderPosition: 0
    );
  }

  String get formatTime {
    if (!hasSpecificTime) return "";

    final DateFormat formatter = DateFormat('HH:mm');
    return '${formatter.format(startTime!)}-${formatter.format(endTime!)}';
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'dayId': dayId,
    'place': place.toJson(),
    'title': title,
    'description': description,
    'startTime': startTime?.toIso8601String(),
    'endTime': endTime?.toIso8601String(),
    'hasSpecificTime': hasSpecificTime,
    'orderPosition': orderPosition,
  };

  factory TripEvent.fromJson(Map<String, dynamic> json) => TripEvent(
    id: json['id'] as int,
    dayId: json['dayId'] as int,
    place: Place.fromJson(json['place'] as Map<String, dynamic>),
    title: json['title'] as String,
    description: json['description'] as String,
    startTime: json['startTime'] != null ? DateTime.parse(json['startTime'] as String) : null,
    endTime: json['endTime'] != null ? DateTime.parse(json['endTime'] as String) : null,
    hasSpecificTime: json['hasSpecificTime'] as bool,
    orderPosition: json['orderPosition'] as int,
  );
} 