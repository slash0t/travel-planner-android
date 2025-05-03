import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Class for storing app constants and environment variables
class Constants {
  /// Private constructor to prevent instantiation
  Constants._();
  
  /// Base API URL from environment variables
  static String get apiBaseUrl => dotenv.env['API_BASE_URL'] ?? 'http://localhost:3000';
  
  /// Login endpoint
  static const String loginEndpoint = '/login';
  
  /// Register endpoint
  static const String registerEndpoint = '/register';
  
  /// Forgot password endpoint
  static const String forgotPasswordEndpoint = '/forgot-password';
  
  /// Verify reset code endpoint
  static const String verifyResetCodeEndpoint = '/verify-reset-code';
  
  /// Reset password endpoint
  static const String resetPasswordEndpoint = '/reset-password';
}