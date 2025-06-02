import 'package:flutter/material.dart';
import 'package:putevod/model/place.dart';
import 'package:putevod/external/event_service.dart';
import 'dart:io';

/// View model for place editing screen
class PlaceEditingViewModel extends ChangeNotifier {
  /// Event service for API calls
  final EventService _eventService = EventService();
  
  /// Current place being edited
  Place? _place;
  
  /// Whether the screen is in create mode (true) or update mode (false)
  final bool _isCreateMode;
  
  /// Whether the view model is currently loading data
  bool _isLoading = false;
  
  /// Whether the view model is currently saving data
  bool _isSaving = false;
  
  /// Error message to display, if any
  String? _errorMessage;
  
  /// Trip ID and Day ID for API context
  int? _tripId;
  int? _dayId;
  
  /// Attached files list (local File objects)
  final List<File> _attachedFiles = [];

  /// Creates a new place editing view model
  PlaceEditingViewModel({required bool isCreateMode, int? tripId, int? dayId}) : 
    _isCreateMode = isCreateMode,
    _tripId = tripId,
    _dayId = dayId {
    if (isCreateMode) {
      _place = Place.empty();
    }
  }

  /// Gets the current place being edited
  Place? get place => _place;
  
  /// Whether the screen is in create mode
  bool get isCreateMode => _isCreateMode;
  
  /// Whether the screen is in update mode
  bool get isUpdateMode => !_isCreateMode;
  
  /// Whether the view model is currently loading data
  bool get isLoading => _isLoading;
  
  /// Whether the view model is currently saving data
  bool get isSaving => _isSaving;
  
  /// Error message to display, if any
  String? get errorMessage => _errorMessage;
  
  /// Local attached files
  List<File> get attachedFiles => List.unmodifiable(_attachedFiles);
  
  /// Sets the trip and day context
  void setContext(int tripId, int dayId) {
    _tripId = tripId;
    _dayId = dayId;
  }
  
  /// Sets the place type
  void setPlaceType(PlaceType type) {
    if (_place == null) return;
    
    _place = _place!.copyWith(type: type);
    notifyListeners();
  }
  
  /// Sets the place name
  void setName(String name) {
    if (_place == null) return;
    
    _place = _place!.copyWith(name: name);
    notifyListeners();
  }
  
  /// Sets whether the place has a specified time
  void setHasTime(bool hasTime) {
    if (_place == null) return;
    
    _place = _place!.copyWith(hasTime: hasTime);
    notifyListeners();
  }
  
  /// Sets the start time
  void setStartTime(TimeOfDay time) {
    if (_place == null) return;
    
    _place = _place!.copyWith(startTime: time);
    notifyListeners();
  }
  
  /// Sets the end time
  void setEndTime(TimeOfDay time) {
    if (_place == null) return;
    
    _place = _place!.copyWith(endTime: time);
    notifyListeners();
  }
  
  /// Sets the coordinates
  void setCoordinates(double latitude, double longitude) {
    if (_place == null) return;
    
    _place = _place!.copyWith(
      latitude: latitude,
      longitude: longitude,
    );
    notifyListeners();
  }
  
  /// Sets the notes
  void setNotes(String notes) {
    if (_place == null) return;
    
    _place = _place!.copyWith(notes: notes);
    notifyListeners();
  }
  
  /// Adds a new attached file
  void addAttachedFile(File file) {
    _attachedFiles.add(file);
    notifyListeners();
  }
  
  /// Removes an attached file
  void removeAttachedFile(int index) {
    if (index >= 0 && index < _attachedFiles.length) {
      _attachedFiles.removeAt(index);
      notifyListeners();
    }
  }
  
  /// Loads a place by ID (for update mode)
  Future<void> loadPlace(String placeId) async {
    if (_isCreateMode) return;
    
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    
    try {
      // Validate context is set
      if (_tripId == null || _dayId == null) {
        throw Exception('Trip ID and Day ID must be set before loading a place');
      }
      
      // Convert placeId to eventId (same concept in our app)
      final eventId = int.parse(placeId);
      
      // Call API
      final eventData = await _eventService.getEvent(_tripId!, _dayId!, eventId);
      
      // Convert to Place model
      _place = _eventService.eventDataToPlace(eventData);
    } catch (e) {
      _errorMessage = 'Failed to load place: ${e.toString()}';
      debugPrint(_errorMessage);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  /// Saves the current place
  Future<bool> savePlaceChanges() async {
    if (_place == null) return false;
    
    _isSaving = true;
    _errorMessage = null;
    notifyListeners();
    
    try {
      // Validate context is set
      if (_tripId == null || _dayId == null) {
        throw Exception('Trip ID and Day ID must be set before saving a place');
      }
      
      // Convert Place to API format
      final eventData = _eventService.placeToEventData(_place!);
      
      if (_isCreateMode) {
        // Create new event
        await _eventService.createEvent(_tripId!, _dayId!, eventData);
      } else {
        // Update existing event
        final eventId = _place!.id!;
        await _eventService.updateEvent(_tripId!, _dayId!, eventId, eventData);
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
  String formatTimeOfDay(TimeOfDay? timeOfDay) {
    if (timeOfDay == null) return '--:-- --';
    
    final hour = timeOfDay.hourOfPeriod == 0 ? 12 : timeOfDay.hourOfPeriod;
    final minute = timeOfDay.minute.toString().padLeft(2, '0');
    final period = timeOfDay.period == DayPeriod.am ? 'AM' : 'PM';
    
    return '$hour:$minute $period';
  }
} 