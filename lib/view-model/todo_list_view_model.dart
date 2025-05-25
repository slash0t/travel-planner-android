import 'package:flutter/material.dart';
import 'package:putevod/external/sync_service.dart';

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
  /// List of todo items
  final List<TodoItem> _todoItems = [];
  
  /// Number of active lists
  int _activeListCount = 0;

  /// Gets the list of todo items
  List<TodoItem> get todoItems => _todoItems;
  
  /// Gets the number of active lists
  int get activeListCount => _activeListCount;

  /// Loads the todo items
  Future<void> loadTodoItems() async {
    try {
      final response = await SyncService.instance.getUserTodoLists();
      final List<dynamic> todoLists = response['content'] ?? [];
      
      _todoItems.clear();
      _todoItems.addAll(todoLists.map((data) => TodoItem(
        id: data['id'].toString(),
        title: data['title'] ?? 'Без названия',
        createdAt: DateTime.parse(data['createdAt']),
        completedTasks: data['completedCount'] ?? 0,
        totalTasks: data['itemCount'] ?? 0,
      )));
      
      _activeListCount = _todoItems.length;
      notifyListeners();
    } catch (e) {
      debugPrint('Ошибка загрузки todo-списков: $e');
      _activeListCount = 0;
      notifyListeners();
    }
  }

  /// Creates a new todo list and returns its ID
  Future<String> createNewTodoList() async {
    try {
      final response = await SyncService.instance.createTodoList({
        'title': 'Новый список',
        'description': '',
      });
      
      final newTodoItem = TodoItem(
        id: response['id'].toString(),
        title: response['title'] ?? 'Новый список',
        createdAt: DateTime.parse(response['createdAt']),
        completedTasks: 0,
        totalTasks: 0,
      );
      
      _todoItems.add(newTodoItem);
      _activeListCount = _todoItems.length;
      notifyListeners();
      
      return response['id'].toString();
    } catch (e) {
      debugPrint('Ошибка создания todo-списка: $e');
      rethrow;
    }
  }
  
  /// Deletes a todo list by ID
  Future<void> deleteTodoList(String id) async {
    try {
      await SyncService.instance.deleteTodoList(int.parse(id));
      
      _todoItems.removeWhere((item) => item.id == id);
      _activeListCount = _todoItems.length;
      notifyListeners();
    } catch (e) {
      debugPrint('Ошибка удаления todo-списка: $e');
      rethrow;
    }
  }
  
  /// Updates a todo list with new information
  void updateTodoList(String id, {int? completedTasks, int? totalTasks, String? title}) {
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
} 