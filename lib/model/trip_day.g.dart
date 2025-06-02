// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trip_day.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TripDay _$TripDayFromJson(Map<String, dynamic> json) => TripDay(
      id: json['id'] as int,
      tripId: json['tripId'] as int,
      dayNumber: json['dayNumber'] as int,
      date: DateTime.parse(json['date'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$TripDayToJson(TripDay instance) => <String, dynamic>{
      'id': instance.id,
      'tripId': instance.tripId,
      'dayNumber': instance.dayNumber,
      'date': instance.date.toIso8601String(),
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    }; 