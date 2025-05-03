import 'package:flutter/material.dart';

/// Model for a task within a todo list
class Task {
  /// Unique identifier for the task
  final String id;
  
  /// Title of the task
  final String title;
  
  /// Whether the task is completed
  bool isCompleted;

  /// Creates a task
  Task({
    required this.id,
    required this.title,
    this.isCompleted = false,
  });

  /// Creates a copy of this task with the given fields replaced with the new values
  Task copyWith({
    String? id,
    String? title,
    bool? isCompleted,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}

/// Model for a todo list detail with its tasks
class TodoItemDetail {
  /// Unique identifier for the todo list
  final String id;
  
  /// Title of the todo list
  final String title;
  
  /// Date when the todo list was created
  final DateTime createdAt;
  
  /// List of tasks in the todo list
  final List<Task> tasks;

  /// Creates a todo list detail
  TodoItemDetail({
    required this.id,
    required this.title,
    required this.createdAt,
    required this.tasks,
  });

  /// Number of completed tasks
  int get completedTasks => tasks.where((task) => task.isCompleted).length;
  
  /// Total number of tasks
  int get totalTasks => tasks.length;
  
  /// Completion progress from 0 to 1
  double get progress => totalTasks > 0 ? completedTasks / totalTasks : 0.0;

  /// Creates a copy of this todo list with the given fields replaced with the new values
  TodoItemDetail copyWith({
    String? id,
    String? title,
    DateTime? createdAt,
    List<Task>? tasks,
  }) {
    return TodoItemDetail(
      id: id ?? this.id,
      title: title ?? this.title,
      createdAt: createdAt ?? this.createdAt,
      tasks: tasks ?? this.tasks,
    );
  }
} 