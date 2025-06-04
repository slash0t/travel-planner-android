import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:putevod/external/api_client.dart';

class LibraryService {
  final ApiClient _libraryClient = ApiClients.library;

  Future<dynamic> copyTripFromLibrary(int libraryRouteId, DateTime startDate) async {
    try {
      final response = await _libraryClient.post(
        '/routes/$libraryRouteId/copy',
        data: {
          'startDate': DateFormat('yyyy-MM-dd').format(startDate),
        },
      );

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Failed to copy route from library: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

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
      Map<String, dynamic> queryParams = {
        'page': page,
        'size': size,
      };

      if (country != null) queryParams['country'] = country;
      if (city != null) queryParams['city'] = city;
      if (durationMin != null) queryParams['durationMin'] = durationMin;
      if (durationMax != null) queryParams['durationMax'] = durationMax;
      if (tag != null) queryParams['tag'] = tag;

      final response = await _libraryClient.get(
        '/routes/filter',
        queryParameters: queryParams,
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
  Future<dynamic> getRouteDetails(int routeId) async {
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
  Future<List<dynamic>> getUserRoutes(int userId) async {
    try {
      final response = await _libraryClient.get('/routes/user/$userId');
      
      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Failed to get user routes: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }
  
  /// Опубликовать маршрут в библиотеке
  Future<dynamic> publishRoute(int tripId) async {
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
  Future<dynamic> approveRoute(int routeId) async {
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
  
  /// Получить отзывы на маршрут
  Future<Map<String, dynamic>> getRouteReviews(
    int routeId, {
    int page = 0,
    int size = 20,
  }) async {
    try {
      final response = await _libraryClient.get(
        '/routes/$routeId/reviews',
        queryParameters: {
          'page': page,
          'size': size,
        },
      );

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Failed to get route reviews: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }
  
  /// Добавить отзыв к маршруту
  Future<dynamic> addReview(
    int routeId,
    int rating, {
    String? comment,
  }) async {
    try {
      Map<String, dynamic> queryParams = {
        'rating': rating,
      };

      if (comment != null && comment.isNotEmpty) {
        queryParams['comment'] = comment;
      }

      final response = await _libraryClient.post(
        '/routes/$routeId/reviews',
        queryParameters: queryParams,
      );

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Failed to add review: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }
  
  /// Обновить отзыв к маршруту
  Future<dynamic> updateReview(
    int routeId,
    int rating, {
    String? comment,
  }) async {
    try {
      Map<String, dynamic> queryParams = {
        'rating': rating,
      };

      if (comment != null && comment.isNotEmpty) {
        queryParams['comment'] = comment;
      }

      final response = await _libraryClient.put(
        '/routes/$routeId/reviews',
        queryParameters: queryParams,
      );

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Failed to update review: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }
  
  /// Удалить отзыв
  Future<void> deleteReview(int routeId) async {
    try {
      final response = await _libraryClient.delete('/routes/$routeId/reviews');

      if (response.statusCode != 204) {
        throw Exception('Failed to delete review: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }
  
  /// Получить мой отзыв на маршрут
  Future<dynamic> getMyReview(int routeId) async {
    try {
      final response = await _libraryClient.get('/routes/$routeId/reviews/my');

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Failed to get my review: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }
  
  String _handleDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'Timeout: Проверьте подключение к интернету';
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        final message = e.response?.data?['message'] ?? 'Неизвестная ошибка';
        return 'Ошибка $statusCode: $message';
      case DioExceptionType.cancel:
        return 'Запрос был отменен';
      case DioExceptionType.unknown:
        return 'Ошибка соединения: ${e.message}';
      default:
        return 'Неизвестная ошибка: ${e.message}';
    }
  }
} 