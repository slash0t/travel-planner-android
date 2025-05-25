import 'package:flutter/material.dart';
import 'package:putevod/model/app_colors.dart';
import 'package:putevod/model/trip.dart';
import 'package:putevod/view-model/trips_view_model.dart';

/// A card widget displaying trip information
class TripCard extends StatelessWidget {
  /// The trip to display
  final Trip trip;

  /// The trips view model
  final TripsViewModel viewModel;

  /// Function to call when the card is tapped
  final VoidCallback? onTap;

  /// Creates a trip card
  const TripCard({
    required this.trip,
    required this.viewModel,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
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
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        trip.name,
                        style: const TextStyle(
                          fontFamily: 'NotoSans',
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    trip.destination,
                    style: const TextStyle(
                      fontFamily: 'NotoSans',
                      fontSize: 16,
                      color: Color(0xFF4B5563),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    viewModel.getFormattedDateRange(trip),
                    style: const TextStyle(
                      fontFamily: 'NotoSans',
                      fontSize: 14,
                      color: Color(0xFF4B5563),
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildStatusChip(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImage() {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(12),
        topRight: Radius.circular(12),
      ),
      child: Stack(
        children: [
          Image.asset(
            trip.imageUrl!,
            height: 200,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          Positioned(
            top: 0,
            right: 0,
            child: _buildStatusChip(),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: viewModel.getStatusColor(trip.status),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            viewModel.getStatusText(trip.status),
            style: const TextStyle(
              fontFamily: 'NotoSans',
              fontSize: 14,
              color: Colors.black,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
} 