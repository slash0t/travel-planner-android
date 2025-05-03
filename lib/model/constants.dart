import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Class for storing app constants and environment variables
class Constants {
  /// Private constructor to prevent instantiation
  Constants._();
  
  /// Base API URL from environment variables
  static String get apiUrl => dotenv.env['API_URL'] ?? 'http://localhost:3000';
  
  /// Login endpoint
  static String get loginEndpoint => '$apiUrl/login';
  
  /// Register endpoint
  static String get registerEndpoint => '$apiUrl/register';
  
  /// Forgot password endpoint
  static String get forgotPasswordEndpoint => '$apiUrl/forgot-password';
  
  /// Verify reset code endpoint
  static String get verifyResetCodeEndpoint => '$apiUrl/verify-reset-code';
  
  /// Reset password endpoint
  static String get resetPasswordEndpoint => '$apiUrl/reset-password';
}