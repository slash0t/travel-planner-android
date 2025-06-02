import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:putevod/model/constants.dart';

class ApiClient {
  late Dio _dio;
  final String baseUrl;
  
  ApiClient({required this.baseUrl}) {
    _dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));
    
    _setupInterceptors();
  }
  
  void _setupInterceptors() {
    // Interceptor для автоматического добавления токена авторизации
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await _getAccessToken();
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        handler.next(options);
      },
      onError: (error, handler) async {
        // Если получили 401, пытаемся обновить токен
        if (error.response?.statusCode == 401) {
          try {
            await _refreshToken();
            // Повторяем оригинальный запрос с новым токеном
            final token = await _getAccessToken();
            error.requestOptions.headers['Authorization'] = 'Bearer $token';
            final response = await _dio.fetch(error.requestOptions);
            handler.resolve(response);
            return;
          } catch (e) {
            // Если обновление токена не удалось, очищаем авторизацию
            await _clearTokens();
          }
        }
        handler.next(error);
      },
    ));
    
    // Логирование для отладки
    _dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
      logPrint: (obj) => print('[API] $obj'),
    ));
  }
  
  Future<String?> _getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('accessToken');
  }
  
  Future<String?> _getRefreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('refreshToken');
  }
  
  Future<void> _saveTokens(String accessToken, String refreshToken) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('accessToken', accessToken);
    await prefs.setString('refreshToken', refreshToken);
  }
  
  Future<void> _clearTokens() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('accessToken');
    await prefs.remove('refreshToken');
  }
  
  Future<void> _refreshToken() async {
    final refreshToken = await _getRefreshToken();
    if (refreshToken == null) throw Exception('No refresh token available');
    
    final response = await _dio.post(
      Constants.refreshTokenEndpoint,
      data: {'refreshToken': refreshToken},
    );
    
    if (response.statusCode == 200) {
      final data = response.data;
      await _saveTokens(data['accessToken'], data['refreshToken']);
    } else {
      throw Exception('Failed to refresh token');
    }
  }
  
  // GET запрос
  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return await _dio.get<T>(
      path,
      queryParameters: queryParameters,
      options: options,
    );
  }
  
  // POST запрос
  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return await _dio.post<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }
  
  // PUT запрос
  Future<Response<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return await _dio.put<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }
  
  // DELETE запрос
  Future<Response<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return await _dio.delete<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }
}

// Singleton для клиентов API
class ApiClients {
  static ApiClient? _authClient;
  static ApiClient? _plannerClient;
  static ApiClient? _externalClient;
  static ApiClient? _libraryClient;
  
  static ApiClient get auth {
    _authClient ??= ApiClient(baseUrl: Constants.authServiceUrl);
    return _authClient!;
  }
  
  static ApiClient get planner {
    _plannerClient ??= ApiClient(baseUrl: Constants.plannerServiceUrl);
    return _plannerClient!;
  }
  
  static ApiClient get external {
    _externalClient ??= ApiClient(baseUrl: Constants.externalServiceUrl);
    return _externalClient!;
  }
  
  static ApiClient get library {
    _libraryClient ??= ApiClient(baseUrl: Constants.libraryServiceUrl);
    return _libraryClient!;
  }
} 