// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trip_location.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TripLocation _$TripLocationFromJson(Map<String, dynamic> json) => TripLocation(
      id: json['id'] as String,
      name: json['name'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      dayNumber: json['dayNumber'] as int,
      startTime: json['startTime'] as String,
      endTime: json['endTime'] as String,
      orderInDay: json['orderInDay'] as int,
    );

Map<String, dynamic> _$TripLocationToJson(TripLocation instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'dayNumber': instance.dayNumber,
      'startTime': instance.startTime,
      'endTime': instance.endTime,
      'orderInDay': instance.orderInDay,
    }; 