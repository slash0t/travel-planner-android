import 'package:hive_flutter/hive_flutter.dart';
import 'package:putevod/model/trip.dart';
import 'package:putevod/model/place.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class OfflineStorage {
  static const String _tripsBoxName = 'trips';
  static const String _placesBoxName = 'places';
  static const String _syncQueueBoxName = 'sync_queue';
  static const String _metadataBoxName = 'metadata';
  
  static Box<Trip>? _tripsBox;
  static Box<Place>? _placesBox;
  static Box<Map>? _syncQueueBox;
  static Box<Map>? _metadataBox;
  
  // Инициализация Hive
  static Future<void> init() async {
    await Hive.initFlutter();
    
    // Регистрируем адаптеры для моделей
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(TripAdapter());
    }
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(PlaceAdapter());
    }
    
    // Открываем боксы
    _tripsBox = await Hive.openBox<Trip>(_tripsBoxName);
    _placesBox = await Hive.openBox<Place>(_placesBoxName);
    _syncQueueBox = await Hive.openBox<Map>(_syncQueueBoxName);
    _metadataBox = await Hive.openBox<Map>(_metadataBoxName);
  }
  
  // Проверка соединения с интернетом
  static Future<bool> hasConnection() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }
  
  // === TRIPS ===
  
  // Сохранить поездки в оффлайн хранилище
  static Future<void> saveTrips(List<Trip> trips) async {
    final box = _tripsBox!;
    await box.clear();
    for (final trip in trips) {
      await box.put(trip.id.toString(), trip);
    }
    await _updateLastSync('trips');
  }
  
  // Получить поездки из оффлайн хранилища
  static List<Trip> getTrips() {
    final box = _tripsBox!;
    return box.values.toList();
  }
  
  // Сохранить одну поездку
  static Future<void> saveTrip(Trip trip) async {
    final box = _tripsBox!;
    await box.put(trip.id.toString(), trip);
  }
  
  // Получить поездку по ID
  static Trip? getTrip(String tripId) {
    final box = _tripsBox!;
    return box.get(tripId);
  }
  
  // Удалить поездку
  static Future<void> deleteTrip(String tripId) async {
    final box = _tripsBox!;
    await box.delete(tripId);
  }
  
  // === PLACES ===
  
  // Сохранить места в оффлайн хранилище
  static Future<void> savePlaces(List<Place> places) async {
    final box = _placesBox!;
    await box.clear();
    for (final place in places) {
      await box.put(place.id.toString(), place);
    }
    await _updateLastSync('places');
  }
  
  // Получить места из оффлайн хранилища
  static List<Place> getPlaces() {
    final box = _placesBox!;
    return box.values.toList();
  }
  
  // Сохранить одно место
  static Future<void> savePlace(Place place) async {
    final box = _placesBox!;
    await box.put(place.id.toString(), place);
  }
  
  // Получить место по ID
  static Place? getPlace(String placeId) {
    final box = _placesBox!;
    return box.get(placeId);
  }
  
  // === SYNC QUEUE ===
  
  // Добавить операцию в очередь синхронизации
  static Future<void> addToSyncQueue(String operation, Map<String, dynamic> data) async {
    final box = _syncQueueBox!;
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    await box.put(timestamp.toString(), {
      'operation': operation,
      'data': data,
      'timestamp': timestamp,
      'retryCount': 0,
    });
  }
  
  // Получить все операции из очереди синхронизации
  static List<Map<String, dynamic>> getSyncQueue() {
    final box = _syncQueueBox!;
    return box.values.map((e) => Map<String, dynamic>.from(e)).toList();
  }
  
  // Удалить операцию из очереди синхронизации
  static Future<void> removeFromSyncQueue(String key) async {
    final box = _syncQueueBox!;
    await box.delete(key);
  }
  
  // Увеличить счетчик повторных попыток
  static Future<void> incrementRetryCount(String key) async {
    final box = _syncQueueBox!;
    final item = box.get(key);
    if (item != null) {
      item['retryCount'] = (item['retryCount'] ?? 0) + 1;
      await box.put(key, item);
    }
  }
  
  // Очистить очередь синхронизации
  static Future<void> clearSyncQueue() async {
    final box = _syncQueueBox!;
    await box.clear();
  }
  
  // === METADATA ===
  
  // Обновить время последней синхронизации
  static Future<void> _updateLastSync(String type) async {
    final box = _metadataBox!;
    await box.put('lastSync_$type', {
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    });
  }
  
  // Получить время последней синхронизации
  static DateTime? getLastSync(String type) {
    final box = _metadataBox!;
    final data = box.get('lastSync_$type');
    if (data != null && data['timestamp'] != null) {
      return DateTime.fromMillisecondsSinceEpoch(data['timestamp']);
    }
    return null;
  }
  
  // Проверить, нужна ли синхронизация (данные старше 5 минут)
  static bool needsSync(String type) {
    final lastSync = getLastSync(type);
    if (lastSync == null) return true;
    
    final now = DateTime.now();
    final difference = now.difference(lastSync);
    return difference.inMinutes > 5;
  }
  
  // Сохранить версию поездки для проверки конфликтов
  static Future<void> saveTripVersion(String tripId, int version) async {
    final box = _metadataBox!;
    await box.put('tripVersion_$tripId', {
      'version': version,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    });
  }
  
  // Получить версию поездки
  static int? getTripVersion(String tripId) {
    final box = _metadataBox!;
    final data = box.get('tripVersion_$tripId');
    return data?['version'];
  }
  
  // Проверить, есть ли конфликт версий
  static bool hasVersionConflict(String tripId, int serverVersion) {
    final localVersion = getTripVersion(tripId);
    return localVersion != null && localVersion != serverVersion;
  }
  
  // Очистить все данные
  static Future<void> clearAll() async {
    await _tripsBox?.clear();
    await _placesBox?.clear();
    await _syncQueueBox?.clear();
    await _metadataBox?.clear();
  }
  
  // Закрыть все боксы
  static Future<void> close() async {
    await _tripsBox?.close();
    await _placesBox?.close();
    await _syncQueueBox?.close();
    await _metadataBox?.close();
  }
}

// Адаптеры для Hive (нужно будет создать отдельно)
class TripAdapter extends TypeAdapter<Trip> {
  @override
  final int typeId = 0;

  @override
  Trip read(BinaryReader reader) {
    return Trip.fromJson(Map<String, dynamic>.from(reader.readMap()));
  }

  @override
  void write(BinaryWriter writer, Trip obj) {
    writer.writeMap(obj.toJson());
  }
}

class PlaceAdapter extends TypeAdapter<Place> {
  @override
  final int typeId = 1;

  @override
  Place read(BinaryReader reader) {
    return Place.fromJson(Map<String, dynamic>.from(reader.readMap()));
  }

  @override
  void write(BinaryWriter writer, Place obj) {
    writer.writeMap(obj.toJson());
  }
} 