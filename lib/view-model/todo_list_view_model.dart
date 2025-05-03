import 'package:flutter/material.dart';

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
    // In a real app, this would fetch data from a repository or service
    await Future.delayed(const Duration(milliseconds: 500));
    
    _todoItems.clear();
    _todoItems.addAll([
      TodoItem(
        id: '1',
        title: 'Чеклист по ТП. 1 этап',
        createdAt: DateTime(2025, 4, 2),
        completedTasks: 20,
        totalTasks: 20,
      ),
      TodoItem(
        id: '2',
        title: 'Tokyo Adventure',
        createdAt: DateTime(2025, 5, 15),
        completedTasks: 5,
        totalTasks: 15,
      ),
    ]);
    
    _activeListCount = _todoItems.length;
    notifyListeners();
  }

  /// Creates a new todo list
  Future<void> createNewTodoList() async {
    // This would open a dialog or navigate to a new screen to create a todo list
    // For now, we'll just show a placeholder implementation
    
    // In a real app, this would add a new item to the list
    notifyListeners();
  }
} 