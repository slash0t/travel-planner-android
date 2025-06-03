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
      _todoItemDetail?.items.where((task) => !task.completed).toList() ?? [];
  
  /// Gets the completed tasks
  List<Task> get completedTasks => 
      _todoItemDetail?.items.where((task) => task.completed).toList() ?? [];
  
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
  Future<void> loadTodoItem(int idString) async {
    _isLoading = true;
    notifyListeners();
    
    try {
      final id = idString;
      final response = await _tripService.getTodoListById(id);
      
      final tasks = (response['items'] as List<dynamic>? ?? []).map((itemData) => Task(
        id: itemData['id'] as int,
        listId: id,
        content: itemData['text'] ?? '',
        completed: itemData['completed'] ?? false,
        orderPosition: itemData['orderPosition'] as int? ?? 0,
      )).toList();
      
      _todoItemDetail = TodoItemDetail(
        id: id,
        userId: response['userId'] as int? ?? 0,
        tripId: response['tripId'] as int? ?? 0,
        title: response['title'] ?? 'Список задач',
        description: response['description'] ?? '',
        items: tasks,
        itemCount: tasks.length,
        completedCount: tasks.where((task) => task.completed).length,
      );
    } catch (e) {
      debugPrint('Ошибка загрузки todo-списка: $e');
      final id = idString;
      _todoItemDetail = TodoItemDetail(
        id: id,
        userId: 0,
        tripId: 0,
        title: 'Список задач',
        description: '',
        items: [],
        itemCount: 0,
        completedCount: 0,
      );
    } finally {
      _isLoading = false;
      _updateTodoListViewModel();
      notifyListeners();
    }
  }

  /// Adds a new task to the todo list
  Future<void> addTask(String content) async {
    if (_todoItemDetail == null || content.trim().isEmpty) return;
    
    try {
      final response = await _tripService.addTodoItem(
        _todoItemDetail!.id,
        {'text': content.trim(), 'completed': false},
      );
      
      final newTask = Task(
        id: response['id'] as int? ?? 0,
        listId: _todoItemDetail!.id,
        content: response['text'] ?? content.trim(),
        completed: response['completed'] ?? false,
        orderPosition: _todoItemDetail!.items.length,
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
    
    // Update order positions
    for (int i = 0; i < reorderedIncompleteTasks.length; i++) {
      reorderedIncompleteTasks[i] = reorderedIncompleteTasks[i].copyWith(orderPosition: i);
    }
    
    // Combine incomplete and completed tasks
    final allTasks = [...reorderedIncompleteTasks, ...completedTasks];
    
    // Update the todo item detail
    _todoItemDetail = _todoItemDetail!.copyWith(items: allTasks);
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
    
    // In a real app, this would delete from the database
    await Future.delayed(const Duration(milliseconds: 300));
    
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