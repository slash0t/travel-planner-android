import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:putevod/model/app_colors.dart';
import 'package:putevod/model/library_trip.dart';
import 'package:putevod/view-model/library_trip_view_model.dart';
// We'll need to create this model later
// import 'package:putevod/model/trip_model.dart'; 

class TripDetailsScreen extends StatefulWidget {
  final LibraryTrip trip;

  const TripDetailsScreen({
    super.key,
    required this.trip,
  });

  @override
  State<TripDetailsScreen> createState() => _TripDetailsScreenState();
}

class _TripDetailsScreenState extends State<TripDetailsScreen> {
  late final LibraryTripViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = LibraryTripViewModel();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeTrip();
    });
  }

  Future<void> _initializeTrip() async {
    _viewModel.setTrip(widget.trip);
    await _viewModel.loadTripDetails();
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _viewModel,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.white,
          elevation: 1,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: AppColors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(
            "Детали поездки",
            style: TextStyle(
              fontFamily: "NotoSans",
              color: AppColors.black,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          // actions: [
          //   IconButton(
          //     icon: Icon(Icons.more_vert, color: AppColors.black),
          //     onPressed: () {
          //       // Handle more options
          //     },
          //   ),
          // ],
        ),
        body: Consumer<LibraryTripViewModel>(
          builder: (context, viewModel, child) {
            if (viewModel.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (viewModel.error != null) {
              return Center(child: Text(viewModel.error!));
            }
            // Use either the viewModel trip or widget.trip as fallback
            final trip = viewModel.trip ?? widget.trip;

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.network(
                    trip.previewImageUrl,
                    width: double.infinity,
                    height: 200,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 200,
                        width: double.infinity,
                        color: Colors.grey[300],
                        child: const Icon(Icons.image_not_supported, size: 48),
                      );
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Card(
                      elevation: 2,
                      shadowColor: Colors.black.withOpacity(0.05),
                      color: AppColors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildTripHeader(trip),
                            const SizedBox(height: 24),
                            _buildAuthorSection(trip.author),
                            const SizedBox(height: 24),
                            _buildStatsSection(trip),
                            const SizedBox(height: 24),
                            _buildDailyPlanSection(viewModel.dailyPlans ?? []),
                            const SizedBox(height: 24),
                            _buildReviewsSection(trip.reviewsCount, viewModel.reviews ?? []),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        bottomNavigationBar: _buildBottomBar(),
      ),
    );
  }

  Widget _buildTripHeader(LibraryTrip trip) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          trip.title,
          style: const TextStyle(
            fontFamily: "NotoSans",
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF000000),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          trip.description,
          style: const TextStyle(
            fontFamily: "NotoSans",
            fontSize: 14,
            color: Color(0xFF4B5563),
          ),
        ),
      ],
    );
  }

  Widget _buildAuthorSection(Author author) {
    return Row(
      children: [
        CircleAvatar(
          radius: 24,
          backgroundColor: AppColors.red.withOpacity(0.2),
          child: Text(
            author.username.isNotEmpty ? author.username[0].toUpperCase() : '?',
            style: TextStyle(
              fontFamily: "NotoSans",
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.red,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              author.username,
              style: const TextStyle(
                fontFamily: "NotoSans",
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF000000),
              ),
            ),
            const Text(
              "Путешественник",
              style: TextStyle(
                fontFamily: "NotoSans",
                fontSize: 12,
                color: Color(0xFF6B7280),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatsSection(LibraryTrip trip) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildStatItem(Icons.access_time, "Длительность", "${trip.duration} дней", AppColors.red),
            _buildStatItem(Icons.location_city, "Города", trip.cities.length.toString(), AppColors.red),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildStatItem(Icons.public, "Страны", trip.countries.length.toString(), AppColors.red),
            _buildStatItem(Icons.star, "Рейтинг", trip.rating.toString(), AppColors.yellow),
          ],
        ),
      ],
    );
  }

  Widget _buildStatItem(IconData icon, String title, String value, Color iconColor) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: AppColors.grey,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 16, color: iconColor),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontFamily: "NotoSans",
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF000000),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontFamily: "NotoSans",
                fontSize: 14,
                color: Color(0xFF000000),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDailyPlanSection(List<DailyPlan> dailyPlans) {
    if (dailyPlans.isEmpty) {
      return const Center(
        child: Text(
          "Нет плана по дням",
          style: TextStyle(
            fontFamily: "NotoSans",
            fontSize: 16,
            color: Color(0xFF6B7280),
          ),
        ),
      );
    }
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "План по дням",
          style: TextStyle(
            fontFamily: "NotoSans",
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF000000),
          ),
        ),
        const SizedBox(height: 16),
        ...dailyPlans.map((plan) => _buildDailyPlanItem(plan)),
      ],
    );
  }

  Widget _buildDailyPlanItem(DailyPlan plan) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.grey,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.red,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                plan.day.toString(),
                style: TextStyle(
                  fontFamily: "NotoSans",
                  fontSize: 16,
                  color: AppColors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  plan.city,
                  style: const TextStyle(
                    fontFamily: "NotoSans",
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF000000),
                  ),
                ),
                Text(
                  plan.details,
                  style: const TextStyle(
                    fontFamily: "NotoSans",
                    fontSize: 12,
                    color: Color(0xFF6B7280),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRouteMapSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Карта маршрута",
          style: TextStyle(
            fontFamily: "NotoSans",
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF000000),
          ),
        ),
        const SizedBox(height: 16),
        Container(
          height: 200,
          decoration: BoxDecoration(
            color: AppColors.divider,
            borderRadius: BorderRadius.circular(8),
            image: const DecorationImage(
              image: NetworkImage("https://via.placeholder.com/326x200/E0E0E0/000000?Text=Map+Placeholder"),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildReviewsSection(int reviewsCount, List<TripReview> reviews) {
    if (reviews.isEmpty) {
      return const Center(
        child: Text(
          "Нет отзывов",
          style: TextStyle(
            fontFamily: "NotoSans",
            fontSize: 16,
            color: Color(0xFF6B7280),
          ),
        ),
      );
    }
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Отзывы",
              style: TextStyle(
                fontFamily: "NotoSans",
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF000000),
              ),
            ),
            Text(
              "Всего: $reviewsCount",
              style: TextStyle(
                fontFamily: "NotoSans",
                fontSize: 14,
                color: AppColors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ...reviews.map((review) => _buildReviewItem(review)),
      ],
    );
  }

  Widget _buildReviewItem(TripReview review) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.grey,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: AppColors.yellow.withOpacity(0.2),
                child: Text(
                  review.author.username.isNotEmpty ? review.author.username[0].toUpperCase() : '?',
                  style: TextStyle(
                    fontFamily: "NotoSans",
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: AppColors.yellow,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    review.author.username,
                    style: const TextStyle(
                      fontFamily: "NotoSans",
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF000000),
                    ),
                  ),
                  Row(
                    children: List.generate(5, (index) {
                      return Icon(
                        index < review.rating ? Icons.star : Icons.star_border,
                        color: AppColors.yellow,
                        size: 16,
                      );
                    }),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            review.comment,
            style: const TextStyle(
              fontFamily: "NotoSans",
              fontSize: 14,
              color: Color(0xFF4B5563),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 17),
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            spreadRadius: 0,
            blurRadius: 2,
            offset: const Offset(0, -1),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.red,
                padding: const EdgeInsets.symmetric(vertical: 13),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                context.read<LibraryTripViewModel>().copyRoute();
              },
              child: Text(
                "Копировать маршрут",
                style: TextStyle(
                  fontFamily: "NotoSans",
                  fontSize: 16,
                  color: AppColors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          // const SizedBox(width: 12),
          // OutlinedButton(
          //   style: OutlinedButton.styleFrom(
          //     padding: const EdgeInsets.all(12),
          //     side: BorderSide(color: AppColors.divider),
          //     shape: RoundedRectangleBorder(
          //       borderRadius: BorderRadius.circular(8),
          //     ),
          //   ),
          //   onPressed: () {
          //     context.read<LibraryTripViewModel>().toggleFavorite();
          //   },
          //   child: Icon(Icons.favorite_border, color: AppColors.darkGrey, size: 24),
          // ),
        ],
      ),
    );
  }
} 