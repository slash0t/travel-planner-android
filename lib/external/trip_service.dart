import 'package:dio/dio.dart';
import 'package:putevod/external/api_client.dart';

class TripService {
  final ApiClient _plannerClient = ApiClients.planner;

  // === TRIPS API ===

  /// Получить все поездки пользователя
  Future<Map<String, dynamic>> getUserTrips({
    String filter = 'all',
    int page = 0,
    int size = 20,
  }) async {
    try {
      final response = await _plannerClient.get(
        '/trips',
        queryParameters: {
          'filter': filter,
          'page': page,
          'size': size,
        },
      );

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Failed to get user trips: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  /// Получить предстоящие поездки
  Future<List<dynamic>> getUpcomingTrips() async {
    try {
      final response = await _plannerClient.get('/trips/upcoming');

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Failed to get upcoming trips: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  /// Получить текущие поездки
  Future<List<dynamic>> getOngoingTrips() async {
    try {
      final response = await _plannerClient.get('/trips/ongoing');

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Failed to get ongoing trips: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  /// Получить прошедшие поездки
  Future<List<dynamic>> getPastTrips() async {
    try {
      final response = await _plannerClient.get('/trips/past');

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Failed to get past trips: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  /// Получить детали поездки по ID
  Future<dynamic> getTripById(int tripId) async {
    try {
      final response = await _plannerClient.get('/trips/$tripId');

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Failed to get trip details: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  Future<dynamic> reorderEvent(int tripId, int dayId, int eventId, Map<String, dynamic> data) async {
    try {
      final response = await _plannerClient.patch(
        '/trips/$tripId/days/$dayId/events/$eventId/reorder',
        data: data,
      );

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Failed to get trip details: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  /// Создать новую поездку
  Future<dynamic> createTrip(Map<String, dynamic> tripData) async {
    try {
      final response = await _plannerClient.post('/trips', data: tripData);

      if (response.statusCode == 201) {
        return response.data;
      } else {
        throw Exception('Failed to create trip: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  /// Обновить поездку
  Future<dynamic> updateTrip(int tripId, Map<String, dynamic> tripData) async {
    try {
      final response = await _plannerClient.put('/trips/$tripId', data: tripData);

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Failed to update trip: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  /// Удалить поездку
  Future<void> deleteTrip(int tripId) async {
    try {
      final response = await _plannerClient.delete('/trips/$tripId');

      if (response.statusCode != 204) {
        throw Exception('Failed to delete trip: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  /// Поделиться поездкой
  Future<Map<String, dynamic>> shareTrip(int tripId, Map<String, dynamic> accessData) async {
    try {
      final response = await _plannerClient.post('/trips/$tripId/share', data: accessData);

      if (response.statusCode == 201) {
        return response.data;
      } else {
        throw Exception('Failed to share trip: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  /// Получить список пользователей с доступом к поездке
  Future<List<dynamic>> getTripShares(int tripId) async {
    try {
      final response = await _plannerClient.get('/trips/$tripId/shares');

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Failed to get trip shares: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  /// Удалить доступ к поездке для пользователя
  Future<void> removeShare(int tripId, int shareUserId) async {
    try {
      final response = await _plannerClient.delete('/trips/$tripId/shares/$shareUserId');

      if (response.statusCode != 204) {
        throw Exception('Failed to remove share: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  /// Ответить на приглашение в поездку
  Future<Map<String, dynamic>> respondToInvitation(int tripId, String status) async {
    try {
      final response = await _plannerClient.put(
        '/trips/$tripId/invitation',
        queryParameters: {'status': status},
      );

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Failed to respond to invitation: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  /// Проверить, может ли пользователь публиковать маршрут
  Future<bool> canPublishTrip(int tripId, int userId) async {
    try {
      final response = await _plannerClient.get(
        '/trips/$tripId/can-publish',
        queryParameters: {'userId': userId},
      );

      if (response.statusCode == 200) {
        return response.data == true;
      } else {
        throw Exception('Failed to check publish permission: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  /// Опубликовать или снять с публикации маршрут
  Future<Map<String, dynamic>> publishTrip(int tripId, bool publish) async {
    try {
      final response = await _plannerClient.post(
        '/trips/$tripId/publish',
        queryParameters: {'publish': publish},
      );

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Failed to publish trip: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  // === TODO LISTS API ===

  /// Создать новый список задач
  Future<dynamic> createTodoList(Map<String, dynamic> todoListData) async {
    try {
      final response = await _plannerClient.post('/todo-lists', data: todoListData);

      if (response.statusCode == 201) {
        return response.data;
      } else {
        throw Exception('Failed to create todo list: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  /// Создать новый список задач для поездки
  Future<dynamic> createTripTodoList(int tripId, Map<String, dynamic> todoListData) async {
    try {
      final response = await _plannerClient.post('/trips/$tripId/todo-lists', data: todoListData);

      if (response.statusCode == 201) {
        return response.data;
      } else {
        throw Exception('Failed to create trip todo list: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  /// Получить все списки задач пользователя
  Future<Map<String, dynamic>> getUserTodoLists({int page = 0, int size = 20}) async {
    try {
      final response = await _plannerClient.get(
        '/todo-lists',
        queryParameters: {'page': page, 'size': size},
      );

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Failed to get user todo lists: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  /// Получить все списки задач для поездки
  Future<List<dynamic>> getTripTodoLists(int tripId) async {
    try {
      final response = await _plannerClient.get('/trips/$tripId/todo-lists');

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Failed to get trip todo lists: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  /// Получить список задач по ID
  Future<dynamic> getTodoListById(int listId) async {
    try {
      final response = await _plannerClient.get('/todo-lists/$listId');

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Failed to get todo list: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  /// Обновить список задач
  Future<dynamic> updateTodoList(int listId, Map<String, dynamic> todoListData) async {
    try {
      final response = await _plannerClient.put('/todo-lists/$listId', data: todoListData);

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Failed to update todo list: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  /// Удалить список задач
  Future<void> deleteTodoList(int listId) async {
    try {
      final response = await _plannerClient.delete('/todo-lists/$listId');

      if (response.statusCode != 204) {
        throw Exception('Failed to delete todo list: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  /// Добавить элемент в список задач
  Future<dynamic> addTodoItem(int listId, Map<String, dynamic> todoItemData) async {
    try {
      final response = await _plannerClient.post('/todo-lists/$listId/items', data: todoItemData);

      if (response.statusCode == 201) {
        return response.data;
      } else {
        throw Exception('Failed to add todo item: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  /// Обновить элемент списка задач
  Future<dynamic> updateTodoItem(int listId, int itemId, Map<String, dynamic> todoItemData) async {
    try {
      final response = await _plannerClient.put('/todo-lists/$listId/items/$itemId', data: todoItemData);

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Failed to update todo item: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  /// Переключить статус выполнения задачи
  Future<dynamic> toggleTodoItemComplete(int listId, int itemId) async {
    try {
      final response = await _plannerClient.put('/todo-lists/$listId/items/$itemId/toggle');

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Failed to toggle todo item: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  /// Переключить статус всех задач в списке
  Future<void> toggleAllTodoItemsComplete(int listId, bool completed) async {
    try {
      final response = await _plannerClient.put(
        '/todo-lists/$listId/items/toggle-all',
        queryParameters: {'completed': completed},
      );

      if (response.statusCode != 204) {
        throw Exception('Failed to toggle all todo items: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  /// Удалить элемент списка задач
  Future<void> deleteTodoItem(int listId, int itemId) async {
    try {
      final response = await _plannerClient.delete('/todo-lists/$listId/items/$itemId');

      if (response.statusCode != 204) {
        throw Exception('Failed to delete todo item: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  // === TRIP DAYS API ===

  /// Получить дни поездки
  Future<List<dynamic>> getTripDays(int tripId) async {
    try {
      final response = await _plannerClient.get('/trips/$tripId/days');

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Failed to get trip days: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  /// Создать день поездки
  Future<dynamic> createTripDay(int tripId, Map<String, dynamic> dayData) async {
    try {
      final response = await _plannerClient.post('/trips/$tripId/days', data: dayData);

      if (response.statusCode == 201) {
        return response.data;
      } else {
        throw Exception('Failed to create trip day: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  /// Обновить день поездки
  Future<dynamic> updateTripDay(int tripId, int dayId, Map<String, dynamic> dayData) async {
    try {
      final response = await _plannerClient.put('/trips/$tripId/days/$dayId', data: dayData);

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Failed to update trip day: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  /// Удалить день поездки
  Future<void> deleteTripDay(int tripId, int dayId) async {
    try {
      final response = await _plannerClient.delete('/trips/$tripId/days/$dayId');

      if (response.statusCode != 204) {
        throw Exception('Failed to delete trip day: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  // === EVENTS API ===

  /// Получить все события поездки
  Future<List<dynamic>> getTripEvents(int tripId) async {
    try {
      final response = await _plannerClient.get('/trips/$tripId/events');

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Failed to get trip events: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  /// Получить все события дня
  Future<List<dynamic>> getDayEvents(int tripId, int dayId) async {
    try {
      final response = await _plannerClient.get('/trips/$tripId/days/$dayId/events');

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Failed to get day events: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  /// Создать событие
  Future<dynamic> createEvent(int tripId, int dayId, Map<String, dynamic> eventData) async {
    try {
      final response = await _plannerClient.post('/trips/$tripId/days/$dayId/events', data: eventData);

      if (response.statusCode == 201) {
        return response.data;
      } else {
        throw Exception('Failed to create event: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  /// Получить событие по ID
  Future<dynamic> getEvent(int tripId, int dayId, int eventId) async {
    try {
      final response = await _plannerClient.get('/trips/$tripId/days/$dayId/events/$eventId');

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Failed to get event: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  /// Обновить событие
  Future<dynamic> updateEvent(int tripId, int dayId, int eventId, Map<String, dynamic> eventData) async {
    try {
      final response = await _plannerClient.put('/trips/$tripId/days/$dayId/events/$eventId', data: eventData);

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Failed to update event: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  /// Удалить событие
  Future<void> deleteEvent(int tripId, int dayId, int eventId) async {
    try {
      final response = await _plannerClient.delete('/trips/$tripId/days/$dayId/events/$eventId');

      if (response.statusCode != 204) {
        throw Exception('Failed to delete event: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  // === ERROR HANDLING ===

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