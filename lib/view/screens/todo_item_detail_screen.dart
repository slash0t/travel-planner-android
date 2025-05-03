import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:putevod/model/app_colors.dart';
import 'package:putevod/model/todo_item_detail.dart';
import 'package:putevod/view-model/todo_item_detail_view_model.dart';
import 'package:putevod/view/screens/todo_list_screen.dart';
import 'package:putevod/view/widgets/todo_task_item.dart';
import 'package:putevod/view-model/todo_list_view_model.dart';

/// Screen for viewing and editing a todo list's details
class TodoItemDetailScreen extends StatefulWidget {
  /// The ID of the todo list to display
  final String todoItemId;

  /// Creates a todo item detail screen
  const TodoItemDetailScreen({
    super.key,
    required this.todoItemId,
  });

  @override
  State<TodoItemDetailScreen> createState() => _TodoItemDetailScreenState();
}

class _TodoItemDetailScreenState extends State<TodoItemDetailScreen> {
  final TextEditingController _newTaskController = TextEditingController();
  late TodoItemDetailViewModel _viewModel;
  
  @override
  void initState() {
    super.initState();
    _viewModel = Provider.of<TodoItemDetailViewModel>(context, listen: false);
    final todoListViewModel = Provider.of<TodoListViewModel>(context, listen: false);
    _viewModel.setTodoListViewModel(todoListViewModel);
    
    // Using addPostFrameCallback to prevent notifyListeners during build phase
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadTodoItem();
    });
  }
  
  @override
  void dispose() {
    _newTaskController.dispose();
    super.dispose();
  }
  
  Future<void> _loadTodoItem() async {
    await _viewModel.loadTodoItem(widget.todoItemId);
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Consumer<TodoItemDetailViewModel>(
          builder: (context, viewModel, _) {
            if (viewModel.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            
            if (viewModel.todoItemDetail == null) {
              return const Center(child: Text('Todo list not found'));
            }
            
            return Column(
              children: [
                _buildHeader(viewModel),
                Expanded(
                  child: _buildBody(viewModel),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
  
  Widget _buildHeader(TodoItemDetailViewModel viewModel) {
    final todoItem = viewModel.todoItemDetail!;
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Icon(Icons.arrow_back, size: 20),
              ),
              Row(
                children: [
                  GestureDetector(
                    onTap: _handleDeleteTodoList,
                    child: const Icon(Icons.delete_outline, size: 24),
                  ),
                  const SizedBox(width: 15),
                  GestureDetector(
                    onTap: _handleCopyTodoList,
                    child: const Icon(Icons.copy, size: 20),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          GestureDetector(
            onLongPress: () => _showTitleEditDialog(todoItem.title),
            child: Text(
              todoItem.title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w500,
                fontFamily: 'Noto Sans',
                color: AppColors.text,
              ),
            ),
          ),
          const SizedBox(height: 20),
          _buildProgressBar(todoItem),
          const SizedBox(height: 10),
          Text(
            '${todoItem.completedTasks} из ${todoItem.totalTasks} выполнено',
            style: const TextStyle(
              fontSize: 16,
              fontFamily: 'Noto Sans',
              color: Color(0xFF4B5562),
            ),
          ),
        ],
      ),
    );
  }
  
  void _showTitleEditDialog(String currentTitle) {
    final TextEditingController titleController = TextEditingController(text: currentTitle);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Изменить название'),
        content: TextField(
          controller: titleController,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Введите новое название',
          ),
          style: const TextStyle(
            fontSize: 16,
            fontFamily: 'Noto Sans',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена'),
          ),
          TextButton(
            onPressed: () {
              final newTitle = titleController.text.trim();
              if (newTitle.isNotEmpty) {
                _viewModel.updateTitle(newTitle);
              }
              Navigator.pop(context);
            },
            child: const Text('Сохранить'),
          ),
        ],
      ),
    ).then((_) => titleController.dispose());
  }
  
  Widget _buildProgressBar(TodoItemDetail todoItem) {
    return Container(
      width: double.infinity,
      height: 8,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(9999),
      ),
      child: Row(
        children: [
          Container(
            width: max(0, todoItem.progress * MediaQuery.of(context).size.width - 32),
            height: 8,
            decoration: BoxDecoration(
              color: AppColors.accent,
              borderRadius: BorderRadius.circular(9999),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildBody(TodoItemDetailViewModel viewModel) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildNewTaskInput(),
            const SizedBox(height: 16),
            _buildIncompleteTasks(viewModel),
            const SizedBox(height: 24),
            _buildCompletedTasksSection(viewModel),
          ],
        ),
      ),
    );
  }
  
  Widget _buildNewTaskInput() {
    return Container(
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
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Row(
        children: [
          const Icon(
            Icons.add_circle_outline,
            size: 16,
            color: Color(0xFF9DA3AF),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: _newTaskController,
              decoration: const InputDecoration(
                hintText: 'Добавить новую задачу',
                hintStyle: TextStyle(
                  color: Color(0xFFADAEBC),
                  fontSize: 16,
                  fontFamily: 'Noto Sans',
                ),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
              style: const TextStyle(
                fontSize: 16,
                fontFamily: 'Noto Sans',
                color: AppColors.text,
              ),
              onSubmitted: (value) {
                if (value.isNotEmpty) {
                  _viewModel.addTask(value);
                  _newTaskController.clear();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildIncompleteTasks(TodoItemDetailViewModel viewModel) {
    final incompleteTasks = viewModel.incompleteTasks;
    
    return ReorderableListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: incompleteTasks.length,
      onReorder: viewModel.reorderTasks,
      proxyDecorator: (child, index, animation) {
        return AnimatedBuilder(
          animation: animation,
          builder: (BuildContext context, Widget? child) {
            return Material(
              elevation: 0,
              color: Colors.transparent,
              child: child,
            );
          },
          child: child,
        );
      },
      itemBuilder: (context, index) {
        final task = incompleteTasks[index];
        return Dismissible(
          key: Key(task.id),
          background: Container(
            color: Colors.red,
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 20),
            child: const Icon(Icons.delete, color: Colors.white),
          ),
          direction: DismissDirection.endToStart,
          onDismissed: (_) {
            viewModel.deleteTask(task.id);
          },
          child: TodoTaskItem(
            task: task,
            onToggle: () => viewModel.toggleTaskCompletion(task.id),
          ),
        );
      },
    );
  }
  
  Widget _buildCompletedTasksSection(TodoItemDetailViewModel viewModel) {
    final completedTasks = viewModel.completedTasks;
    
    if (completedTasks.isEmpty) {
      return const SizedBox.shrink();
    }
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () => viewModel.setCompletedExpanded(!viewModel.isCompletedExpanded),
          child: Row(
            children: [
              Icon(
                viewModel.isCompletedExpanded 
                    ? Icons.keyboard_arrow_down
                    : Icons.keyboard_arrow_right,
                size: 16,
                color: const Color(0xFF4B5562),
              ),
              const SizedBox(width: 12),
              Text(
                'Выполненные задачи (${completedTasks.length})',
                style: const TextStyle(
                  fontSize: 16,
                  fontFamily: 'Noto Sans',
                  color: Color(0xFF4B5562),
                ),
              ),
            ],
          ),
        ),
        if (viewModel.isCompletedExpanded) ...[
          const SizedBox(height: 16),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: completedTasks.length,
            itemBuilder: (context, index) {
              final task = completedTasks[index];
              return Dismissible(
                key: Key(task.id),
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                direction: DismissDirection.endToStart,
                onDismissed: (_) {
                  viewModel.deleteTask(task.id);
                },
                child: Opacity(
                  opacity: 0.5,
                  child: TodoTaskItem(
                    task: task,
                    onToggle: () => viewModel.toggleTaskCompletion(task.id),
                  ),
                ),
              );
            },
          ),
        ],
      ],
    );
  }
  
  Future<void> _handleCopyTodoList() async {
    final newId = await _viewModel.copyTodoList();
    if (!mounted) return;
    
    if (newId.isNotEmpty) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => TodoItemDetailScreen(todoItemId: newId),
        ),
      );
    }
  }
  
  Future<void> _handleDeleteTodoList() async {
    await _viewModel.deleteTodoList();
    if (!mounted) return;
    
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const TodoListScreen()),
      (route) => false,
    );
  }
} 