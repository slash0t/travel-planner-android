import 'package:flutter/material.dart';
import 'package:putevod/model/todo_item_detail.dart';
import 'package:putevod/view-model/todo_list_view_model.dart';
import 'package:putevod/external/trip_service.dart';
import 'package:uuid/uuid.dart';

/// ViewModel for the Todo Item Detail screen
class TodoItemDetailViewModel extends ChangeNotifier {
  final TripService _tripService = TripService();
  static const Uuid _uuid = Uuid();
  
  /// The current todo item detail
  TodoItemDetail? _todoItemDetail;
  
  /// Flag to indicate if the data is loading
  bool _isLoading = false;
  
  /// Flag to indicate if the completed tasks section is expanded
  bool _isCompletedExpanded = false;
  
  /// Reference to the TodoListViewModel for updates
  TodoListViewModel? _todoListViewModel;

  /// Gets the current todo item detail
  TodoItemDetail? get todoItemDetail => _todoItemDetail;
  
  /// Gets whether the data is loading
  bool get isLoading => _isLoading;
  
  /// Gets whether the completed tasks section is expanded
  bool get isCompletedExpanded => _isCompletedExpanded;
  
  /// Gets the incomplete tasks
  List<Task> get incompleteTasks => 
      _todoItemDetail?.tasks.where((task) => !task.isCompleted).toList() ?? [];
  
  /// Gets the completed tasks
  List<Task> get completedTasks => 
      _todoItemDetail?.tasks.where((task) => task.isCompleted).toList() ?? [];
  
  /// Sets whether the completed tasks section is expanded
  void setCompletedExpanded(bool value) {
    _isCompletedExpanded = value;
    notifyListeners();
  }
  
  /// Sets the reference to the TodoListViewModel
  void setTodoListViewModel(TodoListViewModel viewModel) {
    _todoListViewModel = viewModel;
  }

  /// Loads a todo item by id
  Future<void> loadTodoItem(String id) async {
    _isLoading = true;
    notifyListeners();
    
    try {
      final response = await _tripService.getTodoListById(int.parse(id));
      
      final tasks = (response['items'] as List<dynamic>? ?? []).map((itemData) => Task(
        id: itemData['id'].toString(),
        title: itemData['text'] ?? '',
        isCompleted: itemData['completed'] ?? false,
      )).toList();
      
      _todoItemDetail = TodoItemDetail(
        id: id,
        title: response['title'] ?? 'Список задач',
        createdAt: DateTime.parse(response['createdAt']),
        tasks: tasks,
      );
    } catch (e) {
      debugPrint('Ошибка загрузки todo-списка: $e');
      _todoItemDetail = TodoItemDetail(
        id: id,
        title: 'Список задач',
        createdAt: DateTime.now(),
        tasks: [],
      );
    } finally {
      _isLoading = false;
      _updateTodoListViewModel();
      notifyListeners();
    }
  }

  /// Adds a new task to the todo list
  Future<void> addTask(String title) async {
    if (_todoItemDetail == null || title.trim().isEmpty) return;
    
    try {
      final response = await _tripService.addTodoItem(
        int.parse(_todoItemDetail!.id),
        {'text': title.trim(), 'completed': false},
      );
      
      final newTask = Task(
        id: response['id'].toString(),
        title: response['text'] ?? title.trim(),
        isCompleted: response['completed'] ?? false,
      );
      
      final tasks = List<Task>.from(_todoItemDetail!.tasks);
      tasks.add(newTask);
      
      _todoItemDetail = _todoItemDetail!.copyWith(tasks: tasks);
      _updateTodoListViewModel();
      notifyListeners();
    } catch (e) {
      debugPrint('Ошибка добавления задачи: $e');
    }
  }

