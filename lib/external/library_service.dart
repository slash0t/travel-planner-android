import 'package:dio/dio.dart';
import 'package:putevod/external/api_client.dart';

class LibraryService {
  final ApiClient _libraryClient = ApiClients.library;
  
  /// Получить список опубликованных маршрутов
  Future<Map<String, dynamic>> getPublishedRoutes({
    int page = 0,
    int size = 20,
  }) async {
    try {
      final response = await _libraryClient.get(
        '/routes',
        queryParameters: {
          'page': page,
          'size': size,
        },
      );
      
      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Failed to get published routes: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }
  
  /// Получить список неодобренных маршрутов (для админов)
  Future<Map<String, dynamic>> getPendingRoutes({
    int page = 0,
    int size = 20,
  }) async {
    try {
      final response = await _libraryClient.get(
        '/routes/pending',
        queryParameters: {
          'page': page,
          'size': size,
        },
      );
      
      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Failed to get pending routes: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }
  
  /// Поиск маршрутов по ключевому слову
  Future<Map<String, dynamic>> searchRoutes({
    required String query,
    int page = 0,
    int size = 20,
  }) async {
    try {
      final response = await _libraryClient.get(
        '/routes/search',
        queryParameters: {
          'query': query,
          'page': page,
          'size': size,
        },
      );
      
      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Failed to search routes: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }
  
  /// Фильтрация маршрутов по критериям
  Future<Map<String, dynamic>> filterRoutes({
    String? country,
    String? city,
    int? durationMin,
    int? durationMax,
    String? tag,
    int page = 0,
    int size = 20,
  }) async {
    try {
      final response = await _libraryClient.get(
        '/routes/filter',
        queryParameters: {
          if (country != null) 'country': country,
          if (city != null) 'city': city,
          if (durationMin != null) 'durationMin': durationMin,
          if (durationMax != null) 'durationMax': durationMax,
          if (tag != null) 'tag': tag,
          'page': page,
          'size': size,
        },
      );
      
      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Failed to filter routes: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }
  
  /// Получить популярные маршруты
  Future<Map<String, dynamic>> getPopularRoutes({
    int page = 0,
    int size = 20,
  }) async {
    try {
      final response = await _libraryClient.get(
        '/routes/popular',
        queryParameters: {
          'page': page,
          'size': size,
        },
      );
      
      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Failed to get popular routes: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }
  
  /// Получить маршруты с наивысшим рейтингом
  Future<Map<String, dynamic>> getTopRatedRoutes({
    int page = 0,
    int size = 20,
  }) async {
    try {
      final response = await _libraryClient.get(
        '/routes/top-rated',
        queryParameters: {
          'page': page,
          'size': size,
        },
      );
      
      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Failed to get top-rated routes: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }
  
  /// Получить детальную информацию о маршруте
  Future<Map<String, dynamic>> getRouteDetails(int routeId) async {
    try {
      final response = await _libraryClient.get('/routes/$routeId');
      
      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Failed to get route details: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }
  
  /// Получить маршруты опубликованные пользователем
  Future<List<Map<String, dynamic>>> getUserRoutes(int userId) async {
    try {
      final response = await _libraryClient.get('/routes/user/$userId');
      
      if (response.statusCode == 200) {
        return List<Map<String, dynamic>>.from(response.data);
      } else {
        throw Exception('Failed to get user routes: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }
  
  /// Опубликовать маршрут в библиотеке
  Future<Map<String, dynamic>> publishRoute(int tripId) async {
    try {
      final response = await _libraryClient.post('/routes/publish/$tripId');
      
      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Failed to publish route: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }
  
  /// Одобрить публикацию маршрута (для админов)
  Future<Map<String, dynamic>> approveRoute(int routeId) async {
    try {
      final response = await _libraryClient.put('/routes/approve/$routeId');
      
      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Failed to approve route: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }
  
  /// Удалить маршрут из библиотеки
  Future<void> deleteRoute(int routeId) async {
    try {
      final response = await _libraryClient.delete('/routes/$routeId');
      
      if (response.statusCode != 204) {
        throw Exception('Failed to delete route: ${response.statusCode}');
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