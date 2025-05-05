import 'package:flutter/material.dart';
import 'package:putevod/model/place.dart';
import 'dart:io';

/// View model for place editing screen
class PlaceEditingViewModel extends ChangeNotifier {
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
  
  /// Attached files list (local File objects)
  final List<File> _attachedFiles = [];

  /// Creates a new place editing view model
  PlaceEditingViewModel({required bool isCreateMode}) : _isCreateMode = isCreateMode {
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
      // TODO: Implement actual API call to get place from backend
      await Future.delayed(const Duration(seconds: 1));
      
      // Placeholder implementation - replace with actual API call
      _place = Place(
        id: placeId,
        name: 'Sample Place',
        type: PlaceType.place,
        hasTime: true,
        startTime: const TimeOfDay(hour: 9, minute: 0),
        endTime: const TimeOfDay(hour: 11, minute: 0),
        latitude: 55.7558,
        longitude: 37.6176,
        notes: 'Sample notes about this place.',
      );
    } catch (e) {
      _errorMessage = 'Failed to load place: ${e.toString()}';
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
      // TODO: Implement actual API call to save place
      await Future.delayed(const Duration(seconds: 1));
      
      // Placeholder for actual save logic
      final successMessage = _isCreateMode ? 'Place created' : 'Place updated';
      debugPrint(successMessage);
      
      return true;
    } catch (e) {
      _errorMessage = 'Failed to save place: ${e.toString()}';
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