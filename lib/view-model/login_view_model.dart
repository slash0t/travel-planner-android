import 'package:flutter/material.dart';
import 'package:putevod/external/auth_service.dart';

class LoginViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService();
  
  String _email = '';
  String _password = '';
  String _errorMessage = '';
  bool _isLoading = false;
  
  String get email => _email;
  String get password => _password;
  String get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;
  
  void setEmail(String email) {
    _email = email;
    notifyListeners();
  }
  
  void setPassword(String password) {
    _password = password;
    notifyListeners();
  }
  
  void _setErrorMessage(String message) {
    _errorMessage = message;
    notifyListeners();
  }
  
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
  
  Future<bool> login() async {
    if (_email.isEmpty || _password.isEmpty) {
      _setErrorMessage('Email and password are required');
      return false;
    }
    
    _setLoading(true);
    _setErrorMessage('');
    
    final response = await _authService.login(_email, _password);
    _setLoading(false);
    
    if (response.success) {
      return true;
    } else {
      _setErrorMessage(response.message ?? 'Login failed');
      return false;
    }
  }
} 