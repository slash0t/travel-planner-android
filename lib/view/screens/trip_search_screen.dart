import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:putevod/model/app_colors.dart';
import 'package:putevod/model/library_trip.dart';
import 'package:putevod/view-model/navigation_view_model.dart';
import 'package:putevod/view/screens/library_trip_detail_screen.dart';
import 'package:putevod/view/widgets/app_bottom_navigation.dart';
import 'package:putevod/view/widgets/app_header.dart';
import 'package:putevod/view/widgets/categories_widget.dart';
import 'package:putevod/view/widgets/search_bar_widget.dart';
import 'package:putevod/view/widgets/trip_card_widget.dart';
import 'package:putevod/view-model/trip_search_view_model.dart';

/// The trip search screen that allows users to search for trips
class TripSearchScreen extends StatelessWidget {
  /// Creates a trip search screen
  const TripSearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TripSearchViewModel(),
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              Expanded(
                child: _buildBody(),
              ),
              _buildBottomNavigation(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return const AppHeader(
      showBackButton: false,
    );
  }

  Widget _buildBottomNavigation(BuildContext context) {
    final navigationViewModel = Provider.of<NavigationViewModel>(context);
    
    return AppBottomNavigation(
      selectedTab: NavigationTab.search,
      onTabSelected: (tab) {
        navigationViewModel.setSelectedTab(tab);
      },
      onCreatePressed: () {
        navigationViewModel.setSelectedTab(NavigationTab.home);
      },
    );
  }

  Widget _buildBody() {
    return Consumer<TripSearchViewModel>(
      builder: (context, viewModel, _) {
        return Column(
          children: [
            SearchBarWidget(
              searchQuery: viewModel.searchQuery,
              onQueryChanged: viewModel.setSearchQuery,
              onFilterPressed: () {
                // Handle filter button press
              },
            ),
            // CategoriesWidget(
            //   categories: viewModel.categories,
            //   onCategorySelected: viewModel.selectCategory,
            // ),
            Expanded(
              child: _buildTripList(context, viewModel),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTripList(BuildContext context, TripSearchViewModel viewModel) {
    if (viewModel.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    
    if (viewModel.errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Произошла ошибка',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.text,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              viewModel.errorMessage!,
              style: TextStyle(
                fontSize: 14,
                color: AppColors.text.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                viewModel.clearError();
                viewModel.init();
              },
              child: const Text('Повторить'),
            ),
          ],
        ),
      );
    }
    
    if (viewModel.trips.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 48,
              color: AppColors.text.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'Поездки не найдены',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.text,
              ),
            ),
          ],
        ),
      );
    }
    
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Поездки',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'NotoSans',
                  color: AppColors.text,
                ),
              ),
              Text(
                'Найдено: ${viewModel.trips.length}',
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: 'NotoSans',
                  color: AppColors.text.withOpacity(0.7),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: viewModel.trips.length,
            itemBuilder: (context, index) {
              final trip = viewModel.trips[index];
              return GestureDetector(
                onTap: () => _navigateToTripDetails(context, trip),
                child: TripCardWidget(
                  trip: trip,
                  onCopyTrip: viewModel.copyTripToUser,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
  
  void _navigateToTripDetails(BuildContext context, LibraryTrip trip) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TripDetailsScreen(trip: trip),
      ),
    );
  }
} 