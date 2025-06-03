class Task {
  final int id;

  final int listId;

  final String content;

  final bool completed;

  final int orderPosition;

  Task({
    required this.id,
    required this.listId,
    required this.content,
    required this.completed,
    required this.orderPosition,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'] as int,
      listId: json['listId'] as int,
      content: json['content'] as String,
      completed: json['completed'] as bool,
      orderPosition: json['orderPosition'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'listId': listId,
      'content': content,
      'completed': completed,
      'orderPosition': orderPosition,
    };
  }

  Task copyWith({
    int? id,
    int? listId,
    String? content,
    bool? completed,
    int? orderPosition,
  }) {
    return Task(
      id: id ?? this.id,
      listId: listId ?? this.listId,
      content: content ?? this.content,
      completed: completed ?? this.completed,
      orderPosition: orderPosition ?? this.orderPosition,
    );
  }
}

class TodoItemDetail {
  final int id;

  final int userId;

  final int tripId;

  final String title;

  final String description;

  final List<Task> items;

  final int itemCount;

  final int completedCount;

  TodoItemDetail({
    required this.id,
    required this.userId,
    required this.tripId,
    required this.title,
    required this.description,
    required this.items,
    required this.itemCount,
    required this.completedCount,
  });

  factory TodoItemDetail.fromJson(Map<String, dynamic> json) {
    return TodoItemDetail(
      id: json['id'] as int,
      userId: json['userId'] as int,
      tripId: json['tripId'] as int,
      title: json['title'] as String,
      description: json['description'] as String,
      items: (json['items'] as List<dynamic>)
          .map((item) => Task.fromJson(item as Map<String, dynamic>))
          .toList(),
      itemCount: json['itemCount'] as int,
      completedCount: json['completedCount'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'tripId': tripId,
      'title': title,
      'description': description,
      'items': items.map((task) => task.toJson()).toList(),
      'itemCount': itemCount,
      'completedCount': completedCount,
    };
  }

  factory TodoItemDetail.empty() {
    return TodoItemDetail(
      id: 0,
      userId: 0,
      tripId: 0,
      title: "Новая поездка",
      description: "Описание",
      items: [],
      itemCount: 0,
      completedCount: 0,
    );
  }

  int get completedTasks => items.where((task) => task.completed).length;
  
  int get totalTasks => itemCount;
  
  double get progress => totalTasks > 0 ? completedTasks / totalTasks : 0.0;

  TodoItemDetail copyWith({
    int? id,
    int? userId,
    int? tripId,
    String? title,
    String? description,
    List<Task>? items,
    int? itemCount,
    int? completedCount,
  }) {
    return TodoItemDetail(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      tripId: tripId ?? this.tripId,
      title: title ?? this.title,
      description: description ?? this.description,
      items: items ?? this.items,
      itemCount: itemCount ?? this.itemCount,
      completedCount: completedCount ?? this.completedCount,
    );
  }
} 