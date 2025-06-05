import 'package:flutter/material.dart';
import 'package:putevod/model/app_colors.dart';
import 'package:putevod/model/todo_item_detail.dart';

/// A widget for displaying a task in a todo list
class TodoTaskItem extends StatelessWidget {
  /// The task to display
  final Task task;
  
  /// Callback for when the task completion is toggled
  final VoidCallback onToggle;

  /// Creates a todo task item
  const TodoTaskItem({
    super.key,
    required this.task,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: const Offset(0, 1),
            blurRadius: 2,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          children: [
            GestureDetector(
              onTap: onToggle,
              child: Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  color: task.completed ? const Color(0xFF84BA83) : const Color(0xFF9DA3AF),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: task.completed
                    ? const Icon(
                        Icons.check,
                        size: 12,
                        color: Colors.white,
                      )
                    : null,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                task.content,
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'NotoSans',
                  color: task.completed ? const Color(0xFF4B5562) : AppColors.text,
                  decoration: task.completed ? TextDecoration.lineThrough : null,
                ),
              ),
            ),
            const SizedBox(width: 12),
            ReorderableDragStartListener(
              index: 0, // This will be overridden by the parent ReorderableListView
              child: const Icon(
                Icons.drag_indicator,
                size: 20,
                color: Color(0xFF9DA3AF),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 