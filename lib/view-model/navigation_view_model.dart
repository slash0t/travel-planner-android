import 'package:flutter/material.dart';
import 'package:putevod/view/widgets/app_bottom_navigation.dart';

/// ViewModel for handling navigation state
class NavigationViewModel extends ChangeNotifier {
  /// Current selected navigation tab
  NavigationTab _selectedTab = NavigationTab.home;

  /// Getter for the current selected tab
  NavigationTab get selectedTab => _selectedTab;

  /// Updates the selected tab
  void setSelectedTab(NavigationTab tab) {
    if (_selectedTab != tab) {
      _selectedTab = tab;
      notifyListeners();
    }
  }

  /// Checks if a specific tab is selected
  bool isTabSelected(NavigationTab tab) {
    return _selectedTab == tab;
  }
} 