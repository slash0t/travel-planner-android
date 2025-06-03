import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:putevod/model/app_colors.dart';
import 'package:putevod/model/trip.dart';
import 'package:putevod/view-model/trip_detail_view_model.dart';
import 'package:putevod/view/screens/place_editing_screen.dart';
import 'package:putevod/view/screens/trip_creation_screen.dart';
import 'package:putevod/view/screens/trip_map_screen.dart';
import 'package:putevod/view/widgets/trip_day_selector.dart';
import 'package:putevod/view/widgets/trip_event_item.dart';
import 'package:putevod/view/screens/trip_sharing_screen.dart';
import 'package:putevod/view/screens/trip_publishing_screen.dart';

/// Screen for viewing trip details and itinerary
class TripDetailScreen extends StatefulWidget {
  /// The ID of the trip to display
  final int tripId;
  
  /// Creates a trip detail screen
  const TripDetailScreen({
    super.key,
    required this.tripId,
  });

  @override
  State<TripDetailScreen> createState() => _TripDetailScreenState();
}

class _TripDetailScreenState extends State<TripDetailScreen> {
  late TripDetailViewModel _viewModel;
  
  @override
  void initState() {
    super.initState();
    _viewModel = Provider.of<TripDetailViewModel>(context, listen: false);
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadTripDetail();
    });
  }
  
  Future<void> _loadTripDetail() async {
    await _viewModel.loadTripDetail(widget.tripId);
    await _viewModel.getEventsForSelectedDay();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Consumer<TripDetailViewModel>(
          builder: (context, viewModel, _) {
            if (viewModel.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            
            if (viewModel.trip == null) {
              return const Center(child: Text('Trip not found'));
            }
            
            final trip = viewModel.trip!;
            
            return Stack(
              children: [
                Column(
                  children: [
                    _buildHeader(trip.title, trip.startDate, trip.endDate),
                    if (trip.days.isNotEmpty && viewModel.selectedDay != null) ...[
                      TripDaySelector(
                        days: trip.days,
                        selectedDay: viewModel.selectedDay!,
                        onDaySelected: viewModel.selectDay,
                      ),
                      Expanded(
                        child: _buildEventsList(viewModel),
                      ),
                      _buildMapButton(viewModel),
                    ],
                  ],
                ),
                Positioned(
                  right: 16,
                  bottom: 80,
                  child: _buildCreateEventButton(),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
  
  Widget _buildHeader(String tripName, DateTime startDate, DateTime endDate) {
    final dateFormat = DateFormat('d MMMM yyyy', 'ru');
    final dateRange = '${dateFormat.format(startDate)} - ${dateFormat.format(endDate)}';
    
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Icon(Icons.arrow_back, size: 20),
              ),
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert, size: 20),
                onSelected: (value) {
                  if (value == 'edit') {
                    _showEditTripScreen();
                  } else if (value == 'delete') {
                    _showDeleteConfirmationDialog();
                  } else if (value == 'share') {
                    _showShareTripScreen();
                  } else if (value == 'publish') {
                    _showPublishTripScreen();
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'edit',
                    child: Row(
                      children: [
                        Icon(Icons.edit_outlined, size: 20),
                        SizedBox(width: 8),
                        Text('Редактировать'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'share',
                    child: Row(
                      children: [
                        Icon(Icons.share, size: 20),
                        SizedBox(width: 8),
                        Text('Поделиться'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'publish',
                    child: Row(
                      children: [
                        Icon(Icons.publish, size: 20),
                        SizedBox(width: 8),
                        Text('Опубликовать'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete_outline, size: 20, color: AppColors.accent),
                        SizedBox(width: 8),
                        Text('Удалить', style: TextStyle(color: AppColors.accent)),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            tripName,
            style: const TextStyle(
              fontFamily: 'NotoSans',
              fontSize: 24,
              fontWeight: FontWeight.w500,
              color: AppColors.text,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            dateRange,
            style: const TextStyle(
              fontFamily: 'NotoSans',
              fontSize: 16,
              color: Color(0xFF4B5562),
            ),
          ),
        ],
      ),
    );
  }

  void _showEditTripScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TripCreationScreen(
        tripToEdit: _viewModel.trip,
      )),
    );
  }

  void _showShareTripScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TripSharingScreen(
          trip: _viewModel.trip!,
        ),
      ),
    );
  }

  void _showPublishTripScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const TripPublishingScreen(),
      ),
    );
  }

  void _showDeleteConfirmationDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Удалить поездку?'),
        content: const Text('Это действие нельзя отменить.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Отмена'),
          ),
          TextButton(
            onPressed: () async {
              await _viewModel.deleteCurrentTrip();
              Navigator.pop(context);
              Navigator.pop(context); // Return to previous screen after deletion
            },
            child: const Text('Удалить'),
          ),
        ],
      ),
    );
  }
  
  Widget _buildEventsList(TripDetailViewModel viewModel) {
    if (viewModel.selectedEvents == null || viewModel.selectedEvents!.isEmpty) {
      return const Center(
        child: Text(
          'Нет событий на этот день',
          style: TextStyle(
            fontFamily: 'NotoSans',
            fontSize: 16,
            color: Color(0xFF6B7280),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: ReorderableListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: viewModel.selectedEvents!.length,
        onReorder: viewModel.reorderEvents,
        proxyDecorator: (child, index, animation) {
          return AnimatedBuilder(
            animation: animation,
            builder: (BuildContext context, Widget? child) {
              return Material(
                elevation: 0,
                color: Colors.transparent,
                child: child,
              );
            },
            child: child,
          );
        },
        itemBuilder: (context, index) {
          final event = viewModel.selectedEvents![index];
          return Dismissible(
            key: Key(event.id.toString()),
            background: Container(
              color: AppColors.accent,
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 20),
              child: const Icon(Icons.delete, color: Colors.white),
            ),
            direction: DismissDirection.endToStart,
            onDismissed: (_) async {
              await viewModel.deleteEvent(event.id);
              await _loadTripDetail();
            },
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PlaceEditingScreen.update(
                      placeId: event.id,
                      tripId: viewModel.trip!.id,
                      dayId: viewModel.selectedDay!.id,
                    ),
                  ),
                );
              },
              child: TripEventItem(event: event),
            ),
          );
        },
      ),
    );
  }
  
  Widget _buildMapButton(TripDetailViewModel viewModel) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      child: ElevatedButton(
        onPressed: () async {
          final day = await viewModel.getCurrentDay();
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TripMapScreen(day: day),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.accent,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        child: const Text(
          'Открыть на карте',
          style: TextStyle(
            fontFamily: 'NotoSans',
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
  
  Widget _buildCreateEventButton() {
    return Consumer<TripDetailViewModel>(
      builder: (context, viewModel, _) {
        // Don't show the button if no trip or day is selected
        if (viewModel.trip == null || viewModel.selectedDay == null) {
          return const SizedBox.shrink();
        }
        
        return FloatingActionButton.extended(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PlaceEditingScreen.create(
                  tripId: viewModel.trip!.id,
                  dayId: viewModel.selectedDay!.id,
                ),
              ),
            );
          },
          backgroundColor: AppColors.secondary,
          label: const Row(
            children: [
              Icon(Icons.add, color: AppColors.text),
              SizedBox(width: 8),
              Text(
                'Создать',
                style: TextStyle(
                  fontFamily: 'NotoSans',
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: AppColors.text,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
} 