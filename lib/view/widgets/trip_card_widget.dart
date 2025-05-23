import 'package:flutter/material.dart';
import 'package:putevod/model/app_colors.dart';
import 'package:putevod/model/trip_item.dart';
import 'package:putevod/model/library_trip.dart';
import 'package:putevod/view/screens/library_trip_detail_screen.dart';

/// A card widget to display a trip in the search results
class TripCardWidget extends StatelessWidget {
  /// The trip item to display
  final TripItem trip;
  
  /// Callback when the favorite button is pressed
  final Function(String) onFavoriteToggle;

  /// Creates a trip card widget
  const TripCardWidget({
    super.key,
    required this.trip,
    required this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _onClick(context),
      child: Container(
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
      ),
    );
  }

  void _onClick(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TripDetailsScreen(trip: new LibraryTrip(
          tripName: trip.title,
          tripDescription: trip.description,
          authorName: "Иван Иванов",
          authorTitle: "Путешественник",
          duration: 2,
          citiesCount: 1,
          placesCount: 10,
          rating: 4.6,
          imageUrl: trip.imageUrl,
          dailyPlans: [
            const DailyPlan(
              day: 1,
              city: "Воронеж",
              details: "Детали"
            ),
          ],
          reviews: [
            const TripReview(
              rating: 4,
              reviewerName: "Иван Иванов",
              reviewText: "Отличный маршрут! Все достопримечательности подобраны идеально.",
              avatarUrl: "https://via.placeholder.com/150"
            )
          ],
        )),
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
          child: Image(
            image: NetworkImage(trip.imageUrl),
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
        // Positioned(
        //   top: 12,
        //   right: 12,
        //   child: InkWell(
        //     child: Container(
        //       padding: const EdgeInsets.all(6),
        //       decoration: const BoxDecoration(
        //         color: Colors.white,
        //         shape: BoxShape.circle,
        //       ),
        //       child: Icon(
        //         trip.isFavorite ? Icons.favorite : Icons.favorite_border,
        //         color: AppColors.accent,
        //         size: 16,
        //       ),
        //     ),
        //   ),
        // ),
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