import 'package:flutter/material.dart';
import 'package:putevod/model/app_colors.dart';
import 'package:putevod/model/trip_event.dart';

/// Widget that displays a trip event item
class TripEventItem extends StatelessWidget {
  /// The event to display
  final TripEvent event;
  
  /// Creates a trip event item widget
  const TripEventItem({
    super.key,
    required this.event,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: const Offset(0, 1),
            blurRadius: 2,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Row(
        children: [
          // Red circle timeline indicator
          Container(
            width: 40,
            child: _buildTimelineIndicator(),
          ),
          // Event content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Time
                  _buildEventTimeInfo(),
                  // Title
                  Text(
                    event.title,
                    style: const TextStyle(
                      fontFamily: 'NotoSans',
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: AppColors.text,
                    ),
                  ),
                  _buildPlaceInfo(),
                ],
              ),
            ),
          ),
          // Arrow icon
          Padding(
            padding: const EdgeInsets.all(16),
            child: ReorderableDragStartListener(
              index: 0,
              child: Icon(
                Icons.drag_indicator,
                color: Colors.grey[400],
                size: 32,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildPlaceInfo() {
    if (event.place == null) return const SizedBox(height: 1);

    return Column(
      children: [
        const SizedBox(height: 10),
        // Address
        Text(
          event.place!.address!,
          style: const TextStyle(
            fontFamily: 'NotoSans',
            fontSize: 14,
            color: Color(0xFF4B5562),
          ),
        ),
      ],
    );
  }

  Widget _buildEventTimeInfo() {
    if (!event.hasSpecificTime) return const SizedBox(height: 1);

    return Column(
      children: [
        Text(
          event.formatTime,
          style: const TextStyle(
            fontFamily: 'NotoSans',
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: AppColors.accent,
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget _buildTimelineIndicator() {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Circle
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: AppColors.accent,
            shape: BoxShape.circle,
            border: Border.all(
              color: AppColors.background,
              width: 4,
            ),
          ),
        ),
      ],
    );
  }
} 