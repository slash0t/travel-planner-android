import 'dart:async';
import 'package:putevod/external/offline_storage.dart';
import 'package:putevod/external/trip_service.dart';
import 'package:putevod/model/trip.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class SyncService {
  static SyncService? _instance;
  static SyncService get instance => _instance ??= SyncService._();
  
  SyncService._();
  
  final TripService _tripService = TripService();
  StreamSubscription<ConnectivityResult>? _connectivitySubscription;
  Timer? _syncTimer;
  
  bool _isSyncing = false;
  Function(String)? onSyncStatusChanged;
  Function(String)? onConflictDetected;
  
  // Инициализация службы синхронизации
  void init() {
    // Слушаем изменения соединения
    _connectivitySubscription = Connectivity().onConnectivityChanged.listen(
      (ConnectivityResult result) {
        if (result != ConnectivityResult.none) {
          // Когда соединение восстановлено, запускаем синхронизацию
          _startSync();
        }
      },
    );
    
    // Периодическая синхронизация каждые 10 минут
    _syncTimer = Timer.periodic(
      const Duration(minutes: 10),
      (timer) => _startSync(),
    );
  }
  
  // Запуск синхронизации
  Future<void> _startSync() async {
    if (_isSyncing) return;
    
    final hasConnection = await OfflineStorage.hasConnection();
    if (!hasConnection) {
      onSyncStatusChanged?.call('Нет подключения к интернету');
      return;
    }
    
    _isSyncing = true;
    onSyncStatusChanged?.call('Синхронизация...');
    
    try {
      // 1. Сначала отправляем локальные изменения на сервер
      await _uploadLocalChanges();
      
      // 2. Затем загружаем данные с сервера
      await _downloadServerData();
      
      onSyncStatusChanged?.call('Синхронизация завершена');
    } catch (e) {
      onSyncStatusChanged?.call('Ошибка синхронизации: $e');
    } finally {
      _isSyncing = false;
    }
  }
  
  // Принудительная синхронизация
  Future<void> forceSync() async {
    await _startSync();
  }
  
  // Отправка локальных изменений на сервер
  Future<void> _uploadLocalChanges() async {
    final syncQueue = OfflineStorage.getSyncQueue();
    
    for (final item in syncQueue) {
      try {
        final operation = item['operation'];
        final data = item['data'];
        final timestamp = item['timestamp'].toString();
        
        switch (operation) {
          case 'create_trip':
            await _tripService.createTrip(data);
            await OfflineStorage.removeFromSyncQueue(timestamp);
            break;
            
          case 'update_trip':
            final tripId = data['id'];
            await _tripService.updateTrip(tripId, data);
            await OfflineStorage.removeFromSyncQueue(timestamp);
            break;
            
          case 'delete_trip':
            final tripId = data['id'];
            await _tripService.deleteTrip(tripId);
            await OfflineStorage.removeFromSyncQueue(timestamp);
            break;
            
          // События
          case 'create_event':
            await _tripService.createEvent(data['tripId'], data['dayId'], data);
            await OfflineStorage.removeFromSyncQueue(timestamp);
            break;
            
          case 'update_event':
            await _tripService.updateEvent(data['tripId'], data['dayId'], data['eventId'], data);
            await OfflineStorage.removeFromSyncQueue(timestamp);
            break;
            
          case 'delete_event':
            await _tripService.deleteEvent(data['tripId'], data['dayId'], data['eventId']);
            await OfflineStorage.removeFromSyncQueue(timestamp);
            break;
            
          // Todo-списки
          case 'create_todo_list':
            await _tripService.createTodoList(data);
            await OfflineStorage.removeFromSyncQueue(timestamp);
            break;
            
          case 'update_todo_list':
            await _tripService.updateTodoList(data['listId'], data);
            await OfflineStorage.removeFromSyncQueue(timestamp);
            break;
            
          case 'delete_todo_list':
            await _tripService.deleteTodoList(data['listId']);
            await OfflineStorage.removeFromSyncQueue(timestamp);
            break;
            
          case 'add_todo_item':
            await _tripService.addTodoItem(data['listId'], data);
            await OfflineStorage.removeFromSyncQueue(timestamp);
            break;
            
          case 'toggle_todo_item':
            await _tripService.toggleTodoItem(data['listId'], data['itemId']);
            await OfflineStorage.removeFromSyncQueue(timestamp);
            break;
            
          case 'delete_todo_item':
            await _tripService.deleteTodoItem(data['listId'], data['itemId']);
            await OfflineStorage.removeFromSyncQueue(timestamp);
            break;
        }
      } catch (e) {
        // Увеличиваем счетчик попыток
        await OfflineStorage.incrementRetryCount(item['timestamp'].toString());
        
        // Если слишком много попыток, удаляем из очереди
        if ((item['retryCount'] ?? 0) >= 3) {
          await OfflineStorage.removeFromSyncQueue(item['timestamp'].toString());
        }
      }
    }
  }
  
  // Загрузка данных с сервера
  Future<void> _downloadServerData() async {
    try {
      // Проверяем, нужна ли синхронизация поездок
      if (OfflineStorage.needsSync('trips')) {
        final tripsResponse = await _tripService.getUserTrips();
        // Преобразуем Map<String, dynamic> в Trip объекты
        final trips = tripsResponse.map((tripData) => Trip.fromJson(tripData)).toList();
        await OfflineStorage.saveTrips(trips);
      }
      
      // Можно добавить синхронизацию других данных
      
    } catch (e) {
      throw Exception('Ошибка загрузки данных с сервера: $e');
    }
  }
  
  // Создание поездки с поддержкой оффлайн
  Future<void> createTrip(Map<String, dynamic> tripData) async {
    final hasConnection = await OfflineStorage.hasConnection();
    
    if (hasConnection) {
      try {
        final tripResponse = await _tripService.createTrip(tripData);
        await OfflineStorage.saveTrip(tripResponse);
      } catch (e) {
        // Если не удалось создать онлайн, добавляем в очередь
        await OfflineStorage.addToSyncQueue('create_trip', tripData);
        throw Exception('Поездка будет создана при подключении к интернету');
      }
    } else {
      // Оффлайн режим - добавляем в очередь
      await OfflineStorage.addToSyncQueue('create_trip', tripData);
    }
  }
  
  // Обновление поездки с проверкой конфликтов версий
  Future<void> updateTrip(int tripId, Map<String, dynamic> tripData) async {
    final hasConnection = await OfflineStorage.hasConnection();
    
    if (hasConnection) {
      try {
        // Проверяем версию перед обновлением
        final serverTripResponse = await _tripService.getTripById(tripId);
        final serverVersion = serverTripResponse['version'] ?? 0;
        
        if (OfflineStorage.hasVersionConflict(tripId.toString(), serverVersion)) {
          onConflictDetected?.call(
            'Поездка была изменена другим пользователем. Обновите данные перед сохранением.'
          );
          return;
        }
        
        final updatedTripResponse = await _tripService.updateTrip(tripId, tripData);
        await OfflineStorage.saveTrip(updatedTripResponse);
        await OfflineStorage.saveTripVersion(tripId.toString(), updatedTripResponse['version'] ?? 0);
      } catch (e) {
        // Если не удалось обновить онлайн, добавляем в очередь
        await OfflineStorage.addToSyncQueue('update_trip', {
          'id': tripId,
          ...tripData,
        });
        throw Exception('Изменения будут отправлены при подключении к интернету');
      }
    } else {
      // Оффлайн режим - добавляем в очередь
      await OfflineStorage.addToSyncQueue('update_trip', {
        'id': tripId,
        ...tripData,
      });
    }
  }
  
  // Удаление поездки
  Future<void> deleteTrip(int tripId) async {
    final hasConnection = await OfflineStorage.hasConnection();
    
    if (hasConnection) {
      try {
        await _tripService.deleteTrip(tripId);
        await OfflineStorage.deleteTrip(tripId.toString());
      } catch (e) {
        // Если не удалось удалить онлайн, добавляем в очередь
        await OfflineStorage.addToSyncQueue('delete_trip', {'id': tripId});
        throw Exception('Поездка будет удалена при подключении к интернету');
      }
    } else {
      // Оффлайн режим - удаляем локально и добавляем в очередь
      await OfflineStorage.deleteTrip(tripId.toString());
      await OfflineStorage.addToSyncQueue('delete_trip', {'id': tripId});
    }
  }
  
  // Получение поездок (с кэшированием)
  Future<List<dynamic>> getTrips({bool forceRefresh = false}) async {
    final hasConnection = await OfflineStorage.hasConnection();
    
    if (hasConnection && (forceRefresh || OfflineStorage.needsSync('trips'))) {
      try {
        final tripsResponse = await _tripService.getUserTrips();
        // Преобразуем Map<String, dynamic> в Trip объекты для сохранения
        final trips = tripsResponse.map((tripData) => Trip.fromJson(tripData)).toList();
        await OfflineStorage.saveTrips(trips);
        return tripsResponse;
      } catch (e) {
        // Если не удалось загрузить с сервера, возвращаем кэшированные данные
        return OfflineStorage.getTrips();
      }
    } else {
      // Возвращаем кэшированные данные
      return OfflineStorage.getTrips();
    }
  }
  
  // Получение одной поездки
  Future<dynamic> getTrip(int tripId, {bool forceRefresh = false}) async {
    final hasConnection = await OfflineStorage.hasConnection();
    
    if (hasConnection && forceRefresh) {
      try {
        final tripResponse = await _tripService.getTripById(tripId);
        await OfflineStorage.saveTrip(tripResponse);
        await OfflineStorage.saveTripVersion(tripId.toString(), tripResponse['version'] ?? 0);
        return tripResponse;
      } catch (e) {
        // Если не удалось загрузить с сервера, возвращаем кэшированные данные
        return OfflineStorage.getTrip(tripId.toString());
      }
    } else {
      // Возвращаем кэшированные данные
      return OfflineStorage.getTrip(tripId.toString());
    }
  }
  
  // Получение деталей поездки (alias для getTrip)
  Future<dynamic> getTripDetails(int tripId, {bool forceRefresh = false}) async {
    return await getTrip(tripId, forceRefresh: forceRefresh);
  }
  
  // Получить все события поездки
  Future<List<dynamic>> getTripEvents(int tripId) async {
    final hasConnection = await OfflineStorage.hasConnection();
    
    if (hasConnection) {
      try {
        final events = await _tripService.getTripEvents(tripId);
        // TODO: Кэшировать события
        return events;
      } catch (e) {
        // TODO: Возвращать кэшированные события
        return [];
      }
    } else {
      // TODO: Возвращать кэшированные события
      return [];
    }
  }
  
  // Создать событие
  Future<dynamic> createEvent(int tripId, int dayId, Map<String, dynamic> eventData) async {
    final hasConnection = await OfflineStorage.hasConnection();
    
    if (hasConnection) {
      try {
        return await _tripService.createEvent(tripId, dayId, eventData);
      } catch (e) {
        // Если не удалось создать онлайн, добавляем в очередь
        await OfflineStorage.addToSyncQueue('create_event', {
          'tripId': tripId,
          'dayId': dayId,
          ...eventData,
        });
        throw Exception('Событие будет создано при подключении к интернету');
      }
    } else {
      // Оффлайн режим - добавляем в очередь
      await OfflineStorage.addToSyncQueue('create_event', {
        'tripId': tripId,
        'dayId': dayId,
        ...eventData,
      });
      throw Exception('Событие будет создано при подключении к интернету');
    }
  }
  
  // Обновить событие
  Future<dynamic> updateEvent(int tripId, int dayId, int eventId, Map<String, dynamic> eventData) async {
    final hasConnection = await OfflineStorage.hasConnection();
    
    if (hasConnection) {
      try {
        return await _tripService.updateEvent(tripId, dayId, eventId, eventData);
      } catch (e) {
        // Если не удалось обновить онлайн, добавляем в очередь
        await OfflineStorage.addToSyncQueue('update_event', {
          'tripId': tripId,
          'dayId': dayId,
          'eventId': eventId,
          ...eventData,
        });
        throw Exception('Изменения будут отправлены при подключении к интернету');
      }
    } else {
      // Оффлайн режим - добавляем в очередь
      await OfflineStorage.addToSyncQueue('update_event', {
        'tripId': tripId,
        'dayId': dayId,
        'eventId': eventId,
        ...eventData,
      });
      throw Exception('Изменения будут отправлены при подключении к интернету');
    }
  }
  
  // Удалить событие
  Future<void> deleteEvent(int tripId, int dayId, int eventId) async {
    final hasConnection = await OfflineStorage.hasConnection();
    
    if (hasConnection) {
      try {
        await _tripService.deleteEvent(tripId, dayId, eventId);
      } catch (e) {
        // Если не удалось удалить онлайн, добавляем в очередь
        await OfflineStorage.addToSyncQueue('delete_event', {
          'tripId': tripId,
          'dayId': dayId,
          'eventId': eventId,
        });
        throw Exception('Событие будет удалено при подключении к интернету');
      }
    } else {
      // Оффлайн режим - добавляем в очередь
      await OfflineStorage.addToSyncQueue('delete_event', {
        'tripId': tripId,
        'dayId': dayId,
        'eventId': eventId,
      });
      throw Exception('Событие будет удалено при подключении к интернету');
    }
  }
  
  // === TODO LISTS API ===
  
  // Получить все todo-списки пользователя
  Future<Map<String, dynamic>> getUserTodoLists({int page = 0, int size = 20}) async {
    final hasConnection = await OfflineStorage.hasConnection();
    
    if (hasConnection) {
      try {
        return await _tripService.getUserTodoLists(page: page, size: size);
      } catch (e) {
        // TODO: Возвращать кэшированные данные
        return {'content': []};
      }
    } else {
      // TODO: Возвращать кэшированные данные
      return {'content': []};
    }
  }
  
  // Получить todo-список по ID
  Future<dynamic> getTodoListById(int listId) async {
    final hasConnection = await OfflineStorage.hasConnection();
    
    if (hasConnection) {
      try {
        return await _tripService.getTodoListById(listId);
      } catch (e) {
        // TODO: Возвращать кэшированные данные
        throw Exception('Ошибка загрузки списка задач: $e');
      }
    } else {
      // TODO: Возвращать кэшированные данные
      throw Exception('Нет подключения к интернету');
    }
  }
  
  // Создать todo-список
  Future<dynamic> createTodoList(Map<String, dynamic> todoListData) async {
    final hasConnection = await OfflineStorage.hasConnection();
    
    if (hasConnection) {
      try {
        return await _tripService.createTodoList(todoListData);
      } catch (e) {
        // Если не удалось создать онлайн, добавляем в очередь
        await OfflineStorage.addToSyncQueue('create_todo_list', todoListData);
        throw Exception('Список будет создан при подключении к интернету');
      }
    } else {
      // Оффлайн режим - добавляем в очередь
      await OfflineStorage.addToSyncQueue('create_todo_list', todoListData);
      throw Exception('Список будет создан при подключении к интернету');
    }
  }
  
  // Обновить todo-список
  Future<dynamic> updateTodoList(int listId, Map<String, dynamic> todoListData) async {
    final hasConnection = await OfflineStorage.hasConnection();
    
    if (hasConnection) {
      try {
        return await _tripService.updateTodoList(listId, todoListData);
      } catch (e) {
        // Если не удалось обновить онлайн, добавляем в очередь
        await OfflineStorage.addToSyncQueue('update_todo_list', {
          'listId': listId,
          ...todoListData,
        });
        throw Exception('Изменения будут отправлены при подключении к интернету');
      }
    } else {
      // Оффлайн режим - добавляем в очередь
      await OfflineStorage.addToSyncQueue('update_todo_list', {
        'listId': listId,
        ...todoListData,
      });
      throw Exception('Изменения будут отправлены при подключении к интернету');
    }
  }
  
  // Удалить todo-список
  Future<void> deleteTodoList(int listId) async {
    final hasConnection = await OfflineStorage.hasConnection();
    
    if (hasConnection) {
      try {
        await _tripService.deleteTodoList(listId);
      } catch (e) {
        // Если не удалось удалить онлайн, добавляем в очередь
        await OfflineStorage.addToSyncQueue('delete_todo_list', {'listId': listId});
        throw Exception('Список будет удален при подключении к интернету');
      }
    } else {
      // Оффлайн режим - добавляем в очередь
      await OfflineStorage.addToSyncQueue('delete_todo_list', {'listId': listId});
      throw Exception('Список будет удален при подключении к интернету');
    }
  }
  
  // Добавить задачу в список
  Future<dynamic> addTodoItem(int listId, Map<String, dynamic> itemData) async {
    final hasConnection = await OfflineStorage.hasConnection();
    
    if (hasConnection) {
      try {
        return await _tripService.addTodoItem(listId, itemData);
      } catch (e) {
        // Если не удалось добавить онлайн, добавляем в очередь
        await OfflineStorage.addToSyncQueue('add_todo_item', {
          'listId': listId,
          ...itemData,
        });
        throw Exception('Задача будет добавлена при подключении к интернету');
      }
    } else {
      // Оффлайн режим - добавляем в очередь
      await OfflineStorage.addToSyncQueue('add_todo_item', {
        'listId': listId,
        ...itemData,
      });
      throw Exception('Задача будет добавлена при подключении к интернету');
    }
  }
  
  // Переключить статус задачи
  Future<dynamic> toggleTodoItem(int listId, int itemId) async {
    final hasConnection = await OfflineStorage.hasConnection();
    
    if (hasConnection) {
      try {
        return await _tripService.toggleTodoItem(listId, itemId);
      } catch (e) {
        // Если не удалось переключить онлайн, добавляем в очередь
        await OfflineStorage.addToSyncQueue('toggle_todo_item', {
          'listId': listId,
          'itemId': itemId,
        });
        throw Exception('Изменения будут отправлены при подключении к интернету');
      }
    } else {
      // Оффлайн режим - добавляем в очередь
      await OfflineStorage.addToSyncQueue('toggle_todo_item', {
        'listId': listId,
        'itemId': itemId,
      });
      throw Exception('Изменения будут отправлены при подключении к интернету');
    }
  }
  
  // Удалить задачу
  Future<void> deleteTodoItem(int listId, int itemId) async {
    final hasConnection = await OfflineStorage.hasConnection();
    
    if (hasConnection) {
      try {
        await _tripService.deleteTodoItem(listId, itemId);
      } catch (e) {
        // Если не удалось удалить онлайн, добавляем в очередь
        await OfflineStorage.addToSyncQueue('delete_todo_item', {
          'listId': listId,
          'itemId': itemId,
        });
        throw Exception('Задача будет удалена при подключении к интернету');
      }
    } else {
      // Оффлайн режим - добавляем в очередь
      await OfflineStorage.addToSyncQueue('delete_todo_item', {
        'listId': listId,
        'itemId': itemId,
      });
      throw Exception('Задача будет удалена при подключении к интернету');
    }
  }
  
  // Проверка статуса синхронизации
  bool get isSyncing => _isSyncing;
  
  // Получение количества операций в очереди
  int get pendingOperationsCount => OfflineStorage.getSyncQueue().length;
  
  // Очистка всех данных
  Future<void> clearAllData() async {
    await OfflineStorage.clearAll();
  }
  
  // Остановка службы
  void dispose() {
    _connectivitySubscription?.cancel();
    _syncTimer?.cancel();
  }
} 