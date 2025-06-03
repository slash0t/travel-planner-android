import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:putevod/model/app_colors.dart';
import 'package:putevod/model/trip_day.dart';
import 'package:putevod/model/trip_event.dart';
import 'package:putevod/view-model/trip_map_view_model.dart';
import 'package:putevod/view/screens/place_editing_screen.dart';

/// Trip Map Screen displaying a single day's events on a map
class TripMapScreen extends StatelessWidget {
  /// The day to display on the map
  final TripDay day;

  /// Constructor for TripMapScreen
  const TripMapScreen({
    Key? key,
    required this.day,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TripMapViewModel(day: day),
      child: const _TripMapView(),
    );
  }
}

class _TripMapView extends StatelessWidget {
  const _TripMapView();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<TripMapViewModel>();

    return Scaffold(
      body: Stack(
        children: [
          // Map covering the entire screen
          _buildMap(viewModel),
          
          // Header with back button and day title
          _buildHeader(context, viewModel.day),
          
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
      mapController: viewModel.mapController,
      options: MapOptions(
        initialCenter: viewModel.mapCenter,
        initialZoom: viewModel.mapZoom,
        onTap: (_, __) => viewModel.clearSelectedLocation(),
        interactionOptions: const InteractionOptions(
          flags: InteractiveFlag.all & ~InteractiveFlag.rotate,
        ),
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
    
    // Add markers for all events with places
    for (final event in viewModel.events) {
      // Skip events without place or coordinates
      if (event.place == null || 
          event.place!.latitude == null || 
          event.place!.longitude == null) {
        continue;
      }
      
      final isSelected = viewModel.selectedLocation?.id == event.id;
      
      markers.add(
        Marker(
          point: event.place!.coordinates,
          child: GestureDetector(
            onTap: () => viewModel.selectLocation(event),
            child: Container(
              decoration: BoxDecoration(
                color: isSelected ? AppColors.accent : Colors.white,
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.accent ?? AppColors.accent,
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
                '${event.orderPosition}',
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

  Widget _buildHeader(BuildContext context, TripDay day) {
    final String formattedDate = _formatDate(day.date);
    
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
                    'День ${day.dayNumber}',
                    style: const TextStyle(
                      fontFamily: 'NotoSans',
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 48), // Balance for back button
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    // Format date as day.month
    return '${date.day}.${date.month}';
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
        ],
      ),
    );
  }

  Widget _buildMapControlButton({
    required IconData icon,
    required VoidCallback onPressed,
    Color? color,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(20),
        child: Ink(
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
          child: Center(
            child: Icon(
              icon,
              color: color ?? Colors.black,
              size: 24,
            ),
          ),
        ),
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
                    location.title,
                    style: const TextStyle(
                      fontFamily: 'NotoSans',
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.accent,
                    shape: BoxShape.circle,
                  ),
                  width: 24,
                  height: 24,
                  alignment: Alignment.center,
                  child: Text(
                    '${location.orderPosition}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (location.hasSpecificTime) ...[
              Row(
                children: [
                  Icon(
                    Icons.access_time,
                    size: 16,
                    color: AppColors.darkGrey,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    location.formatTime,
                    style: const TextStyle(
                      fontFamily: 'NotoSans',
                      fontSize: 14,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
            Row(
              children: [
                Expanded(
                  child: _buildActionButton(
                    label: 'Перейти к событию',
                    icon: Icons.navigation,
                    color: AppColors.accent,
                    textColor: Colors.white,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PlaceEditingScreen.update(
                            placeId: viewModel.selectedLocation!.id,
                            tripId: viewModel.day.tripId,
                            dayId: viewModel.day.id,
                          ),
                        ),
                      );
                    }
                  ),
                ),
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