import 'package:flutter/material.dart';
import 'package:putevod/external/auth_service.dart';
import 'package:putevod/model/shared_prefs_manager.dart';

class LoadingViewModel extends ChangeNotifier {
  bool _isLoading = true;
  bool _isFirstLaunch = true;

  final AuthService _authService = AuthService();

  bool get isLoading => _isLoading;

  bool get isFirstLaunch => _isFirstLaunch;
  

  Future<void> initializeApp() async {
    // Simulate loading time
    // await Future.delayed(const Duration(seconds: 2));
    
    // Check if this is the first launch
    // _isFirstLaunch = true;
    _isFirstLaunch = await SharedPrefsManager.isFirstLaunch();

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> isAuthenticated() async {
    return _authService.isAuthenticated();
  }
} 