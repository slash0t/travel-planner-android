import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:putevod/model/app_colors.dart';
import 'package:putevod/model/trip.dart';
import 'package:putevod/view-model/navigation_view_model.dart';
import 'package:putevod/view-model/trips_view_model.dart';
import 'package:putevod/view/screens/trip_creation_screen.dart';
import 'package:putevod/view/screens/trip_detail_screen.dart';
import 'package:putevod/view/widgets/app_header.dart';
import 'package:putevod/view/widgets/app_bottom_navigation.dart';
import 'package:putevod/view/widgets/trip_card.dart';


/// Trips screen implementation matching design
class TripsScreen extends StatefulWidget {
  /// Creates a trips screen
  const TripsScreen({super.key});

  @override
  State<TripsScreen> createState() => _TripsScreenState();
}

class _TripsScreenState extends State<TripsScreen> {
  @override
  void initState() {
    super.initState();
    // Загружаем поездки при инициализации экрана
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<TripsViewModel>(context, listen: false).loadAllTrips();
    });
  }

  @override
  Widget build(BuildContext context) {
    final navigationViewModel = Provider.of<NavigationViewModel>(context);
    final tripsViewModel = Provider.of<TripsViewModel>(context);
    
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const TripCreationScreen()),
                    );
                  },
                ),
              ],
            ),
            // Create trip button in bottom right
            Positioned(
              right: 16,
              bottom: 90, // Position above bottom navigation
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const TripCreationScreen()),
                  );
                },
                child: Container(
                  width: 129,
                  height: 58,
                  decoration: BoxDecoration(
                    color: AppColors.secondary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add, size: 14, color: Colors.black),
                      SizedBox(width: 8),
                      Text(
                        'Создать',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500, 
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
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
    // Показываем индикатор загрузки
    if (viewModel.isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          color: AppColors.accent,
        ),
      );
    }
    
    // Показываем ошибку если есть
    if (viewModel.errorMessage != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.error_outline,
              size: 48,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            Text(
              'Ошибка загрузки',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              viewModel.errorMessage!,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                viewModel.clearError();
                viewModel.loadAllTrips();
              },
              child: const Text('Повторить'),
            ),
          ],
        ),
      );
    }
    
    final trips = viewModel.filteredTrips;
    
    if (trips.isEmpty) {
      return const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
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
    
    return RefreshIndicator(
      color: AppColors.accent,
      onRefresh: () => viewModel.loadAllTrips(),
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: trips.length,
        itemBuilder: (context, index) {
          final trip = trips[index];
          return TripCard(
            trip: trip,
            viewModel: viewModel,
            onTap: () {
              // Navigate to trip details or edit screen
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TripDetailScreen(tripId: trip.id),
                ),
              );
            },
          );
        },
      ),
    );
  }
} 