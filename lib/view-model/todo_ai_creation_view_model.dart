import 'package:flutter/material.dart';
import 'package:putevod/view-model/todo_list_view_model.dart'; // TodoItem is in this file

class TodoAICreationViewModel extends ChangeNotifier {
  final TodoListViewModel _todoListViewModel;

  TodoAICreationViewModel(this._todoListViewModel);

  // Form fields
  String? _tripType;
  String _direction = '';
  String? _season;
  int _duration = 7;
  String _additionalInfo = '';

  // Getters for form fields
  String? get tripType => _tripType;
  String get direction => _direction;
  String? get season => _season;
  int get duration => _duration;
  String get additionalInfo => _additionalInfo;

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

  Future<String> generateTodoList() async {
    _isLoading = true;
    notifyListeners();

    // Simulate AI generation
    await Future.delayed(const Duration(seconds: 2));

    final title = _generateTitle();
    // Create a new todo list
    final newTodoListId = await _todoListViewModel.createNewTodoList();

    // Update the newly created list with the generated title.
    // We assume completedTasks and totalTasks will be 0 initially.
    _todoListViewModel.updateTodoList(
      newTodoListId,
      {

      }
      // completedTasks and totalTasks will default to 0 based on createNewTodoList
      // or can be explicitly set if your updateTodoList handles it.
    );

    _isLoading = false;
    notifyListeners();
    return newTodoListId;
  }

  String _generateTitle() {
    String generatedTitle = 'AI: ';
    if (_tripType != null && _tripType!.isNotEmpty) {
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