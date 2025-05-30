import 'package:flutter/material.dart';
import 'package:putevod/external/api_client.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

/// ViewModel for the profile screen
class ProfileViewModel extends ChangeNotifier {
  final ApiClient _plannerClient = ApiClients.planner;

  String _username = '';
  String _email = '';
  String _password = '************';
  bool _isAdmin = false;
  int _userId = 0;
  bool _isLoading = true;
  
  int _tripsCount = 0;
  int _placesCount = 0;
  int _photosCount = 0;
  
  /// Gets the user's username
  String get username => _username;
  
  /// Gets the user's email
  String get email => _email;
  
  /// Gets the masked password
  String get password => _password;
  
  /// Gets whether user is admin
  bool get isAdmin => _isAdmin;
  
  /// Gets the user's ID
  int get userId => _userId;
  
  /// Gets loading state
  bool get isLoading => _isLoading;
  
  /// Gets the user's status text
  String get status => _isAdmin ? 'Админ путешествий' : 'Путешественник';
  
  /// Gets the number of trips
  int get tripsCount => _tripsCount;
  
  /// Gets the number of places
  int get placesCount => _placesCount;
  
  /// Gets the number of photos
  int get photosCount => _photosCount;
  
  /// Constructor that fetches profile data
  ProfileViewModel() {
    fetchProfileData();
  }
  
  /// Fetches profile data from backend
  Future<void> fetchProfileData() async {
    _isLoading = true;
    notifyListeners();
    
    try {
      // Fetch user profile data
      final userResponse = await _plannerClient.get(
          '/users/me'
      );

      if (userResponse.statusCode == 200) {
        final userData = userResponse.data;

        _userId = userData['id'];
        _username = userData['username'];
        _email = userData['email'];
        _isAdmin = userData['admin'];

        // Fetch trips count
        await fetchTripsCount();
      } else {
        // Handle error
        print('Failed to load profile: ${userResponse.statusCode}');
      }
    } catch (e) {
      print('Error fetching profile data: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  /// Fetches trips count from backend
  Future<void> fetchTripsCount() async {
    try {
      final tripsResponse = await _plannerClient.get("/trips");
      // final tripsResponse = await http.get(
      //   Uri.parse('https://putevod-app.ru/planner/api/v1/trips'),
      // );
      
      if (tripsResponse.statusCode == 200) {
        final tripsData = tripsResponse.data;
        _tripsCount = tripsData['totalElements'] as int;

      } else {
        print('Failed to load trips: ${tripsResponse.statusCode}');
      }
    } catch (e) {
      print('Error fetching trips data: $e');
    }
  }
  
  /// Updates the user's username
  void updateUsername(String value) {
    _username = value;
    notifyListeners();
  }
  
  /// Updates the user's email
  void updateEmail(String value) {
    _email = value;
    notifyListeners();
  }
  
  /// Updates the user's password
  void updatePassword(String value) {
    _password = value;
    notifyListeners();
  }
  
  /// Saves the user profile changes
  Future<bool> saveChanges() async {
    try {

      
      return true;
    } catch (e) {
      print('Error saving profile changes: $e');
      return false;
    }
  }
} 