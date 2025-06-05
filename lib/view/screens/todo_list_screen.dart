import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:putevod/model/app_colors.dart';
import 'package:putevod/model/analytics_service.dart';
import 'package:putevod/view-model/navigation_view_model.dart';
import 'package:putevod/view-model/todo_list_view_model.dart';
import 'package:putevod/view/widgets/app_header.dart';
import 'package:putevod/view/widgets/app_bottom_navigation.dart';
import 'package:putevod/view/widgets/todo_item_card.dart';
import 'package:putevod/view/screens/todo_item_detail_screen.dart';
import 'package:putevod/view/screens/todo_ai_creation_screen.dart';

class TodoListScreen extends StatefulWidget {
  const TodoListScreen({super.key});

  @override
  State<TodoListScreen> createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  late TodoListViewModel _viewModel;
  
  @override
  void initState() {
    super.initState();
    _viewModel = Provider.of<TodoListViewModel>(context, listen: false);

    // Трекинг просмотра экрана туду листов
    AnalyticsService.trackTodoListView();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadTodoItems();
    });
  }
  
  Future<void> _loadTodoItems() async {
    await _viewModel.loadTodoItems();
  }
  
  @override
  Widget build(BuildContext context) {
    final navigationViewModel = Provider.of<NavigationViewModel>(context);
    
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
          child: Column(
            children: [
              const AppHeader(),
              Expanded(
                child: _buildBody(),
              ),
              AppBottomNavigation(
                selectedTab: NavigationTab.todo,
                onTabSelected: (tab) {
                  navigationViewModel.setSelectedTab(tab);
                },
                onCreatePressed: () {
                  navigationViewModel.setSelectedTab(NavigationTab.home);
                },
              ),
            ],
          ),
      ),
    );
  }
  
  Widget _buildBody() {
    return Consumer<TodoListViewModel>(
      builder: (context, viewModel, _) {
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                _buildHeader(viewModel),
                const SizedBox(height: 25),
                _buildTodoList(viewModel),
              ],
            ),
          ),
        );
      },
    );
  }
  
  Widget _buildHeader(TodoListViewModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Мои TODO-списки',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w500,
            fontFamily: 'NotoSans',
            color: AppColors.text,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          '${viewModel.activeListCount} активных списка',
          style: const TextStyle(
            fontSize: 16,
            fontFamily: 'NotoSans',
            color: Color(0xFF4B5562),
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ElevatedButton.icon(
              icon: const Icon(
                Icons.add,
                color: Colors.white,
                size: 14,
              ),
              label: const Text(
                'Новый список',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'NotoSans',
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accent,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              onPressed: () {
                _showCreateTodoListDialog(context, viewModel);
              },
            ),
          ],
        ),
      ],
    );
  }
  
  void _showCreateTodoListDialog(BuildContext context, TodoListViewModel viewModel) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Создать новый список',
            style: TextStyle(fontFamily: 'NotoSans'),
            ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text(
                  'Создать пустой',
                  style: TextStyle(fontFamily: 'NotoSans'),
                  ),
                onTap: () async {
                  // Трекинг выбора создания пустого списка
                  AnalyticsService.trackTodoListCreationMethodSelected('empty');
                  
                  Navigator.of(context).pop(); // Close the dialog
                  final result = await viewModel.createNewTodoList();
                  
                  // Трекинг успешного создания туду листа
                  if (result != null) {
                    AnalyticsService.trackTodoListCreated('manual');
                  }
                  },
              ),
              ListTile(
                title: const Text(
                  'Создать с помощью ИИ',
                  style: TextStyle(fontFamily: 'NotoSans'),
                  ),
                onTap: () {
                  // Трекинг выбора создания через ИИ
                  AnalyticsService.trackTodoListCreationMethodSelected('ai');
                  
                  Navigator.of(context).pop(); // Close the dialog
                  // Navigate to the AI creation screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const TodoAICreationScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
  
  Widget _buildTodoList(TodoListViewModel viewModel) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: viewModel.todoItems.length,
      // onReorder: viewModel.reorderTodoLists,
      // proxyDecorator: (child, index, animation) {
      //   return AnimatedBuilder(
      //     animation: animation,
      //     builder: (BuildContext context, Widget? child) {
      //       return Material(
      //         elevation: 0,
      //         color: Colors.transparent,
      //         child: child,
      //       );
      //     },
      //     child: child,
      //   );
      // },
      itemBuilder: (context, index) {
        return TodoItemCard(
          key: ValueKey(viewModel.todoItems[index].id),
          todoItem: viewModel.todoItems[index],
        );
      },
    );
  }
} 