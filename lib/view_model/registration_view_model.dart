import 'package:flutter/material.dart';
import 'package:putevod/external/auth_service.dart';

class RegistrationViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService();
  
  String _email = '';
  String _password = '';
  String _confirmPassword = '';
  String _errorMessage = '';
  bool _isLoading = false;
  
  String get email => _email;
  String get password => _password;
  String get confirmPassword => _confirmPassword;
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
  
  void setConfirmPassword(String confirmPassword) {
    _confirmPassword = confirmPassword;
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
  
  bool _validatePasswords() {
    if (_password != _confirmPassword) {
      _setErrorMessage('Passwords do not match');
      return false;
    }
    return true;
  }
  
  Future<bool> register() async {
    if (_email.isEmpty || _password.isEmpty || _confirmPassword.isEmpty) {
      _setErrorMessage('All fields are required');
      return false;
    }
    
    if (!_validatePasswords()) {
      return false;
    }
    
    _setLoading(true);
    _setErrorMessage('');
    
    final response = await _authService.register(_email, _password);
    _setLoading(false);
    
    if (response.success) {
      return true;
    } else {
      _setErrorMessage(response.message ?? 'Registration failed');
      return false;
    }
  }
} 