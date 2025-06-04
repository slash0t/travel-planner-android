import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:putevod/model/app_colors.dart';
import 'package:putevod/model/trip.dart';
import 'package:putevod/view-model/navigation_view_model.dart';
import 'package:putevod/view-model/trips_view_model.dart';
import 'package:putevod/view/screens/trip_search_screen.dart';
import 'package:putevod/view/widgets/app_bottom_navigation.dart';
import 'package:putevod/view/widgets/app_header.dart';
import 'package:putevod/view/screens/trip_creation_screen.dart';
import 'package:putevod/view/screens/trip_detail_screen.dart';

/// Main menu screen displayed after login or guest mode
class MainMenuScreen extends StatefulWidget {
  /// Creates the main menu screen
  const MainMenuScreen({super.key});

  @override
  State<MainMenuScreen> createState() => _MainMenuScreenState();
}

class _MainMenuScreenState extends State<MainMenuScreen> {
  @override
  void initState() {
    super.initState();
    // Загружаем поездки при инициализации экрана
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<TripsViewModel>(context, listen: false).loadTrips();
    });
  }

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
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const TripCreationScreen()),
    );
  }

  void _handleLibraryPressed() {
    // Handle library button pressed
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const TripSearchScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final navigationViewModel = Provider.of<NavigationViewModel>(context);
    final tripsViewModel = Provider.of<TripsViewModel>(context);
    
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
                    _buildWelcomeSection(),

                    const SizedBox(height: 24),

                    _buildActionButtons(),
                    
                    const SizedBox(height: 24),
                    
                    _buildTripSection(),
                    
                    const SizedBox(height: 16),
                    
                    _buildTripCards(tripsViewModel),
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
            size: 28,
          ),
          const SizedBox(width: 3),
          Text(
            title,
            style: const TextStyle(
              color: AppColors.text,
              fontSize: 13,
              fontWeight: FontWeight.w500,
              fontFamily: 'NotoSans',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTripSection() {
    final tripsViewModel = Provider.of<TripsViewModel>(context);
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
            _buildFilterChip(
              'Текущие', 
              status: TripStatus.ongoing,
              viewModel: tripsViewModel,
            ),
            const SizedBox(width: 8),
            _buildFilterChip(
              'Скоро начнутся',
              status: TripStatus.upcoming,
              viewModel: tripsViewModel,
            ),
            const SizedBox(width: 8),
            _buildFilterChip(
              'Прошедшие', 
              status: TripStatus.completed,
              viewModel: tripsViewModel,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFilterChip(
    String label, {
    required TripStatus status,
    required TripsViewModel viewModel,
  }) {
    final isSelected = viewModel.currentFilter == status;
    
    return GestureDetector(
      onTap: () {
        viewModel.currentFilter = status;
        viewModel.loadTrips();
      },
      child: Container(
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
            color: Colors.black,
            fontFamily: 'NotoSans',
          ),
        ),
      ),
    );
  }

  Widget _buildTripCards(TripsViewModel viewModel) {
    // Use filtered trips based on the current filter
    final filteredTrips = viewModel.trips.where((trip) => trip.status == viewModel.currentFilter).toList();
    
    if (filteredTrips.isEmpty) {
      return const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 20),
            Text(
              'У вас пока нет путешествий',
              style: TextStyle(
                fontFamily: 'NotoSans',
                fontSize: 16,
                color: Colors.black54,
              ),
            ),
          ],
        ),
      );
    }
    
    return Column(
      children: filteredTrips.map((trip) => Column(
        children: [
          _buildTripCard(
            trip: trip,
            viewModel: viewModel,
          ),
          const SizedBox(height: 16),
        ],
      )).toList(),
    );
  }

  Widget _buildTripCard({
    required Trip trip,
    required TripsViewModel viewModel,
  }) {
    return GestureDetector(
      onTap: () {
        // Navigate to trip detail screen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TripDetailScreen(tripId: trip.id),
          ),
        );
      },
      child: Container(
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
                    trip.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'NotoSans',
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    viewModel.getFormattedDateRange(trip),
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
                        trip.city,
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
            Container(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              margin: const EdgeInsets.only(left: 16, bottom: 16),
              decoration: BoxDecoration(
                color: viewModel.getStatusColor(trip.status),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                viewModel.getStatusText(trip.status),
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'NotoSans',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 