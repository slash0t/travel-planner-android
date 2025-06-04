import 'package:dio/dio.dart';
import 'package:putevod/external/api_client.dart';

/// Service for managing trip invitations
class TripInvitationService {
  final ApiClient _plannerClient = ApiClients.planner;

  /// Accept a trip invitation
  Future<Map<String, dynamic>> acceptInvitation(int tripId) async {
    try {
      final response = await _plannerClient.put(
        '/trips/$tripId/invitation',
        queryParameters: {'status': 'accepted'},
      );

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Failed to accept invitation: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  /// Decline a trip invitation
  Future<Map<String, dynamic>> declineInvitation(int tripId) async {
    try {
      final response = await _plannerClient.put(
        '/trips/$tripId/invitation',
        queryParameters: {'status': 'declined'},
      );

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Failed to decline invitation: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  /// Get invitation status for a trip
  Future<Map<String, dynamic>> getInvitationStatus(int tripId) async {
    try {
      final response = await _plannerClient.get('/trips/$tripId/invitation-status');

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Failed to get invitation status: ${response.statusCode}');
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