  /// Toggles a task's completion status
  Future<void> toggleTaskCompletion(String taskId) async {
    if (_todoItemDetail == null) return;
    
    try {
      final response = await _tripService.toggleTodoItemComplete(
        int.parse(_todoItemDetail!.id),
        int.parse(taskId),
      );
      
      final tasks = List<Task>.from(_todoItemDetail!.tasks);
      final taskIndex = tasks.indexWhere((task) => task.id == taskId);
      
      if (taskIndex != -1) {
        tasks[taskIndex] = tasks[taskIndex].copyWith(
          isCompleted: response['completed'] ?? !tasks[taskIndex].isCompleted,
        );
        
        _todoItemDetail = _todoItemDetail!.copyWith(tasks: tasks);
        _updateTodoListViewModel();
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Ошибка переключения статуса задачи: $e');
    }
  }

  /// Reorders the tasks in the todo list
  void reorderTasks(int oldIndex, int newIndex) {
    if (_todoItemDetail == null) return;
    
    final incompleteTasks = this.incompleteTasks;
    
    // Make sure both indices are within the bounds of incompleteTasks
    if (oldIndex < 0 || oldIndex >= incompleteTasks.length || 
        newIndex < 0 || newIndex > incompleteTasks.length) {
      return;
    }
    
    // In Flutter's ReorderableListView, if you move an item down,
    // the index you get for newIndex is incremented by 1
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }
    
    // Only proceed if the indices are different
    if (oldIndex == newIndex) return;
    
    // Create a copy of the incomplete tasks list
    final reorderedIncompleteTasks = List<Task>.from(incompleteTasks);
    
    // Remove the item from the old position and insert it at the new position
    final task = reorderedIncompleteTasks.removeAt(oldIndex);
    reorderedIncompleteTasks.insert(newIndex, task);
    
    // Combine incomplete and completed tasks
    final allTasks = [...reorderedIncompleteTasks, ...completedTasks];
    
    // Update the todo item detail
    _todoItemDetail = _todoItemDetail!.copyWith(tasks: allTasks);
    notifyListeners();
  }

  /// Deletes a task from the todo list
  Future<void> deleteTask(String taskId) async {
    if (_todoItemDetail == null) return;
    
    try {
      await _tripService.deleteTodoItem(
        int.parse(_todoItemDetail!.id),
        int.parse(taskId),
      );
      
      final tasks = _todoItemDetail!.tasks.where((task) => task.id != taskId).toList();
      _todoItemDetail = _todoItemDetail!.copyWith(tasks: tasks);
      _updateTodoListViewModel();
      notifyListeners();
    } catch (e) {
      debugPrint('Ошибка удаления задачи: $e');
    }
  }

  /// Creates a copy of the current todo list and returns its ID
  Future<String> copyTodoList() async {
    if (_todoItemDetail == null) {
      return '';
    }
    
    final newId = _uuid.v4();
    // In a real app, this would create a copy in the database
    
    // For now, we'll just return the new ID
    return newId;
  }

  /// Deletes the current todo list
  Future<void> deleteTodoList() async {
    if (_todoItemDetail == null) {
      return;
    }
    
    // In a real app, this would delete from the database
    await Future.delayed(const Duration(milliseconds: 300));
    
    if (_todoListViewModel != null && _todoItemDetail != null) {
      await _todoListViewModel!.deleteTodoList(_todoItemDetail!.id);
    }
    
    // The view will handle navigation
  }
  
  /// Updates the TodoListViewModel with the current state
  void _updateTodoListViewModel() {
    if (_todoListViewModel != null && _todoItemDetail != null) {
      _todoListViewModel!.updateTodoListLocal(
        _todoItemDetail!.id, 
        completedTasks: _todoItemDetail!.completedTasks, 
        totalTasks: _todoItemDetail!.totalTasks,
        title: _todoItemDetail!.title,
      );
    }
  }

  /// Updates the title of the todo list
  void updateTitle(String newTitle) {
    if (_todoItemDetail == null || newTitle.trim().isEmpty) return;
    
    _todoItemDetail = _todoItemDetail!.copyWith(title: newTitle.trim());
    _updateTodoListViewModel();
    notifyListeners();
  }
} 