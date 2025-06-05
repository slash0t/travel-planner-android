import 'package:flutter/material.dart';
import 'package:putevod/model/app_colors.dart';
import 'package:putevod/view/screens/main_menu_screen.dart';
import 'package:putevod/view/screens/todo_list_screen.dart';
import 'package:putevod/view/screens/trip_search_screen.dart';
import 'package:putevod/view/screens/trips_screen.dart';
import 'package:putevod/view/screens/profile_screen.dart';

/// Tab indices for the bottom navigation bar
enum NavigationTab {
  /// Search tab
  search,

  /// Todo list tab
  todo,

  /// Home/create tab
  home,

  /// Trips tab
  trips,

  /// Profile tab
  profile,
}

/// A reusable bottom navigation panel widget for the application
class AppBottomNavigation extends StatelessWidget {
  /// Currently selected tab
  final NavigationTab selectedTab;

  /// Callback when a tab is tapped
  final Function(NavigationTab) onTabSelected;

  /// Callback when the center button is pressed
  final VoidCallback? onCreatePressed;

  /// Creates a bottom navigation panel that can be used across the app
  const AppBottomNavigation({
    super.key,
    required this.selectedTab,
    required this.onTabSelected,
    this.onCreatePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 65,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(
            color: const Color(0xFFE5E7EB),
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(
            context,
            NavigationTab.search,
            'Поиск',
            Icons.search,
          ),
          _buildNavItem(
            context,
            NavigationTab.todo,
            'TODO',
            Icons.check_box_outlined,
          ),
          /*selectedTab == NavigationTab.home ? _buildNavItem(
            context,
            NavigationTab.home,
            'Создать',
            Icons.add,
            onTap: onCreatePressed,
          ) : _buildNavItem(
            context,
            NavigationTab.home,
            'Главная',
            Icons.home,
          ),*/
          _buildNavItem(
            context,
            NavigationTab.home,
            'Главная',
            Icons.home,
          ),
          _buildNavItem(
            context,
            NavigationTab.trips,
            'Поездки',
            Icons.map_outlined,
          ),
          _buildNavItem(
            context,
            NavigationTab.profile,
            'Профиль',
            Icons.person_outline,
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, NavigationTab tab, String label, IconData icon, {VoidCallback? onTap}) {
    final isSelected = selectedTab == tab;
    final color = isSelected ? AppColors.secondary : AppColors.accent;

    return InkWell(
      onTap: isSelected ? null : (onTap ?? () => _handleNavigation(context, tab)),
      child: Container(
        width: 60,
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              //color: tab == NavigationTab.home ? Colors.black : color,
              color: color,
              size: 20,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: AppColors.text,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Handles navigation to the appropriate screen based on the selected tab
  void _handleNavigation(BuildContext context, NavigationTab tab) {
    // Don't navigate if we're already on this tab
    if (tab == selectedTab) {
      return;
    }

    onTabSelected(tab);

    // Navigate to the appropriate screen
    switch (tab) {
      case NavigationTab.search:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const TripSearchScreen()),
        );
        break;
      case NavigationTab.todo:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const TodoListScreen()),
        );
        break;
      case NavigationTab.home:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MainMenuScreen()),
        );
        break;
      case NavigationTab.trips:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const TripsScreen()),
        );
        break;
      case NavigationTab.profile:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const ProfileScreen()),
        );
        break;
    }
  }
}