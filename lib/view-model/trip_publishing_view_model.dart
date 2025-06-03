import 'package:flutter/material.dart';
import 'package:putevod/model/trip.dart';

/// Categories for trip publications
enum TripCategory {
  /// Cultural tourism
  culturalTourism,
  
  /// Active tourism
  activeTourism,
  
  /// Sacred places tourism
  sacredPlacesTourism,
  
  /// Beach vacation
  beachVacation,
  
  /// City tours
  cityTours,
  
  /// Adventures
  adventures,
}

/// Extension on TripCategory to get display name
extension TripCategoryExtension on TripCategory {
  /// Get display name for category
  String get displayName {
    switch (this) {
      case TripCategory.culturalTourism:
        return 'Культурный туризм';
      case TripCategory.activeTourism:
        return 'Активный отдых';
      case TripCategory.sacredPlacesTourism:
        return 'Тур по культовым местам';
      case TripCategory.beachVacation:
        return 'Пляжный отдых';
      case TripCategory.cityTours:
        return 'Городские туры';
      case TripCategory.adventures:
        return 'Приключения';
    }
  }
}

/// View model for trip publishing screen
class TripPublishingViewModel extends ChangeNotifier {
  /// List of available trips
  final List<Trip> _trips = [];
  
  /// Selected trip
  Trip? _selectedTrip;
  
  /// Description controller
  final TextEditingController descriptionController = TextEditingController();
  
  /// Tags controller
  final TextEditingController tagsController = TextEditingController();
  
  /// Selected category
  TripCategory _selectedCategory = TripCategory.culturalTourism;
  
  /// Whether to include personal notes in publication
  bool _includePersonalNotes = false;
  
  /// Whether to include selected days and events in publication
  bool _includeDaysAndEvents = true;
  
  /// Upload image URL
  String _coverImageUrl = '';
  
  /// Whether publication is public
  bool _isPublic = true;
  
  /// Whether publication is link-only
  bool _isLinkOnly = false;
  
  /// Whether user has agreed to terms
  bool _agreedToTerms = false;
  
  /// Loading state
  bool _isLoading = false;
  
  /// Error message
  String? _errorMessage;

  /// Constructor
  TripPublishingViewModel() {
    _loadTrips();
  }

  /// Gets the list of trips
  List<Trip> get trips => _trips;
  
  /// Gets the selected trip
  Trip? get selectedTrip => _selectedTrip;
  
  /// Sets the selected trip
  set selectedTrip(Trip? trip) {
    _selectedTrip = trip;
    notifyListeners();
  }
  
  /// Gets the selected category
  TripCategory get selectedCategory => _selectedCategory;
  
  /// Sets the selected category
  set selectedCategory(TripCategory category) {
    _selectedCategory = category;
    notifyListeners();
  }
  
  /// Gets whether to include personal notes
  bool get includePersonalNotes => _includePersonalNotes;
  
  /// Sets whether to include personal notes
  set includePersonalNotes(bool value) {
    _includePersonalNotes = value;
    notifyListeners();
  }
  
  /// Gets whether to include selected days and events
  bool get includeDaysAndEvents => _includeDaysAndEvents;
  
  /// Sets whether to include selected days and events
  set includeDaysAndEvents(bool value) {
    _includeDaysAndEvents = value;
    notifyListeners();
  }
  
  /// Gets the cover image URL
  String get coverImageUrl => _coverImageUrl;
  
  /// Sets the cover image URL
  set coverImageUrl(String url) {
    _coverImageUrl = url;
    notifyListeners();
  }
  
  /// Gets whether publication is public
  bool get isPublic => _isPublic;
  
  /// Sets whether publication is public
  set isPublic(bool value) {
    _isPublic = value;
    if (value) {
      _isLinkOnly = false;
    }
    notifyListeners();
  }
  
  /// Gets whether publication is link-only
  bool get isLinkOnly => _isLinkOnly;
  
  /// Sets whether publication is link-only
  set isLinkOnly(bool value) {
    _isLinkOnly = value;
    if (value) {
      _isPublic = false;
    }
    notifyListeners();
  }
  
  /// Gets whether user has agreed to terms
  bool get agreedToTerms => _agreedToTerms;
  
  /// Sets whether user has agreed to terms
  set agreedToTerms(bool value) {
    _agreedToTerms = value;
    notifyListeners();
  }
  
  /// Gets loading state
  bool get isLoading => _isLoading;
  
  /// Gets error message
  String? get errorMessage => _errorMessage;

  /// Loads trips from API
  Future<void> _loadTrips() async {
    _isLoading = true;
    notifyListeners();
    
    try {
      // Simulating API call with mock data
      await Future.delayed(const Duration(milliseconds: 500));
      
      _trips.addAll([]);
      
      _errorMessage = null;
    } catch (e) {
      _errorMessage = 'Ошибка загрузки поездок: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Publishes the trip
  Future<bool> publishTrip() async {
    if (_selectedTrip == null) {
      _errorMessage = 'Выберите поездку для публикации';
      notifyListeners();
      return false;
    }
    
    if (!_agreedToTerms) {
      _errorMessage = 'Необходимо согласиться с правилами публикации';
      notifyListeners();
      return false;
    }
    
    _isLoading = true;
    notifyListeners();
    
    try {
      // Simulating API call
      await Future.delayed(const Duration(seconds: 1));
      
      // Publication data would be sent to backend here
      final publicationData = {
        'tripId': _selectedTrip!.id,
        'description': descriptionController.text,
        'tags': tagsController.text,
        'category': _selectedCategory.toString(),
        'includePersonalNotes': _includePersonalNotes,
        'includeDaysAndEvents': _includeDaysAndEvents,
        'coverImageUrl': _coverImageUrl.isEmpty 
            ? _selectedTrip!.previewUrl
            : _coverImageUrl,
        'isPublic': _isPublic,
        'isLinkOnly': _isLinkOnly,
      };
      
      print('Publishing trip with data: $publicationData');
      
      _errorMessage = null;
      return true;
    } catch (e) {
      _errorMessage = 'Ошибка публикации поездки: $e';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  /// Pick an image from gallery
  Future<void> pickImage() async {
    // This would typically connect to an image picker
    // For now, we'll just set a dummy URL
    _coverImageUrl = 'https://images.unsplash.com/photo-1503917988258-f87a78e3c995?q=80&w=2934&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D';
    notifyListeners();
  }

  @override
  void dispose() {
    descriptionController.dispose();
    tagsController.dispose();
    super.dispose();
  }
} 