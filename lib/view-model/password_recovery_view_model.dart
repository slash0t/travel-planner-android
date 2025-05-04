import 'package:flutter/material.dart';
import 'package:putevod/external/auth_service.dart';

class PasswordRecoveryViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService();
  
  String _email = '';
  String _code = '';
  String _newPassword = '';
  String _confirmPassword = '';
  String _errorMessage = '';
  String _successMessage = '';
  String? _resetToken;
  bool _isLoading = false;
  bool _codeSent = false;
  
  String get email => _email;
  String get code => _code;
  String get newPassword => _newPassword;
  String get confirmPassword => _confirmPassword;
  String get errorMessage => _errorMessage;
  String get successMessage => _successMessage;
  bool get isLoading => _isLoading;
  bool get codeSent => _codeSent;
  
  void setEmail(String email) {
    _email = email;
    notifyListeners();
  }
  
  void setCode(String code) {
    _code = code;
    notifyListeners();
  }
  
  void setNewPassword(String password) {
    _newPassword = password;
    notifyListeners();
  }
  
  void setConfirmPassword(String confirmPassword) {
    _confirmPassword = confirmPassword;
    notifyListeners();
  }
  
  void _setErrorMessage(String message) {
    _errorMessage = message;
    _successMessage = '';
    notifyListeners();
  }
  
  void _setSuccessMessage(String message) {
    _successMessage = message;
    _errorMessage = '';
    notifyListeners();
  }
  
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
  
  void _setCodeSent(bool sent) {
    _codeSent = sent;
    notifyListeners();
  }
  
  bool _validatePasswords() {
    if (_newPassword != _confirmPassword) {
      _setErrorMessage('Passwords do not match');
      return false;
    }
    return true;
  }
  
  Future<bool> sendResetCode() async {
    if (_email.isEmpty) {
      _setErrorMessage('Email is required');
      return false;
    }
    
    _setLoading(true);
    _setErrorMessage('');
    
    final response = await _authService.forgotPassword(_email);
    _setLoading(false);
    
    if (response.success) {
      _setSuccessMessage('Reset code sent to your email');
      _setCodeSent(true);
      return true;
    } else {
      _setErrorMessage(response.message ?? 'Failed to send reset code');
      return false;
    }
  }
  
  Future<bool> verifyResetCode() async {
    if (_email.isEmpty || _code.isEmpty) {
      _setErrorMessage('Email and code are required');
      return false;
    }
    
    _setLoading(true);
    _setErrorMessage('');
    
    final response = await _authService.verifyResetCode(_email, _code);
    _setLoading(false);
    
    if (response.success && response.resetToken != null) {
      _resetToken = response.resetToken;
      return true;
    } else {
      _setErrorMessage(response.message ?? 'Invalid reset code');
      return false;
    }
  }
  
  Future<bool> resetPassword() async {
    if (_newPassword.isEmpty || _confirmPassword.isEmpty) {
      _setErrorMessage('New password and confirmation are required');
      return false;
    }
    
    if (!_validatePasswords()) {
      return false;
    }
    
    if (_resetToken == null) {
      final verified = await verifyResetCode();
      if (!verified) {
        return false;
      }
    }
    
    _setLoading(true);
    _setErrorMessage('');
    
    final response = await _authService.resetPassword(_resetToken!, _newPassword);
    _setLoading(false);
    
    if (response.success) {
      _setSuccessMessage('Password has been reset successfully');
      return true;
    } else {
      _setErrorMessage(response.message ?? 'Failed to reset password');
      return false;
    }
  }
} 