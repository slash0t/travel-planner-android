import 'package:flutter/material.dart';

/// ViewModel for the profile screen
class ProfileViewModel extends ChangeNotifier {
  String _nickname = 'ivan_sahalin';
  String _email = 'melpeters@gmail.com';
  String _password = '************';
  String _name = 'Иван Баранов';
  String _status = 'Путешественник';
  
  int _tripsCount = 12;
  int _placesCount = 27;
  int _photosCount = 69;
  
  /// Gets the user's nickname
  String get nickname => _nickname;
  
  /// Gets the user's email
  String get email => _email;
  
  /// Gets the masked password
  String get password => _password;
  
  /// Gets the user's full name
  String get name => _name;
  
  /// Gets the user's status
  String get status => _status;
  
  /// Gets the number of trips
  int get tripsCount => _tripsCount;
  
  /// Gets the number of places
  int get placesCount => _placesCount;
  
  /// Gets the number of photos
  int get photosCount => _photosCount;
  
  /// Updates the user's nickname
  void updateNickname(String value) {
    _nickname = value;
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
  
  /// Updates the user's name
  void updateName(String value) {
    _name = value;
    notifyListeners();
  }
  
  /// Updates the user's status
  void updateStatus(String value) {
    _status = value;
    notifyListeners();
  }
  
  /// Saves the user profile changes
  Future<bool> saveChanges() async {
    // Here we would typically call the API to save changes
    // For now, we'll just simulate a successful save
    await Future.delayed(const Duration(seconds: 1));
    return true;
  }
} 