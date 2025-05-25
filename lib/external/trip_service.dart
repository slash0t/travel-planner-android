import 'package:dio/dio.dart';
import 'package:putevod/external/api_client.dart';

class TripService {
  final ApiClient _plannerClient = ApiClients.planner;

  // === TRIPS API ===

  /// Получить все поездки пользователя
  Future<List<dynamic>> getUserTrips({
    String status = 'all',
    int limit = 20,
    int offset = 0,
  }) async {
    try {
      final response = await _plannerClient.get(
        '/trips',
        queryParameters: {
          'status': status,
          'limit': limit,
          'offset': offset,
        },
      );

      if (response.statusCode == 200) {
        return response.data['trips'] ?? [];
      } else {
        throw Exception('Failed to get user trips: ${response.statusCode}');
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

  /// Поделиться поездкой
  Future<Map<String, dynamic>> shareTrip(int tripId, String recipient, String permission) async {
    try {
      final response = await _plannerClient.post('/trips/$tripId/share', data: {
        'recipient': recipient,
        'permission': permission,
      });

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Failed to share trip: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  /// Опубликовать поездку в библиотеке
  Future<Map<String, dynamic>> publishTrip(int tripId, Map<String, dynamic> publishData) async {
    try {
      final response = await _plannerClient.post('/trips/$tripId/publish', data: publishData);

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Failed to publish trip: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  // === EVENTS API ===

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

  /// Изменить порядок событий
  Future<void> reorderEvents(int tripId, int dayId, List<int> eventIds) async {
    try {
      final response = await _plannerClient.put('/trips/$tripId/days/$dayId/events/reorder', data: {
        'eventIds': eventIds,
      });

      if (response.statusCode != 200) {
        throw Exception('Failed to reorder events: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  // === TODO LISTS API ===

  /// Получить все todo-списки пользователя
  Future<Map<String, dynamic>> getUserTodoLists({int page = 0, int size = 20}) async {
    try {
      final response = await _plannerClient.get('/todo-lists', queryParameters: {
        'page': page,
        'size': size,
      });

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Failed to get todo lists: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  /// Получить todo-списки для поездки
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

  /// Получить todo-список по ID
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

  /// Создать todo-список
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

  /// Создать todo-список для поездки
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

  /// Обновить todo-список
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

  /// Удалить todo-список
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

  /// Добавить задачу в список
  Future<dynamic> addTodoItem(int listId, Map<String, dynamic> itemData) async {
    try {
      final response = await _plannerClient.post('/todo-lists/$listId/items', data: itemData);

      if (response.statusCode == 201) {
        return response.data;
      } else {
        throw Exception('Failed to add todo item: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  /// Обновить задачу
  Future<dynamic> updateTodoItem(int listId, int itemId, Map<String, dynamic> itemData) async {
    try {
      final response = await _plannerClient.put('/todo-lists/$listId/items/$itemId', data: itemData);

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Failed to update todo item: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  /// Переключить статус задачи
  Future<dynamic> toggleTodoItem(int listId, int itemId) async {
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

  /// Удалить задачу
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

  /// Получить шаблоны todo-списков
  Future<List<dynamic>> getTodoTemplates() async {
    try {
      final response = await _plannerClient.get('/templates');

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Failed to get todo templates: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  /// Получить элементы шаблона
  Future<List<String>> getTemplateItems(int templateId) async {
    try {
      final response = await _plannerClient.get('/templates/$templateId/items');

      if (response.statusCode == 200) {
        return List<String>.from(response.data);
      } else {
        throw Exception('Failed to get template items: ${response.statusCode}');
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