import 'package:flutter/material.dart';
import 'package:putevod/external/trip_service.dart';

import '../model/todo_item_detail.dart';

class TodoListViewModel extends ChangeNotifier {
  final TripService _tripService = TripService();
  
  final List<TodoItemDetail> _todoItems = [];
  
  int _activeListCount = 0;
  
  bool _isLoading = false;
  
  String? _errorMessage;

  List<TodoItemDetail> get todoItems => _todoItems;
  
  int get activeListCount => _activeListCount;
  
  bool get isLoading => _isLoading;
  
  String? get errorMessage => _errorMessage;

  Future<void> loadTodoItems() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    
    try {
      final response = await _tripService.getUserTodoLists();
      final List<dynamic> todoLists = response['content'] ?? [];
      
      _todoItems.clear();
      final items = todoLists.map((data) => TodoItemDetail.fromJson(data)).toList();
      _todoItems.addAll(items);
      
      _activeListCount = _todoItems.length;
    } catch (e) {
      _errorMessage = 'Ошибка загрузки todo-списков: $e';
      _activeListCount = 0;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Loads todo lists for a specific trip
  Future<void> loadTripTodoLists(int tripId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    
    try {
      final todoLists = await _tripService.getTripTodoLists(tripId);
      
      _todoItems.clear();
      _todoItems.addAll(todoLists.map((data) => TodoItemDetail.fromJson(data)));
      
      _activeListCount = _todoItems.length;
    } catch (e) {
      _errorMessage = 'Ошибка загрузки todo-списков поездки: $e';
      _activeListCount = 0;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Creates a new todo list and returns its ID
  Future<int> createNewTodoList({String title = 'Новый список', String description = ''}) async {
    try {
      final response = await _tripService.createTodoList({
        'title': title,
        'description': description,
      });
      
      final newTodoItem = TodoItemDetail.fromJson(response);
      
      _todoItems.add(newTodoItem);
      _activeListCount = _todoItems.length;
      notifyListeners();
      
      return response['id'] as int;
    } catch (e) {
      _errorMessage = 'Ошибка создания todo-списка: $e';
      notifyListeners();
      rethrow;
    }
  }

  /// Creates a new todo list for a specific trip
  Future<String> createTripTodoList(int tripId, {String title = 'Новый список', String description = ''}) async {
    try {
      final response = await _tripService.createTripTodoList(tripId, {
        'title': title,
        'description': description,
      });
      
      final newTodoItem = TodoItemDetail.empty();
      
      _todoItems.add(newTodoItem);
      _activeListCount = _todoItems.length;
      notifyListeners();
      
      return response['id'].toString();
    } catch (e) {
      _errorMessage = 'Ошибка создания todo-списка для поездки: $e';
      notifyListeners();
      rethrow;
    }
  }
  
  /// Deletes a todo list by ID
  Future<void> deleteTodoList(int id) async {
    try {
      await _tripService.deleteTodoList(id);
      
      _todoItems.removeWhere((item) => item.id == id);
      _activeListCount = _todoItems.length;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Ошибка удаления todo-списка: $e';
      notifyListeners();
      rethrow;
    }
  }

  /// Updates a todo list
  Future<void> updateTodoList(int id, Map<String, dynamic> data) async {
    try {
      final response = await _tripService.updateTodoList(id, data);
      
      final index = _todoItems.indexWhere((item) => item.id == id);
      if (index != -1) {
        final updatedItem = TodoItemDetail.empty();
        
        _todoItems[index] = updatedItem;
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = 'Ошибка обновления todo-списка: $e';
      notifyListeners();
      rethrow;
    }
  }
  
  /// Updates a todo list with new information (local update)
  void updateTodoListLocal(String id, {int? completedTasks, int? totalTasks, String? title}) {
    final index = _todoItems.indexWhere((item) => item.id == id);
    if (index != -1) {
      final item = _todoItems[index];
      final updatedItem = TodoItemDetail.empty();
      
      _todoItems[index] = updatedItem;
      notifyListeners();
    }
  }

  /// Get todo list by ID
  Future<Map<String, dynamic>> getTodoListById(String id) async {
    try {
      return await _tripService.getTodoListById(int.parse(id));
    } catch (e) {
      _errorMessage = 'Ошибка получения todo-списка: $e';
      notifyListeners();
      rethrow;
    }
  }

  /// Add todo item to list
  Future<void> addTodoItem(String listId, Map<String, dynamic> itemData) async {
    try {
      await _tripService.addTodoItem(int.parse(listId), itemData);
      // Обновляем локальную информацию о списке
      final index = _todoItems.indexWhere((item) => item.id == listId);
      if (index != -1) {
        final item = _todoItems[index];
        final updatedItem = TodoItemDetail.empty();
        _todoItems[index] = updatedItem;
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = 'Ошибка добавления задачи: $e';
      notifyListeners();
      rethrow;
    }
  }

  /// Toggle todo item completion
  Future<void> toggleTodoItemComplete(String listId, int itemId) async {
    try {
      await _tripService.toggleTodoItemComplete(int.parse(listId), itemId);
      // После изменения статуса задачи можно перезагрузить список
      // или обновить счетчики локально
    } catch (e) {
      _errorMessage = 'Ошибка изменения статуса задачи: $e';
      notifyListeners();
      rethrow;
    }
  }

  /// Delete todo item
  Future<void> deleteTodoItem(String listId, int itemId) async {
    try {
      await _tripService.deleteTodoItem(int.parse(listId), itemId);
      // Обновляем локальную информацию о списке
      final index = _todoItems.indexWhere((item) => item.id == listId);
      if (index != -1) {
        final item = _todoItems[index];
        final updatedItem = TodoItemDetail.empty();
        _todoItems[index] = updatedItem;
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = 'Ошибка удаления задачи: $e';
      notifyListeners();
      rethrow;
    }
  }

  /// Reorders the todo lists
  void reorderTodoLists(int oldIndex, int newIndex) {
    // Make sure both indices are within bounds
    if (oldIndex < 0 || oldIndex >= _todoItems.length || 
        newIndex < 0 || newIndex > _todoItems.length) {
      return;
    }
    
    // In Flutter's ReorderableListView, if you move an item down,
    // the index you get for newIndex is incremented by 1
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }
    
    // Only proceed if the indices are different
    if (oldIndex == newIndex) return;
    
    // Remove the item from the old position and insert it at the new position
    final todoItem = _todoItems.removeAt(oldIndex);
    _todoItems.insert(newIndex, todoItem);
    
    notifyListeners();
  }

  /// Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
} 