import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:putevod/model/auth_model.dart';
import 'package:putevod/model/constants.dart';
import 'package:putevod/external/device_info.dart';
import 'package:putevod/external/api_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final ApiClient _authClient = ApiClients.auth;
  
  Future<AuthResponse> login(String email, String password) async {
    try {
      final deviceId = await DeviceInfoUtil.getDeviceId();
      final authModel = AuthModel(
        email: email,
        password: password,
        deviceId: deviceId,
      );
      
      final response = await _authClient.post(
        '/login',
        data: authModel.toLoginJson(),
      );
      
      if (response.statusCode == 200) {
        final authResponse = AuthResponse.fromJson(response.data);
        await _saveTokens(authResponse.accessToken!, authResponse.refreshToken!);
        return authResponse;
      } else {
        return AuthResponse.error(
          'Login failed: ${response.statusCode} ${response.statusMessage}',
        );
      }
    } on DioException catch (e) {
      return AuthResponse.error(_handleDioError(e));
    } catch (e) {
      return AuthResponse.error('Login failed: $e');
    }
  }
  
  Future<AuthResponse> register(String username, String email, String password) async {
    try {
      final authModel = AuthModel(
        username: username,
        email: email,
        password: password,
      );
      
      final response = await _authClient.post(
        '/register',
        data: authModel.toRegisterJson(),
      );
      
      if (response.statusCode == 201) {
        final responseLogin = await login(authModel.email, authModel.password);

        if (responseLogin.success) {
          return AuthResponse(
            success: true,
            message: 'Регистрация успешна. Проверьте email для подтверждения.',
          );
        } else {
          return AuthResponse.error(
            'Login failed: ${response.statusCode} ${response.statusMessage}',
          );
        }
      } else {
        return AuthResponse.error(
          'Registration failed: ${response.statusCode} ${response.statusMessage}',
        );
      }
    } on DioException catch (e) {
      return AuthResponse.error(_handleDioError(e));
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
      
      final response = await _authClient.post(
        '/forgot-password',
        data: authModel.toForgotPasswordJson(),
      );
      
      if (response.statusCode == 200) {
        return AuthResponse(success: true, message: 'Reset code sent to your email');
      } else {
        return AuthResponse.error(
          'Password recovery request failed: ${response.statusCode} ${response.statusMessage}',
        );
      }
    } on DioException catch (e) {
      return AuthResponse.error(_handleDioError(e));
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
      
      final response = await _authClient.post(
        '/verify-reset-code',
        data: authModel.toVerifyResetCodeJson(code),
      );
      
      if (response.statusCode == 200) {
        return AuthResponse.fromJson(response.data);
      } else {
        return AuthResponse.error(
          'Code verification failed: ${response.statusCode} ${response.statusMessage}',
        );
      }
    } on DioException catch (e) {
      return AuthResponse.error(_handleDioError(e));
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
      
      final response = await _authClient.post(
        '/reset-password',
        data: authModel.toResetPasswordJson(resetToken),
      );
      
      if (response.statusCode == 200) {
        return AuthResponse(success: true, message: 'Password has been reset successfully');
      } else {
        return AuthResponse.error(
          'Password reset failed: ${response.statusCode} ${response.statusMessage}',
        );
      }
    } on DioException catch (e) {
      return AuthResponse.error(_handleDioError(e));
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
  
  String _handleDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        return 'Превышено время ожидания соединения';
      case DioExceptionType.sendTimeout:
        return 'Превышено время ожидания отправки';
      case DioExceptionType.receiveTimeout:
        return 'Превышено время ожидания ответа';
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        final message = e.response?.data?['message'] ?? 'Ошибка сервера';
        return 'Ошибка $statusCode: $message';
      case DioExceptionType.cancel:
        return 'Запрос был отменен';
      case DioExceptionType.connectionError:
        return 'Ошибка соединения. Проверьте интернет-подключение';
      default:
        return 'Неизвестная ошибка: ${e.message}';
    }
  }
} 