import 'package:flutter/material.dart';
import 'dart:io';

import '../model/trip_event.dart';

class PlaceEditingViewModel extends ChangeNotifier {
  TripEvent? _tripEvent;
  
  final bool _isCreateMode;
  
  bool _isLoading = false;
  
  bool _isSaving = false;
  
  String? _errorMessage;
  
  int? _tripId;
  int? _dayId;
  
  final List<File> _attachedFiles = [];

  PlaceEditingViewModel({required bool isCreateMode, int? tripId, int? dayId}) :
    _isCreateMode = isCreateMode,
    _tripId = tripId,
    _dayId = dayId {
    if (isCreateMode) {
      _tripEvent = TripEvent.empty();
    }
  }

  TripEvent? get tripEvent => _tripEvent;
  
  bool get isCreateMode => _isCreateMode;

  bool get isUpdateMode => !_isCreateMode;
  
  bool get isLoading => _isLoading;
  
  bool get isSaving => _isSaving;
  
  String? get errorMessage => _errorMessage;
  
  List<File> get attachedFiles => List.unmodifiable(_attachedFiles);
  
  void setContext(int tripId, int dayId) {
    _tripId = tripId;
    _dayId = dayId;
  }
  
  void setPlaceType(String type) {
    if (_tripEvent == null) return;
    
    _tripEvent = _tripEvent!.copyWith(
        place: _tripEvent!.place.copyWith(
          placeType: type
        )
    );
    notifyListeners();
  }
  
  void setName(String name) {
    if (_tripEvent == null) return;
    
    _tripEvent = _tripEvent!.copyWith(title: name);
    notifyListeners();
  }

  void setDescription(String name) {
    if (_tripEvent == null) return;

    _tripEvent = _tripEvent!.copyWith(description: name);
    notifyListeners();
  }

  void setHasTime(bool value) {
    if (_tripEvent == null) return;

    _tripEvent = _tripEvent!.copyWith(hasSpecificTime: value);
    notifyListeners();
  }

  void setCoordinates(double latitude, double longitude) {
    if (_tripEvent == null) return;

    _tripEvent = _tripEvent!.copyWith(
      place: _tripEvent!.place.copyWith(
        latitude: latitude,
        longitude: longitude,
      )
    );
    notifyListeners();
  }

  void setStartTime(TimeOfDay time) {
    if (_tripEvent == null) return;

    DateTime dateTime = DateTime(0, 0, 0, time.hour, time.minute);

    _tripEvent = _tripEvent!.copyWith(startTime: dateTime);
    notifyListeners();
  }

  void setEndTime(TimeOfDay time) {
    if (_tripEvent == null) return;

    DateTime dateTime = DateTime(0, 0, 0, time.hour, time.minute);

    _tripEvent = _tripEvent!.copyWith(endTime: dateTime);
    notifyListeners();
  }

  void addAttachedFile(File file) {
    _attachedFiles.add(file);
    notifyListeners();
  }
  
  void removeAttachedFile(int index) {
    if (index >= 0 && index < _attachedFiles.length) {
      _attachedFiles.removeAt(index);
      notifyListeners();
    }
  }
  
  Future<void> loadPlace(int placeId) async {
    if (_isCreateMode) return;
    
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    
    try {
      if (_tripId == null || _dayId == null) {
        throw Exception('Trip ID and Day ID must be set before loading a place');
      }
      
      final eventId = placeId;
    } catch (e) {
      _errorMessage = 'Failed to load place: ${e.toString()}';
      debugPrint(_errorMessage);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  Future<bool> savePlaceChanges() async {
    if (_tripEvent == null) return false;
    
    _isSaving = true;
    _errorMessage = null;
    notifyListeners();
    
    try {
      if (_tripId == null || _dayId == null) {
        throw Exception('Trip ID and Day ID must be set before saving a place');
      }
      
      // final eventData = _eventService.placeToEventData(_tripEvent!);

      if (_isCreateMode) {
        // await _eventService.createEvent(_tripId!, _dayId!, eventData);
      } else {
        // Update existing event
        final eventId = _tripEvent!.id!;
        // await _eventService.updateEvent(_tripId!, _dayId!, eventId, eventData);
      }
      
      return true;
    } catch (e) {
      _errorMessage = 'Failed to save place: ${e.toString()}';
      debugPrint(_errorMessage);
      return false;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }
  
  /// Format time of day in 12-hour format (with AM/PM)
  String formatTimeOfDay(DateTime? timeOfDay) {
    if (timeOfDay == null) return '--:-- --';

    TimeOfDay time = TimeOfDay(hour: timeOfDay.hour, minute: timeOfDay.minute);
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    
    return '$hour:$minute $period';
  }
} 