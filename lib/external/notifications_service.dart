import 'package:dio/dio.dart';
import 'package:putevod/external/api_client.dart';

/// Service for managing notifications through the backend API
class NotificationsService {
  final ApiClient _plannerClient = ApiClients.planner;

  /// Get user notifications with pagination
  Future<Map<String, dynamic>> getUserNotifications({
    int page = 0,
    int size = 20,
  }) async {
    try {
      final response = await _plannerClient.get(
        '/notifications',
        queryParameters: {
          'page': page,
          'size': size,
        },
      );

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Failed to get user notifications: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  /// Get notification by ID
  Future<Map<String, dynamic>> getNotification(int notificationId) async {
    try {
      final response = await _plannerClient.get('/notifications/$notificationId');

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Failed to get notification: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  /// Get unread notifications count
  Future<int> getUnreadCount() async {
    try {
      final response = await _plannerClient.get('/notifications/unread-count');

      if (response.statusCode == 200) {
        return response.data as int;
      } else {
        throw Exception('Failed to get unread count: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  /// Mark notification as read
  Future<void> markAsRead(int notificationId) async {
    try {
      final response = await _plannerClient.put('/notifications/$notificationId/read');

      if (response.statusCode != 200) {
        throw Exception('Failed to mark notification as read: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  /// Mark all notifications as read
  Future<void> markAllAsRead() async {
    try {
      final response = await _plannerClient.put('/notifications/mark-all-read');

      if (response.statusCode != 200) {
        throw Exception('Failed to mark all notifications as read: ${response.statusCode}');
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