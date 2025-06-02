// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trip.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Trip _$TripFromJson(Map<String, dynamic> json) => Trip(
      id: json['id'] as int,
      name: json['title'] as String,
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
      imageUrl: json['previewUrl'] as String,
      country: json['country'] as String,
      city: json['city'] as String,
      description: json['description'] as String? ?? '',
      published: json['published'] as bool?,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
      days: (json['days'] as List<dynamic>?)
              ?.map((e) => TripDay.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      locations: const [],
    );

Map<String, dynamic> _$TripToJson(Trip instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.name,
      'startDate': instance.startDate.toIso8601String(),
      'endDate': instance.endDate.toIso8601String(),
      'previewUrl': instance.imageUrl,
      'country': instance.country,
      'city': instance.city,
      'description': instance.description,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'days': instance.days,
      'version': instance.version,
      'published': instance.published,
    };
