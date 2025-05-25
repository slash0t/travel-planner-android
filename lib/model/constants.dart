import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Class for storing app constants and environment variables
class Constants {
  /// Private constructor to prevent instantiation
  Constants._();
  
  /// Environment configuration
  static bool get isProduction => dotenv.env['ENVIRONMENT'] == 'prod';
  
  /// Base API URLs
  static String get authServiceUrl => isProduction 
    ? 'https://www.putevod-app.ru/auth/api/v1'
    : 'http://localhost:8081/api/v1';
    
  static String get plannerServiceUrl => isProduction 
    ? 'https://www.putevod-app.ru/planner/api/v1'
    : 'http://localhost:8082/api/v1';
    
  static String get externalServiceUrl => isProduction 
    ? 'https://www.putevod-app.ru/external/api/v1'
    : 'http://localhost:8083/api/v1';
    
  static String get libraryServiceUrl => isProduction 
    ? 'https://www.putevod-app.ru/library/api/v1'
    : 'http://localhost:8084/api/v1';
  
  /// Auth endpoints
  static String get loginEndpoint => '$authServiceUrl/login';
  static String get registerEndpoint => '$authServiceUrl/register';
  static String get forgotPasswordEndpoint => '$authServiceUrl/forgot-password';
  static String get verifyResetCodeEndpoint => '$authServiceUrl/verify-reset-code';
  static String get resetPasswordEndpoint => '$authServiceUrl/reset-password';
  static String get refreshTokenEndpoint => '$authServiceUrl/refresh';
  static String get logoutEndpoint => '$authServiceUrl/logout';
  static String get verifyEmailEndpoint => '$authServiceUrl/verify-email';
  static String get resendVerificationEndpoint => '$authServiceUrl/resend-verification';
  static String get validateTokenEndpoint => '$authServiceUrl/auth/validate';
  static String get userInfoEndpoint => '$authServiceUrl/auth/userinfo';
  
  /// Trip endpoints
  static String get tripsEndpoint => '$plannerServiceUrl/trips';
  
  /// External endpoints
  static String get placesEndpoint => '$externalServiceUrl/places';
  static String get aiEndpoint => '$externalServiceUrl/ai';
  
  /// Library endpoints
  static String get libraryEndpoint => '$libraryServiceUrl/library';
  static String get reviewsEndpoint => '$libraryServiceUrl/reviews';
}