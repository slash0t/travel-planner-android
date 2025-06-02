import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:putevod/model/app_colors.dart';
import 'package:putevod/model/trip_day.dart';
import 'package:putevod/model/trip_location.dart';
import 'package:putevod/view-model/trip_map_view_model.dart';

/// Trip Map Screen displaying a trip on a map with days and locations
class TripMapScreen extends StatelessWidget {
  /// Constructor for TripMapScreen
  const TripMapScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TripMapViewModel(),
      child: const _TripMapView(),
    );
  }
}

class _TripMapView extends StatelessWidget {
  const _TripMapView();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<TripMapViewModel>();
    final trip = viewModel.trip;

    if (trip == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      body: Stack(
        children: [
          // Map covering the entire screen
          _buildMap(viewModel),
          
          // Header with back button and trip title
          _buildHeader(context, trip.city),
          
          // Day selector tabs
          //_buildDaySelector(context, viewModel),
          
          // Location details at the bottom
          if (viewModel.selectedLocation != null) 
            _buildLocationDetails(context, viewModel),
            
          // Map controls on the right side
          _buildMapControls(context, viewModel),
        ],
      ),
    );
  }

  Widget _buildMap(TripMapViewModel viewModel) {
    return FlutterMap(
      options: MapOptions(
        initialCenter: viewModel.mapCenter,
        initialZoom: viewModel.mapZoom,
        onTap: (_, __) => viewModel.clearSelectedLocation(),
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'putevod',
        ),
        MarkerLayer(
          markers: _buildMarkers(viewModel),
        ),
      ],
    );
  }

  List<Marker> _buildMarkers(TripMapViewModel viewModel) {
    final List<Marker> markers = [];
    
    // Add markers for the selected day only
    for (final location in viewModel.locationsForSelectedDay) {
      final isSelected = viewModel.selectedLocation?.id == location.id;
      
      markers.add(
        Marker(
          point: location.coordinates,
          child: GestureDetector(
            onTap: () => viewModel.selectLocation(location),
            child: Container(
              decoration: BoxDecoration(
                color: isSelected ? viewModel.selectedDay?.color : Colors.white,
                shape: BoxShape.circle,
                border: Border.all(
                  color: viewModel.selectedDay?.color ?? AppColors.accent,
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 6,
                    spreadRadius: 1,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              width: 24,
              height: 24,
              alignment: Alignment.center,
              child: Text(
                '${location.orderInDay}',
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ),
        ),
      );
    }
    
    return markers;
  }

  Widget _buildHeader(BuildContext context, String title) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        height: 56,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 2,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context),
              ),
              Expanded(
                child: Center(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontFamily: 'NotoSans',
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              // IconButton(
              //   icon: const Icon(Icons.more_vert),
              //   onPressed: () {
              //     // Show more options menu
              //   },
              // ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDaySelector(BuildContext context, TripMapViewModel viewModel) {
    // Calculate container width based on number of days
    final days = viewModel.days;
    final double containerWidth = days.length <= 3 
        ? 243.5 
        : days.length * 80.0; // Adjust width based on number of days
    
    return Positioned(
      top: 72,
      left: 16,
      child: Container(
        width: containerWidth,
        height: 44,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 15,
              offset: const Offset(0, 10),
            ),
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 6,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: days.map((day) => _buildDayTab(day, viewModel)).toList(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDayTab(TripDay day, TripMapViewModel viewModel) {
    final isSelected = viewModel.selectedDayNumber == day.dayNumber;
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: GestureDetector(
        onTap: () => viewModel.selectDay(day.dayNumber),
        child: Container(
          width: 70.5,
          height: 28,
          decoration: BoxDecoration(
            color: isSelected ? day.color : Colors.grey.shade200,
            borderRadius: BorderRadius.circular(9999),
          ),
          alignment: Alignment.center,
          child: Text(
            day.name,
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'NotoSans',
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMapControls(BuildContext context, TripMapViewModel viewModel) {
    return Positioned(
      right: 16,
      bottom: 400,
      child: Column(
        children: [
          _buildMapControlButton(
            icon: Icons.add,
            onPressed: () => viewModel.setMapZoom(viewModel.mapZoom + 1),
          ),
          const SizedBox(height: 8),
          _buildMapControlButton(
            icon: Icons.remove,
            onPressed: () => viewModel.setMapZoom(viewModel.mapZoom - 1),
          ),
          // const SizedBox(height: 8),
          // _buildMapControlButton(
          //   icon: Icons.location_on,
          //   onPressed: () {
          //     // Center map on selected location or default center
          //     // Implementation would go here
          //   },
          //   color: AppColors.accent,
          // ),
        ],
      ),
    );
  }

  Widget _buildMapControlButton({
    required IconData icon,
    required VoidCallback onPressed,
    Color? color,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 10),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      width: 40,
      height: 40,
      child: IconButton(
        icon: Icon(icon, color: color ?? Colors.black),
        onPressed: onPressed,
        padding: EdgeInsets.zero,
      ),
    );
  }

  Widget _buildLocationDetails(BuildContext context, TripMapViewModel viewModel) {
    final location = viewModel.selectedLocation!;
    
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 15,
              offset: const Offset(0, 10),
            ),
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 6,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    location.name,
                    style: const TextStyle(
                      fontFamily: 'NotoSans',
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: viewModel.selectedDay?.color ?? AppColors.accent,
                    shape: BoxShape.circle,
                  ),
                  width: 24,
                  height: 24,
                  alignment: Alignment.center,
                  child: Text(
                    '${location.orderInDay}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Icon(
                  Icons.access_time,
                  size: 16,
                  color: AppColors.darkGrey,
                ),
                const SizedBox(width: 8),
                Text(
                  location.timeRange,
                  style: TextStyle(
                    fontFamily: 'NotoSans',
                    fontSize: 14,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildActionButton(
                    label: 'Перейти к событию',
                    icon: Icons.navigation,
                    color: viewModel.selectedDay?.color ?? AppColors.accent,
                    textColor: Colors.white,
                    onPressed: () => viewModel.navigateToLocation(location),
                  ),
                ),
                // const SizedBox(width: 16),
                // Expanded(
                //   child: _buildActionButton(
                //     label: 'Напоминание',
                //     icon: Icons.notifications_none,
                //     color: Colors.white,
                //     textColor: Colors.black,
                //     borderColor: Colors.black,
                //     onPressed: () => viewModel.setReminder(location),
                //   ),
                // ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required String label,
    required IconData icon,
    required Color color,
    required Color textColor,
    Color? borderColor,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      height: 64,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: borderColor != null 
                ? BorderSide(color: borderColor)
                : BorderSide.none,
          ),
          padding: EdgeInsets.zero,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: textColor,
            ),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                label,
                style: TextStyle(
                  fontFamily: 'NotoSans',
                  color: textColor,
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
} 