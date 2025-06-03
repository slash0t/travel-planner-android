import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:putevod/model/app_colors.dart';
import 'package:putevod/view-model/todo_list_view_model.dart';
import 'package:putevod/view/screens/todo_item_detail_screen.dart';

import '../../model/todo_item_detail.dart';

/// A card widget that displays a todo item
class TodoItemCard extends StatelessWidget {
  /// The todo item to display
  final TodoItemDetail todoItem;

  /// Creates a todo item card
  const TodoItemCard({
    super.key,
    required this.todoItem,
  });

  @override
  Widget build(BuildContext context) {
    return ReorderableDragStartListener(
      index: 0, // Will be overridden by parent ReorderableListView
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TodoItemDetailScreen(todoItemId: todoItem.id),
            ),
          );
        },
        child: Container(
          margin: const EdgeInsets.only(bottom: 15),
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
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  todoItem.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Noto Sans',
                    color: AppColors.text,
                  ),
                ),
                const SizedBox(height: 17),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    //_buildCreatedDateInfo(),
                    _buildCompletionInfo(),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCreatedDateInfo() {
    final dateFormatter = DateFormat('d MMMM yyyy', 'ru');
    return Row(
      children: [
        const Icon(
          Icons.calendar_today_outlined,
          size: 12,
          color: AppColors.text,
        ),
        const SizedBox(width: 4),
        // Text(
        //   'Создан: ${dateFormatter.format(todoItem.createdAt)}',
        //   style: const TextStyle(
        //     fontSize: 14,
        //     fontFamily: 'Noto Sans',
        //     color: Color(0xFF4B5562),
        //   ),
        // ),
      ],
    );
  }

  Widget _buildCompletionInfo() {
    return Row(
      children: [
        const Icon(
          Icons.check_box_outlined,
          size: 14,
          color: AppColors.text,
        ),
        const SizedBox(width: 4),
        Text(
          '${todoItem.completedTasks}/${todoItem.totalTasks}',
          style: const TextStyle(
            fontSize: 14,
            fontFamily: 'Noto Sans',
            color: AppColors.text,
          ),
        ),
      ],
    );
  }
} 