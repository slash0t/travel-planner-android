import 'package:dio/dio.dart';
import 'package:putevod/external/api_client.dart';

class ExternalService {
  final ApiClient _externalClient = ApiClients.external;
  
  // === PLACES API ===
  
  /// Поиск мест
  Future<Map<String, dynamic>> searchPlaces({
    required String query,
    double? lat,
    double? lon,
    int? radius = 5000,
    int? limit = 20,
    String? category,
  }) async {
    try {
      final response = await _externalClient.get(
        '/places/search',
        queryParameters: {
          'query': query,
          if (lat != null) 'lat': lat,
          if (lon != null) 'lon': lon,
          'radius': radius,
          'limit': limit,
          if (category != null) 'category': category,
        },
      );
      
      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Failed to search places: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }
  
  /// Получить детальную информацию о месте
  Future<Map<String, dynamic>> getPlaceDetails(String placeId) async {
    try {
      final response = await _externalClient.get('/places/$placeId');
      
      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Failed to get place details: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }
  
  /// Автодополнение для поиска мест
  Future<Map<String, dynamic>> autocompletePlaces({
    required String input,
    double? lat,
    double? lon,
    int? limit = 5,
  }) async {
    try {
      final response = await _externalClient.get(
        '/places/autocomplete',
        queryParameters: {
          'input': input,
          if (lat != null) 'lat': lat,
          if (lon != null) 'lon': lon,
          'limit': limit,
        },
      );
      
      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Failed to autocomplete places: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }
  
  /// Геокодирование адреса
  Future<Map<String, double>?> geocodeAddress(String address) async {
    try {
      final response = await _externalClient.get(
        '/places/geocode',
        queryParameters: {'address': address},
      );
      
      if (response.statusCode == 200) {
        return Map<String, double>.from(response.data);
      } else if (response.statusCode == 404) {
        return null;
      } else {
        throw Exception('Failed to geocode address: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }
  
  /// Найти ближайшие места
  Future<Map<String, dynamic>> getNearbyPlaces({
    required double lat,
    required double lon,
    int? radius = 1000,
    int? limit = 20,
    String? categories,
  }) async {
    try {
      final response = await _externalClient.get(
        '/places/nearby',
        queryParameters: {
          'lat': lat,
          'lon': lon,
          'radius': radius,
          'limit': limit,
          if (categories != null) 'categories': categories,
        },
      );
      
      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Failed to get nearby places: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }
  
  // === AI API ===
  
  /// Генерация списка вещей для поездки
  Future<Map<String, dynamic>> generatePackingList(Map<String, dynamic> request) async {
    try {
      final response = await _externalClient.post(
        '/ai/packing-list',
        data: request,
      );
      
      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Failed to generate packing list: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }
  
  /// Получение шаблонов списков вещей
  Future<Map<String, dynamic>> getPackingListTemplates() async {
    try {
      final response = await _externalClient.get('/ai/packing-list/templates');
      
      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Failed to get packing list templates: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }
  
  /// Получение содержимого шаблона списка вещей
  Future<Map<String, dynamic>> getPackingListTemplateContent(String templateId) async {
    try {
      final response = await _externalClient.get('/ai/packing-list/template/$templateId');
      
      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Failed to get template content: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
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