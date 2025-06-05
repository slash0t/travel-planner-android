import 'package:flutter/material.dart';
import 'package:putevod/model/analytics_service.dart';
import 'package:putevod/model/trip.dart';
import 'package:putevod/view-model/todo_list_view_model.dart';

import '../external/external_service.dart'; // TodoItem is in this file

class TodoAICreationViewModel extends ChangeNotifier {
  final ExternalService _externalService = ExternalService();
  final TodoListViewModel _todoListViewModel;

  TodoAICreationViewModel(this._todoListViewModel) {
    _fetchAvailableTrips();
  }

  // Form fields
  String? _tripType;
  String _direction = '';
  String? _season;
  int _duration = 7;
  String _additionalInfo = '';
  Trip? _selectedTrip;
  List<Trip> _availableTrips = [];

  // Getters for form fields
  String? get tripType => _tripType;
  String get direction => _direction;
  String? get season => _season;
  int get duration => _duration;
  String get additionalInfo => _additionalInfo;
  Trip? get selectedTrip => _selectedTrip;
  List<Trip> get availableTrips => _availableTrips;

  // Available options
  final List<String> tripTypes = ['Деловая поездка', 'Отпуск', 'Поездка на дачу'];
  final Map<String, String> seasons = {
    'Лето': '☀️',
    'Осень': '🍂',
    'Зима': '❄️',
    'Весна': '🌸',
  };

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // Fetch available trips from service/repository
  Future<void> _fetchAvailableTrips() async {
    // In a real app, this would come from a service or repository
    // For now, we'll use sample data
    _availableTrips = [
      Trip(
        id: 1,
        title: "Поездка в Москву",
        startDate: DateTime(2023, 7, 15),
        endDate: DateTime(2023, 7, 20),
        days: [],
        country: "Россия",
        city: "Москва",
        description: "Деловая поездка в Москву",
      ),
      Trip(
        id: 2,
        title: "Отпуск в Сочи",
        startDate: DateTime(2023, 8, 1),
        endDate: DateTime(2023, 8, 10),
        days: [],
        country: "Россия",
        city: "Сочи",
        description: "Летний отпуск на море",
      ),
      Trip(
        id: 3,
        title: "Поездка в Санкт-Петербург",
        startDate: DateTime(2023, 5, 10),
        endDate: DateTime(2023, 5, 15),
        days: [],
        country: "Россия",
        city: "Санкт-Петербург",
        description: "Культурная поездка в Санкт-Петербург",
      ),
    ];
    notifyListeners();
  }

  // Setters for form fields
  void setTripType(String? value) {
    _tripType = value;
    notifyListeners();
  }

  void setDirection(String value) {
    _direction = value;
    notifyListeners();
  }

  void setSeason(String? value) {
    _season = value;
    notifyListeners();
  }

  void setDuration(int value) {
    _duration = value;
    notifyListeners();
  }

  void setAdditionalInfo(String value) {
    _additionalInfo = value;
    notifyListeners();
  }

  void setSelectedTrip(Trip? trip) {
    _selectedTrip = trip;
    if (trip != null) {
      // Populate form fields with trip data
      _direction = '${trip.country}, ${trip.city}';
      
      // Calculate duration from start and end dates
      _duration = trip.endDate.difference(trip.startDate).inDays + 1;
      
      // Determine season based on start date
      final month = trip.startDate.month;
      if (month >= 6 && month <= 8) {
        _season = 'Лето';
      } else if (month >= 9 && month <= 11) {
        _season = 'Осень';
      } else if (month == 12 || month <= 2) {
        _season = 'Зима';
      } else {
        _season = 'Весна';
      }
      
      _additionalInfo = trip.description;
    }
    notifyListeners();
  }

  Future<void> generateTodoList() async {
    _isLoading = true;
    notifyListeners();

    try {
      final request = {
        "prompt": "Сделай список для сбора человеку в обычную поездку, который бы подошел на любой случай, учитывая другие факторы",
        "duration": _duration,
        "destination": _direction,
        "season": _season,
        "additionalPrompt": _additionalInfo,
      };

      await _externalService.generatePackingList(request);

      // Трекинг успешного создания туду листа через ИИ
      AnalyticsService.trackAITodoListCreated(
        _direction,
        _season ?? 'unknown',
        _duration,
      );
      
      // Также отправляем общий трекинг создания туду листа
      AnalyticsService.trackTodoListCreated('ai');
      
    } catch (e) {
      // Трекинг ошибки создания туду листа через ИИ
      AnalyticsService.trackAITodoListCreationFailed(e.toString());
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  String _generateTitle() {
    String generatedTitle = 'AI: ';
    if (_selectedTrip != null) {
      generatedTitle += 'На основе "${_selectedTrip!.title}" ';
    } else if (_tripType != null && _tripType!.isNotEmpty) {
      generatedTitle += '$_tripType ';
    }
    if (_direction.isNotEmpty) {
      generatedTitle += 'в $_direction ';
    }
    if (_season != null && _season!.isNotEmpty) {
      generatedTitle += '($_season) ';
    }
    generatedTitle += 'на $_duration дней';
    return generatedTitle.trim();
  }
} 