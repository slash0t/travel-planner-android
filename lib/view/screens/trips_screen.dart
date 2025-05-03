import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:putevod/model/app_colors.dart';
import 'package:putevod/model/trip.dart';
import 'package:putevod/view-model/navigation_view_model.dart';
import 'package:putevod/view-model/trips_view_model.dart';
import 'package:putevod/view/widgets/app_header.dart';
import 'package:putevod/view/widgets/app_bottom_navigation.dart';
import 'package:putevod/view/widgets/trip_card.dart';

/// Trips screen implementation matching design
class TripsScreen extends StatelessWidget {
  /// Creates a trips screen
  const TripsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final navigationViewModel = Provider.of<NavigationViewModel>(context);
    final tripsViewModel = Provider.of<TripsViewModel>(context);
    
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            const AppHeader(
              showBackButton: false,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  _buildFilterTabs(tripsViewModel),
                  Expanded(
                    child: _buildTripsList(tripsViewModel, context),
                  ),
                ],
              ),
            ),
            AppBottomNavigation(
              selectedTab: NavigationTab.trips,
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
  
  Widget _buildFilterTabs(TripsViewModel viewModel) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16,),
      child: const Text(
        'Мои поездки',
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w500,
          fontFamily: 'Noto Sans',
          color: AppColors.text,
        ),
      ),
    );
  }
  
  Widget _buildTripsList(TripsViewModel viewModel, BuildContext context) {
    final trips = viewModel.filteredTrips;
    
    if (trips.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/images/empty_trips.png',
              width: 120,
              height: 120,
            ),
            const SizedBox(height: 16),
            const Text(
              'Нет путешествий',
              style: TextStyle(
                fontFamily: 'NotoSans',
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Создайте свое первое путешествие,\nнажав на кнопку ниже',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'NotoSans',
                fontSize: 14,
                color: Colors.black54,
              ),
            ),
          ],
        ),
      );
    }
    
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: trips.length,
      itemBuilder: (context, index) {
        final trip = trips[index];
        return TripCard(
          trip: trip,
          viewModel: viewModel,
          onTap: () {
            // Navigate to trip details screen
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Нажата поездка: ${trip.name}'),
              ),
            );
          },
        );
      },
    );
  }
} 