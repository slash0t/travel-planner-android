import 'package:flutter/material.dart';
import 'package:putevod/model/app_colors.dart';
import 'package:putevod/model/trip_item.dart';

/// A card widget to display a trip in the search results
class TripCardWidget extends StatelessWidget {
  /// The trip item to display
  final TripItem trip;
  
  /// Callback when the copy trip button is pressed
  final Function(String) onCopyTrip;

  /// Creates a trip card widget
  const TripCardWidget({
    super.key,
    required this.trip,
    required this.onCopyTrip,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: const Offset(0, 1),
            blurRadius: 2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTripImage(),
          _buildTripInfo(),
        ],
      ),
    );
  }

  Widget _buildTripImage() {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(12),
            topRight: Radius.circular(12),
          ),
          child: Image.asset(
            trip.imageUrl,
            height: 192,
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                height: 192,
                width: double.infinity,
                color: Colors.grey[300],
                child: const Icon(Icons.image_not_supported, size: 40),
              );
            },
          ),
        ),
        Positioned(
          top: 12,
          right: 12,
          child: InkWell(
            onTap: () => onCopyTrip(trip.id),
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.download,
                color: AppColors.accent,
                size: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTripInfo() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            trip.title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              fontFamily: 'NotoSans',
              color: AppColors.text,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            trip.description,
            style: TextStyle(
              fontSize: 14,
              fontFamily: 'NotoSans',
              color: AppColors.text.withOpacity(0.8),
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(
                Icons.star,
                color: AppColors.secondary,
                size: 16,
              ),
              const SizedBox(width: 4),
              Text(
                trip.rating.toString(),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'NotoSans',
                ),
              ),
              const SizedBox(width: 4),
              Text(
                '(${trip.reviewCount})',
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: 'NotoSans',
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
} 