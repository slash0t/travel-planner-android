// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'place.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Place _$PlaceFromJson(Map<String, dynamic> json) => Place(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      type: $enumDecode(_$PlaceTypeEnumMap, json['type']),
      hasTime: json['hasTime'] as bool? ?? false,
      startTime: _timeFromJson(json['startTime'] as String?),
      endTime: _timeFromJson(json['endTime'] as String?),
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      notes: json['notes'] as String?,
      attachedFiles: (json['attachedFiles'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$PlaceToJson(Place instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'type': _$PlaceTypeEnumMap[instance.type]!,
      'hasTime': instance.hasTime,
      'startTime': _timeToJson(instance.startTime),
      'endTime': _timeToJson(instance.endTime),
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'notes': instance.notes,
      'attachedFiles': instance.attachedFiles,
    };

const _$PlaceTypeEnumMap = {
  PlaceType.place: 'place',
  PlaceType.restaurant: 'restaurant',
  PlaceType.event: 'event',
};
