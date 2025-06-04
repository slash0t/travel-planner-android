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

  double _progress = 0;

  double get progress => _progress;
  
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

    final allCount = completedTasks.length + incompleteTasks.length;
    if (allCount == 0) {
      _progress = 0;
    } else {
      _progress = completedTasks.length / allCount;
    }

    notifyListeners();
  }

  Future<void> loadTodoItem(int id, {bool setLoading = true}) async {
    if (setLoading) {
      _isLoading = true;
      notifyListeners();
    }

    try {
      final response = await _tripService.getTodoListById(id);
      
      _todoItemDetail = TodoItemDetail.fromJson(response);
      await loadTasks();
    } catch (e) {
      debugPrint('Ошибка загрузки todo-списка: $e');
      _todoItemDetail = TodoItemDetail.empty();
    } finally {
      if (setLoading) {
        _isLoading = false;
      }
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
      
      final newTask = Task.fromJson(response);

      _incompleteTasks.add(newTask);
      notifyListeners();

      await loadTasks();
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

      await loadTasks();
      notifyListeners();
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

    var added = 0;
    for (final task in _completedTasks) {
      if (newIndex >= task.orderPosition) {
        added++;
      }
    }

    try {
      await _tripService.reorderTodoTask(
          _todoItemDetail!.id,
          chosenTask.id,
          { "newPosition": newIndex + 1 + added }
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

      await loadTasks();
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
      await _todoListViewModel!.deleteTodoList(_todoItemDetail!.id);
    }
  }

  Future<void> updateTitle(String newTitle) async {
    if (_todoItemDetail == null || newTitle.trim().isEmpty) return;

    _todoItemDetail = _todoItemDetail!.copyWith(title: newTitle.trim());

    try {
      await _tripService.updateTodoList(
        _todoItemDetail!.id,
        { "title": newTitle.trim() }
      );

      await loadTodoItem(_todoItemDetail!.id, setLoading: false);
      notifyListeners();
    } catch (e) {
      debugPrint('Ошибка удаления задачи: $e');
    }

    notifyListeners();
  }
} 