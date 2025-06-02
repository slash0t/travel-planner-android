import 'package:flutter/material.dart';
import 'package:putevod/model/place.dart';
import 'package:putevod/external/api_client.dart';
import 'package:putevod/external/trip_service.dart';

/// Service for handling event API requests
class EventService {
  final ApiClient _plannerClient = ApiClients.planner;
  final TripService _tripService = TripService();

  /// Get event by ID
  Future<Map<String, dynamic>> getEvent(int tripId, int dayId, int eventId) async {
    // Use the existing TripService implementation
    return await _tripService.getEvent(tripId, dayId, eventId);
  }
  
  /// Create a new event
  Future<Map<String, dynamic>> createEvent(int tripId, int dayId, Map<String, dynamic> eventData) async {
    // Use the existing TripService implementation
    return await _tripService.createEvent(tripId, dayId, eventData);
  }
  
  /// Update an event
  Future<Map<String, dynamic>> updateEvent(int tripId, int dayId, int eventId, Map<String, dynamic> eventData) async {
    // Use the existing TripService implementation
    return await _tripService.updateEvent(tripId, dayId, eventId, eventData);
  }
  
  /// Delete an event
  Future<void> deleteEvent(int tripId, int dayId, int eventId) async {
    // Use the existing TripService implementation
    await _tripService.deleteEvent(tripId, dayId, eventId);
  }
  
  /// Convert Place model to API event data
  Map<String, dynamic> placeToEventData(Place place) {
    final Map<String, dynamic> placeData = {
      'title': place.name,
      'description': place.notes ?? '',
      'hasSpecificTime': place.hasTime,
      'place': <String, dynamic>{
        'name': place.name,
        'placeType': _placeTypeToString(place.type),
      }
    };
    
    if (place.hasTime) {
      if (place.startTime != null) {
        placeData['startTime'] = _formatTimeOfDay(place.startTime!);
      }
      if (place.endTime != null) {
        placeData['endTime'] = _formatTimeOfDay(place.endTime!);
      }
    }
    
    if (place.latitude != null && place.longitude != null) {
      final placeMap = placeData['place'] as Map<String, dynamic>;
      placeMap['latitude'] = place.latitude;
      placeMap['longitude'] = place.longitude;
    }
    
    return placeData;
  }
  
  /// Convert API event data to Place model
  Place eventDataToPlace(Map<String, dynamic> eventData) {
    final placeData = eventData['place'] ?? {};
    
    TimeOfDay? startTime;
    TimeOfDay? endTime;
    
    if (eventData['hasSpecificTime'] == true) {
      if (eventData['startTime'] != null) {
        final timeParts = eventData['startTime'].split(':');
        startTime = TimeOfDay(
          hour: int.parse(timeParts[0]),
          minute: int.parse(timeParts[1]),
        );
      }
      
      if (eventData['endTime'] != null) {
        final timeParts = eventData['endTime'].split(':');
        endTime = TimeOfDay(
          hour: int.parse(timeParts[0]),
          minute: int.parse(timeParts[1]),
        );
      }
    }
    
    return Place(
      id: eventData['id'],
      name: eventData['title'] ?? '',
      type: _stringToPlaceType(placeData['placeType']),
      hasTime: eventData['hasSpecificTime'] ?? false,
      startTime: startTime,
      endTime: endTime,
      latitude: placeData['latitude'],
      longitude: placeData['longitude'],
      notes: eventData['description'],
    );
  }
  
  /// Convert PlaceType enum to string
  String _placeTypeToString(PlaceType type) {
    switch (type) {
      case PlaceType.place:
        return 'PLACE';
      case PlaceType.restaurant:
        return 'RESTAURANT';
      case PlaceType.event:
        return 'EVENT';
      default:
        return 'PLACE';
    }
  }
  
  /// Convert string to PlaceType enum
  PlaceType _stringToPlaceType(String? type) {
    switch (type?.toUpperCase()) {
      case 'RESTAURANT':
        return PlaceType.restaurant;
      case 'EVENT':
        return PlaceType.event;
      case 'PLACE':
      default:
        return PlaceType.place;
    }
  }
  
  /// Format TimeOfDay to string (HH:mm)
  String _formatTimeOfDay(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
} 