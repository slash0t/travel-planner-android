import 'package:flutter/material.dart';

/// ViewModel for handling header state and actions
class AppHeaderViewModel extends ChangeNotifier {
  /// Whether to show the back button instead of logo
  bool _showBackButton = false;
  
  /// Title to display when back button is shown
  String? _title;
  
  /// Getter for back button visibility
  bool get showBackButton => _showBackButton;
  
  /// Getter for title
  String? get title => _title;
  
  /// Sets the header to show a back button with optional title
  void showBack({String? title}) {
    _showBackButton = true;
    _title = title;
    notifyListeners();
  }
  
  /// Sets the header to show the logo (default state)
  void showLogo() {
    if (_showBackButton) {
      _showBackButton = false;
      _title = null;
      notifyListeners();
    }
  }
} 