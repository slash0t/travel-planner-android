import 'package:flutter/material.dart';
import 'package:putevod/model/trip.dart';
import 'package:putevod/external/sync_service.dart';

/// View model for trip creation and editing
class TripCreationViewModel extends ChangeNotifier {
  /// Text controller for trip name input
  final TextEditingController nameController = TextEditingController();
  
  /// Text controller for trip country input
  final TextEditingController countryController = TextEditingController();
  
  /// Text controller for trip city input
  final TextEditingController cityController = TextEditingController();
  
  /// Text controller for trip description input
  final TextEditingController descriptionController = TextEditingController();
  
  /// Whether the screen is in editing mode
  late bool isEditingMode = false;
  
  /// The trip being edited, null if creating a new trip
  Trip? _tripToEdit;

  /// Currently selected start date for the trip
  DateTime? _startDate;
  
  /// Currently selected end date for the trip
  DateTime? _endDate;

  /// Currently displayed month in calendar
  DateTime _currentMonth = DateTime.now();

  /// Gets the currently selected start date
  DateTime? get startDate => _startDate;

  /// Gets the currently selected end date
  DateTime? get endDate => _endDate;

  /// Gets the current month displayed in calendar
  DateTime get currentMonth => _currentMonth;

  /// Initializes the view model for editing an existing trip
  void initForEditing(Trip trip) {
    _tripToEdit = trip;
    isEditingMode = true;
    
    nameController.text = trip.name;
    countryController.text = trip.country;
    cityController.text = trip.city;
    descriptionController.text = trip.description;
    
    _startDate = trip.startDate;
    _endDate = trip.endDate;
    _currentMonth = DateTime(trip.startDate.year, trip.startDate.month, 1);
    
    notifyListeners();
  }

  /// Initializes the view model for creating a new trip
  void initForCreation() {
    isEditingMode = false;
    _tripToEdit = null;
    
    nameController.clear();
    countryController.clear();
    cityController.clear();
    descriptionController.clear();
    
    _startDate = null;
    _endDate = null;
    _currentMonth = DateTime.now();
    
    notifyListeners();
  }

  /// Moves to the next month in calendar
  void nextMonth() {
    if (_currentMonth.month == 12) {
      _currentMonth = DateTime(_currentMonth.year + 1, 1, 1);
    } else {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month + 1, 1);
    }
    notifyListeners();
  }

  /// Moves to the previous month in calendar
  void previousMonth() {
    if (_currentMonth.month == 1) {
      _currentMonth = DateTime(_currentMonth.year - 1, 12, 1);
    } else {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month - 1, 1);
    }
    notifyListeners();
  }

  /// Sets the trip date range
  void setDateRange(DateTime start, DateTime? end) {
    _startDate = start;
    _endDate = end ?? start;
    notifyListeners();
  }

  /// Validates that all required field have been completed
  bool validateForm() {
    return nameController.text.isNotEmpty && 
           _startDate != null && 
           _endDate != null;
  }

  /// Saves the trip data
  Future<Trip> saveTrip() async {
    if (_startDate == null || _endDate == null) {
      throw Exception('Даты поездки должны быть заданы');
    }

    final tripData = {
      'title': nameController.text,
      'startDate': _startDate!.toIso8601String(),
      'endDate': _endDate!.toIso8601String(),
      'country': countryController.text,
      'city': cityController.text,
      'description': descriptionController.text,
    };
    
    if (isEditingMode && _tripToEdit != null) {
      // Update existing trip
      await SyncService.instance.updateTrip(_tripToEdit!.id, tripData);
      return _tripToEdit!.copyWith(
        name: nameController.text,
        startDate: _startDate!,
        endDate: _endDate!,
        country: countryController.text,
        city: cityController.text,
        description: descriptionController.text,
      );
    } else {
      // Create new trip
      await SyncService.instance.createTrip(tripData);
      
      // Return a temp trip object (actual trip will be loaded from server)
      return Trip(
        id: 0, // Will be replaced with real ID from server
        name: nameController.text,
        startDate: _startDate!,
        endDate: _endDate!,
        status: TripStatus.upcoming,
        imageUrl: '',
        destination: '${cityController.text}, ${countryController.text}',
        country: countryController.text,
        city: cityController.text,
        description: descriptionController.text,
      );
    }
  }
  
  @override
  void dispose() {
    nameController.dispose();
    countryController.dispose();
    cityController.dispose();
    descriptionController.dispose();
    super.dispose();
  }
} 