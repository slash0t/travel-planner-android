import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:putevod/model/auth_model.dart';
import 'package:putevod/model/constants.dart';
import 'package:putevod/external/device_info.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  Future<AuthResponse> login(String email, String password) async {
    try {
      final deviceId = await DeviceInfoUtil.getDeviceId();
      final authModel = AuthModel(
        email: email,
        password: password,
        deviceId: deviceId,
      );
      
      final response = await http.post(
        Uri.parse(Constants.loginEndpoint),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(authModel.toLoginJson()),
      );
      
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        final authResponse = AuthResponse.fromJson(jsonResponse);
        await _saveTokens(authResponse.accessToken!, authResponse.refreshToken!);
        return authResponse;
      } else {
        return AuthResponse.error(
          'Login failed: ${response.statusCode} ${response.reasonPhrase}',
        );
      }
    } catch (e) {
      return AuthResponse.error('Login failed: $e');
    }
  }
  
  Future<AuthResponse> register(String email, String password) async {
    try {
      final authModel = AuthModel(
        email: email,
        password: password,
      );
      
      final response = await http.post(
        Uri.parse(Constants.registerEndpoint),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(authModel.toRegisterJson()),
      );
      
      if (response.statusCode == 201) {
        return await login(email, password);
      } else {
        return AuthResponse.error(
          'Registration failed: ${response.statusCode} ${response.reasonPhrase}',
        );
      }
    } catch (e) {
      return AuthResponse.error('Registration failed: $e');
    }
  }
  
  Future<AuthResponse> forgotPassword(String email) async {
    try {
      final authModel = AuthModel(
        email: email,
        password: '',
      );
      
      final response = await http.post(
        Uri.parse(Constants.forgotPasswordEndpoint),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(authModel.toForgotPasswordJson()),
      );
      
      if (response.statusCode == 200) {
        return AuthResponse(success: true, message: 'Reset code sent to your email');
      } else {
        return AuthResponse.error(
          'Password recovery request failed: ${response.statusCode} ${response.reasonPhrase}',
        );
      }
    } catch (e) {
      return AuthResponse.error('Password recovery request failed: $e');
    }
  }
  
  Future<AuthResponse> verifyResetCode(String email, String code) async {
    try {
      final authModel = AuthModel(
        email: email,
        password: '',
      );
      
      final response = await http.post(
        Uri.parse(Constants.verifyResetCodeEndpoint),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(authModel.toVerifyResetCodeJson(code)),
      );
      
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        return AuthResponse.fromJson(jsonResponse);
      } else {
        return AuthResponse.error(
          'Code verification failed: ${response.statusCode} ${response.reasonPhrase}',
        );
      }
    } catch (e) {
      return AuthResponse.error('Code verification failed: $e');
    }
  }
  
  Future<AuthResponse> resetPassword(String resetToken, String newPassword) async {
    try {
      final authModel = AuthModel(
        email: '',
        password: newPassword,
      );
      
      final response = await http.post(
        Uri.parse(Constants.resetPasswordEndpoint),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(authModel.toResetPasswordJson(resetToken))
      );
      
      if (response.statusCode == 200) {
        return AuthResponse(success: true, message: 'Password has been reset successfully');
      } else {
        return AuthResponse.error(
          'Password reset failed: ${response.statusCode} ${response.reasonPhrase}',
        );
      }
    } catch (e) {
      return AuthResponse.error('Password reset failed: $e');
    }
  }
  
  Future<void> _saveTokens(String accessToken, String refreshToken) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('accessToken', accessToken);
    await prefs.setString('refreshToken', refreshToken);
  }
  
  Future<bool> isAuthenticated() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey('accessToken');
  }
  
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('accessToken');
    await prefs.remove('refreshToken');
  }
} 