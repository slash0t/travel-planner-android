import 'package:flutter/material.dart';
import 'package:putevod/view/widgets/app_bottom_navigation.dart';
import 'package:putevod/view/widgets/app_header.dart';

/// Example screen demonstrating how to use the custom widgets
class ExampleScreen extends StatefulWidget {
  /// Creates an example screen
  const ExampleScreen({super.key});

  @override
  State<ExampleScreen> createState() => _ExampleScreenState();
}

class _ExampleScreenState extends State<ExampleScreen> {
  NavigationTab _selectedTab = NavigationTab.home;

  void _handleTabSelected(NavigationTab tab) {
    setState(() {
      _selectedTab = tab;
    });
  }

  void _handleNotificationPressed() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Notification Pressed')),
    );
  }

  void _handleCreatePressed() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Create new item')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // App header widget
          AppHeader(
            onNotificationPressed: _handleNotificationPressed,
          ),
          
          // Content area
          Expanded(
            child: Center(
              child: Text(
                'Current tab: ${_selectedTab.name}',
                style: const TextStyle(
                  fontSize: 20,
                  fontFamily: 'NotoSans',
                ),
              ),
            ),
          ),
          
          // Bottom navigation panel
          AppBottomNavigation(
            selectedTab: _selectedTab,
            onTabSelected: _handleTabSelected,
            onCreatePressed: _selectedTab == NavigationTab.home 
                ? _handleCreatePressed 
                : null,
          ),
        ],
      ),
    );
  }
} 