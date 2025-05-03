import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:putevod/model/app_colors.dart';
import 'package:putevod/view-model/navigation_view_model.dart';
import 'package:putevod/view/widgets/app_bottom_navigation.dart';
import 'package:putevod/view/widgets/app_header.dart';

/// Main menu screen displayed after login or guest mode
class MainMenuScreen extends StatefulWidget {
  /// Creates the main menu screen
  const MainMenuScreen({super.key});

  @override
  State<MainMenuScreen> createState() => _MainMenuScreenState();
}

class _MainMenuScreenState extends State<MainMenuScreen> {
  void _handleNotificationPressed() {
    // Handle notification button pressed
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Notifications pressed')),
    );
  }

  void _handleCreatePressed() {
    // Handle create new journey button pressed
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Create new journey')),
    );
  }

  void _handleNewTripPressed() {
    // Handle create new trip button pressed
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Create new trip pressed')),
    );
  }

  void _handleLibraryPressed() {
    // Handle library button pressed
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Library pressed')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final navigationViewModel = Provider.of<NavigationViewModel>(context);
    
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // App header
            AppHeader(
              onNotificationPressed: _handleNotificationPressed,
            ),
            
            // Main content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Welcome section
                    _buildWelcomeSection(),

                    const SizedBox(height: 24),

                    // Action buttons
                    _buildActionButtons(),
                    
                    const SizedBox(height: 24),
                    
                    // Trip section
                    _buildTripSection(),
                    
                    const SizedBox(height: 16),
                    
                    // Trip cards
                    _buildTripCards(),
                  ],
                ),
              ),
            ),
            
            // Bottom navigation
            AppBottomNavigation(
              selectedTab: NavigationTab.home,
              onTabSelected: (tab) {
                navigationViewModel.setSelectedTab(tab);
              },
              onCreatePressed: _handleCreatePressed,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Привет, Путешественник!',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            fontFamily: 'NotoSans',
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: _buildActionButton(
            title: 'Новое путешествие',
            icon: Icons.add_circle_outline,
            color: AppColors.secondary,
            onPressed: _handleNewTripPressed,

          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildActionButton(
            title: 'Библиотека',
            icon: Icons.collections_bookmark_outlined,
            color: Colors.white,
            onPressed: _handleLibraryPressed,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Row(
        children: [
          const SizedBox(width: 5),
          Icon(
            icon,
            color: AppColors.text,
            size: 32,
          ),
          const SizedBox(width: 3),
          Text(
            title,
            style: const TextStyle(
              color: AppColors.text,
              fontSize: 14,
              fontWeight: FontWeight.w500,
              fontFamily: 'NotoSans',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTripSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Мои путешествия',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontFamily: 'NotoSans',
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            _buildFilterChip('Все'),
            const SizedBox(width: 8),
            _buildFilterChip('Прошедшие'),
            const SizedBox(width: 8),
            _buildFilterChip('Скоро начнётся', isSelected: true),
          ],
        ),
      ],
    );
  }

  Widget _buildFilterChip(String label, {bool isSelected = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.secondary : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFE5E7EB),
          width: 1,
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 14,
          color: isSelected ? Colors.black : Colors.black,
          fontFamily: 'NotoSans',
        ),
      ),
    );
  }

  Widget _buildTripCards() {
    return Column(
      children: [
        _buildTripCard(
          title: 'Карелия, Онежское озеро',
          date: '20 июня - 27 июня 2023',
          destination: 'Петрозаводск',
          isUpcoming: true,
        ),
        const SizedBox(height: 16),
        _buildTripCard(
          title: 'Италия, Сицилия',
          date: '10 августа - 20 августа 2023',
          destination: 'Палермо',
        ),
        const SizedBox(height: 16),
        _buildTripCard(
          title: 'Поход с друзьями',
          date: '30 июня 2023',
          destination: 'Красная Поляна',
        ),
      ],
    );
  }

  Widget _buildTripCard({
    required String title,
    required String date,
    required String destination,
    bool isUpcoming = false,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'NotoSans',
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  date,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF4B5563),
                    fontFamily: 'NotoSans',
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      size: 16,
                      color: Colors.black,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      destination,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'NotoSans',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (isUpcoming)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              margin: const EdgeInsets.only(left: 16, bottom: 16),
              decoration: BoxDecoration(
                color: AppColors.secondary,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Text(
                'Скоро начнётся',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'NotoSans',
                ),
              ),
            ),
        ],
      ),
    );
  }
} 