import 'package:flutter/material.dart';
import 'package:putevod/external/trip_service.dart';

/// Model for a Todo item
class TodoItem {
  /// Unique identifier for the todo item
  final String id;
  
  /// Title of the todo item
  final String title;
  
  /// Date when the todo item was created
  final DateTime createdAt;
  
  /// Number of completed tasks
  final int completedTasks;
  
  /// Total number of tasks
  final int totalTasks;

  /// Creates a todo item
  TodoItem({
    required this.id,
    required this.title,
    required this.createdAt,
    required this.completedTasks,
    required this.totalTasks,
  });
}

/// ViewModel for the Todo List screen
class TodoListViewModel extends ChangeNotifier {
  final TripService _tripService = TripService();
  
  /// List of todo items
  final List<TodoItem> _todoItems = [];
  
  /// Number of active lists
  int _activeListCount = 0;
  
  /// Loading state
  bool _isLoading = false;
  
  /// Error message
  String? _errorMessage;

  /// Gets the list of todo items
  List<TodoItem> get todoItems => _todoItems;
  
  /// Gets the number of active lists
  int get activeListCount => _activeListCount;
  
  /// Gets loading state
  bool get isLoading => _isLoading;
  
  /// Gets error message
  String? get errorMessage => _errorMessage;

  /// Loads the todo items
  Future<void> loadTodoItems({int page = 0, int size = 20}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    
    try {
      final response = await _tripService.getUserTodoLists(page: page, size: size);
      final List<dynamic> todoLists = response['content'] ?? [];
      
      _todoItems.clear();
      _todoItems.addAll(todoLists.map((data) => TodoItem(
        id: data['id'].toString(),
        title: data['title'] ?? 'Без названия',
        createdAt: DateTime.tryParse(data['createdAt'] ?? '') ?? DateTime.now(),
        completedTasks: data['completedCount'] ?? 0,
        totalTasks: data['itemCount'] ?? 0,
      )));
      
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
      _todoItems.addAll(todoLists.map((data) => TodoItem(
        id: data['id'].toString(),
        title: data['title'] ?? 'Без названия',
        createdAt: DateTime.tryParse(data['createdAt'] ?? '') ?? DateTime.now(),
        completedTasks: data['completedCount'] ?? 0,
        totalTasks: data['itemCount'] ?? 0,
      )));
      
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
  Future<String> createNewTodoList({String title = 'Новый список', String description = ''}) async {
    try {
      final response = await _tripService.createTodoList({
        'title': title,
        'description': description,
      });
      
      final newTodoItem = TodoItem(
        id: response['id'].toString(),
        title: response['title'] ?? title,
        createdAt: DateTime.tryParse(response['createdAt'] ?? '') ?? DateTime.now(),
        completedTasks: 0,
        totalTasks: 0,
      );
      
      _todoItems.add(newTodoItem);
      _activeListCount = _todoItems.length;
      notifyListeners();
      
      return response['id'].toString();
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
      
      final newTodoItem = TodoItem(
        id: response['id'].toString(),
        title: response['title'] ?? title,
        createdAt: DateTime.tryParse(response['createdAt'] ?? '') ?? DateTime.now(),
        completedTasks: 0,
        totalTasks: 0,
      );
      
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
  Future<void> deleteTodoList(String id) async {
    try {
      await _tripService.deleteTodoList(int.parse(id));
      
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
  Future<void> updateTodoList(String id, Map<String, dynamic> data) async {
    try {
      final response = await _tripService.updateTodoList(int.parse(id), data);
      
      final index = _todoItems.indexWhere((item) => item.id == id);
      if (index != -1) {
        final updatedItem = TodoItem(
          id: id,
          title: response['title'] ?? _todoItems[index].title,
          createdAt: _todoItems[index].createdAt,
          completedTasks: response['completedCount'] ?? _todoItems[index].completedTasks,
          totalTasks: response['itemCount'] ?? _todoItems[index].totalTasks,
        );
        
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
      final updatedItem = TodoItem(
        id: item.id,
        title: title ?? item.title,
        createdAt: item.createdAt,
        completedTasks: completedTasks ?? item.completedTasks,
        totalTasks: totalTasks ?? item.totalTasks,
      );
      
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
        final updatedItem = TodoItem(
          id: item.id,
          title: item.title,
          createdAt: item.createdAt,
          completedTasks: item.completedTasks,
          totalTasks: item.totalTasks + 1,
        );
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
        final updatedItem = TodoItem(
          id: item.id,
          title: item.title,
          createdAt: item.createdAt,
          completedTasks: item.completedTasks,
          totalTasks: item.totalTasks - 1,
        );
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