import 'package:flutter/material.dart';
import 'package:putevod/model/todo_item_detail.dart';
import 'package:putevod/view-model/todo_list_view_model.dart';
import 'package:putevod/external/trip_service.dart';
import 'package:uuid/uuid.dart';

class TodoItemDetailViewModel extends ChangeNotifier {
  final TripService _tripService = TripService();

  TodoItemDetail? _todoItemDetail;
  
  bool _isLoading = false;
  
  bool _isCompletedExpanded = false;
  
  TodoListViewModel? _todoListViewModel;

  TodoItemDetail? get todoItemDetail => _todoItemDetail;
  
  bool get isLoading => _isLoading;
  
  bool get isCompletedExpanded => _isCompletedExpanded;

  List<Task> _incompleteTasks = [];

  List<Task> get incompleteTasks => _incompleteTasks;

  List<Task> _completedTasks = [];

  List<Task> get completedTasks => _completedTasks;
  
  void setCompletedExpanded(bool value) {
    _isCompletedExpanded = value;
    notifyListeners();
  }
  
  void setTodoListViewModel(TodoListViewModel viewModel) {
    _todoListViewModel = viewModel;
  }

  Future<void> loadTasks() async {
    if (_todoItemDetail == null) return;

    final response = await _tripService.getTodoListById(_todoItemDetail!.id);
    final todoList = TodoItemDetail.fromJson(response);

    _incompleteTasks = todoList.items.where((a) => !a.completed).toList();
    _incompleteTasks.sort((a, b) => a.orderPosition.compareTo(b.orderPosition));

    _completedTasks = todoList.items.where((a) => a.completed).toList();
    _completedTasks.sort((a, b) => a.orderPosition.compareTo(b.orderPosition));

    notifyListeners();
  }

  Future<void> loadTodoItem(int idString) async {
    _isLoading = true;
    notifyListeners();
    
    try {
      final id = idString;
      final response = await _tripService.getTodoListById(id);
      
      _todoItemDetail = TodoItemDetail.fromJson(response);
      await loadTasks();
    } catch (e) {
      debugPrint('Ошибка загрузки todo-списка: $e');
      _todoItemDetail = TodoItemDetail.empty();
    } finally {
      _isLoading = false;
      _updateTodoListViewModel();
      notifyListeners();
    }
  }

  Future<void> addTask(String content) async {
    if (_todoItemDetail == null || content.trim().isEmpty) return;
    
    try {
      final response = await _tripService.addTodoItem(
        _todoItemDetail!.id,
        {'content': content.trim(), 'completed': false},
      );
      
      final newTask = Task(
        id: response['id'] as int,
        listId: response['listId'] as int,
        content: response['content'],
        completed: response['completed'] as bool,
        orderPosition: response['listId'] as int,
      );
      
      final items = List<Task>.from(_todoItemDetail!.items);
      items.add(newTask);
      
      _todoItemDetail = _todoItemDetail!.copyWith(
        items: items,
        itemCount: items.length,
        completedCount: items.where((task) => task.completed).length,
      );
      _updateTodoListViewModel();
      notifyListeners();
    } catch (e) {
      debugPrint('Ошибка добавления задачи: $e');
    }
  }

  /// Toggles a task's completion status
  Future<void> toggleTaskCompletion(int taskId) async {
    if (_todoItemDetail == null) return;
    
    try {
      final response = await _tripService.toggleTodoItemComplete(
        _todoItemDetail!.id,
        taskId,
      );
      
      final items = List<Task>.from(_todoItemDetail!.items);
      final taskIndex = items.indexWhere((task) => task.id == taskId);
      
      if (taskIndex != -1) {
        items[taskIndex] = items[taskIndex].copyWith(
          completed: response['completed'] ?? !items[taskIndex].completed,
        );
        
        _todoItemDetail = _todoItemDetail!.copyWith(
          items: items,
          completedCount: items.where((task) => task.completed).length,
        );
        _updateTodoListViewModel();
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Ошибка переключения статуса задачи: $e');
    }
  }

  Future<void> reorderTasks(int oldIndex, int newIndex) async {
    if (_todoItemDetail == null) return;
    
    final incompleteTasks = this.incompleteTasks;

    final chosenTask = incompleteTasks[oldIndex];

    if (newIndex > oldIndex) {
      newIndex -= 1;
    }
    
    if (oldIndex == newIndex) return;
    
    final reorderedIncompleteTasks = List<Task>.from(incompleteTasks);
    
    final task = reorderedIncompleteTasks.removeAt(oldIndex);
    reorderedIncompleteTasks.insert(newIndex, task);

    this._incompleteTasks = reorderedIncompleteTasks;

    notifyListeners();

    try {
      await _tripService.reorderTodoTask(
          _todoItemDetail!.id,
          chosenTask.id,
          { "newPosition": newIndex + 1 }
      );
      await loadTasks();
    } catch (e) {
      notifyListeners();
    }

    notifyListeners();
  }

  /// Deletes a task from the todo list
  Future<void> deleteTask(int taskId) async {
    if (_todoItemDetail == null) return;
    
    try {
      await _tripService.deleteTodoItem(
        _todoItemDetail!.id,
        taskId,
      );
      
      final items = _todoItemDetail!.items.where((task) => task.id != taskId).toList();
      _todoItemDetail = _todoItemDetail!.copyWith(
        items: items,
        itemCount: items.length,
        completedCount: items.where((task) => task.completed).length,
      );
      _updateTodoListViewModel();
      notifyListeners();
    } catch (e) {
      debugPrint('Ошибка удаления задачи: $e');
    }
  }

  /// Creates a copy of the current todo list and returns its ID
  Future<int> copyTodoList() async {
    if (_todoItemDetail == null) {
      return 0;
    }
    
    // In a real app, this would create a copy in the database
    // For now, we'll just generate a random ID
    final randomId = DateTime.now().millisecondsSinceEpoch;
    return randomId;
  }

  /// Deletes the current todo list
  Future<void> deleteTodoList() async {
    if (_todoItemDetail == null) {
      return;
    }
    
    if (_todoListViewModel != null && _todoItemDetail != null) {
      await _todoListViewModel!.deleteTodoList(_todoItemDetail!.id.toString());
    }
    
    // The view will handle navigation
  }
  
  /// Updates the TodoListViewModel with the current state
  void _updateTodoListViewModel() {
    if (_todoListViewModel != null && _todoItemDetail != null) {
      _todoListViewModel!.updateTodoListLocal(
        _todoItemDetail!.id.toString(), 
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