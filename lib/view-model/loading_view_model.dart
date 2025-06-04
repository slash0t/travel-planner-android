import 'package:flutter/material.dart';
import 'package:putevod/model/shared_prefs_manager.dart';

/// ViewModel for the Loading Screen
class LoadingViewModel extends ChangeNotifier {
  bool _isLoading = true;
  bool _isFirstLaunch = true;
  
  /// Indicates if the app is still loading
  bool get isLoading => _isLoading;
  
  /// Indicates if this is the first time the app is launched
  bool get isFirstLaunch => _isFirstLaunch;
  
  /// Controls how long the loading screen should be displayed
  /// and determines if this is the first app launch
  Future<void> initializeApp() async {
    // Simulate loading time
    // await Future.delayed(const Duration(seconds: 2));
    
    // Check if this is the first launch
    // _isFirstLaunch = true;
    _isFirstLaunch = await SharedPrefsManager.isFirstLaunch();

    _isLoading = false;
    notifyListeners();
  }
} 