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
    _initializeTrip();
  }

  Future<void> _initializeTrip() async {
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

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.network(
                    widget.trip.imageUrl,
                    width: double.infinity,
                    height: 200,
                    fit: BoxFit.cover,
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
                            _buildTripHeader(),
                            const SizedBox(height: 24),
                            _buildAuthorSection(),
                            const SizedBox(height: 24),
                            _buildStatsSection(),
                            const SizedBox(height: 24),
                            _buildDailyPlanSection(),
                            const SizedBox(height: 24),
                            //_buildRouteMapSection(),
                            //const SizedBox(height: 24),
                            _buildReviewsSection(),
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

  Widget _buildTripHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.trip.tripName,
          style: const TextStyle(
            fontFamily: "NotoSans",
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF000000),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          widget.trip.tripDescription,
          style: const TextStyle(
            fontFamily: "NotoSans",
            fontSize: 14,
            color: Color(0xFF4B5563),
          ),
        ),
      ],
    );
  }

  Widget _buildAuthorSection() {
    return Row(
      children: [
        const CircleAvatar(
          radius: 24,
          backgroundImage: AssetImage('assets/images/profile_avatar.png'),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.trip.authorName,
              style: const TextStyle(
                fontFamily: "NotoSans",
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF000000),
              ),
            ),
            Text(
              widget.trip.authorTitle,
              style: const TextStyle(
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

  Widget _buildStatsSection() {
    return Column(
      children: [
        Row(
          spacing: 16,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildStatItem(Icons.access_time, "Длительность", widget.trip.duration.toString(), AppColors.red),
            _buildStatItem(Icons.location_city, "Города", widget.trip.citiesCount.toString(), AppColors.red),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          spacing: 16,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildStatItem(Icons.place, "Места", widget.trip.placesCount.toString(), AppColors.red),
            _buildStatItem(Icons.star, "Рейтинг", widget.trip.rating.toString(), AppColors.yellow),
          ],
        ),
      ],
    );
  }

  Widget _buildStatItem(IconData icon, String title, String value, Color iconColor) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
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

  Widget _buildDailyPlanSection() {
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
        ...widget.trip.dailyPlans.map((plan) => _buildDailyPlanItem(plan)),
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
          // Icon(Icons.chevron_right, color: AppColors.darkGrey),
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

  Widget _buildReviewsSection() {
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
            // Text(
            //   "Все (${widget.trip.reviews.length})",
            //   style: TextStyle(
            //     fontFamily: "NotoSans",
            //     fontSize: 14,
            //     color: AppColors.red,
            //     fontWeight: FontWeight.bold,
            //   ),
            // ),
          ],
        ),
        const SizedBox(height: 16),
        ...widget.trip.reviews.map((review) => _buildReviewItem(review)),
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
                backgroundImage: const AssetImage('assets/images/profile_avatar.png'),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    review.reviewerName,
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
            review.reviewText,
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