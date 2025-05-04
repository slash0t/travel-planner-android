import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:putevod/model/app_colors.dart';
import 'package:putevod/model/trip.dart';
import 'package:putevod/view-model/trip_creation_view_model.dart';
import 'package:putevod/view-model/trips_view_model.dart';
import 'package:putevod/view/screens/trip_detail_screen.dart';

/// Screen for creating or editing a trip
class TripCreationScreen extends StatefulWidget {
  /// Trip to edit, null if creating a new trip
  final Trip? tripToEdit;

  /// Creates a new trip creation screen instance
  const TripCreationScreen({Key? key, this.tripToEdit}) : super(key: key);

  @override
  State<TripCreationScreen> createState() => _TripCreationScreenState();
}

class _TripCreationScreenState extends State<TripCreationScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.tripToEdit != null) {
        context.read<TripCreationViewModel>().initForEditing(widget.tripToEdit!);
      } else {
        context.read<TripCreationViewModel>().initForCreation();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TripCreationViewModel>(
      builder: (context, viewModel, child) {
        return Scaffold(
          backgroundColor: AppColors.background,
          body: SafeArea(
            child: Column(
              children: [
                _buildHeader(viewModel),
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          _buildNameInput(viewModel),
                          const SizedBox(height: 14),
                          _buildStartDateInput(context, viewModel),
                          const SizedBox(height: 14),
                          _buildEndDateInput(context, viewModel),
                          const SizedBox(height: 14),
                          _buildCountryInput(viewModel),
                          const SizedBox(height: 14),
                          _buildCityInput(viewModel),
                          const SizedBox(height: 14),
                          _buildDescriptionInput(viewModel),
                          const SizedBox(height: 16),
                          _buildCreateButton(context, viewModel),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(TripCreationViewModel viewModel) {
    return Container(
      height: 52,
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
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          children: [
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: const Icon(Icons.arrow_back, color: Colors.black),
            ),
            const SizedBox(width: 12),
            Text(
              viewModel.isEditingMode ? 'Редактирование поездки' : 'Новая поездка',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNameInput(TripCreationViewModel viewModel) {
    return Container(
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
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Название поездки',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF4B555D),
            ),
          ),
          const SizedBox(height: 4),
          Container(
            height: 41,
            color: Colors.white,
            child: TextField(
              controller: viewModel.nameController,
              decoration: const InputDecoration(
                hintText: 'Название',
                hintStyle: TextStyle(
                  color: Color(0xFFADAFBC),
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 8),
              ),
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStartDateInput(BuildContext context, TripCreationViewModel viewModel) {
    final DateFormat formatter = DateFormat('dd.MM.yyyy');
    final String displayDate = viewModel.startDate != null
        ? formatter.format(viewModel.startDate!)
        : 'Выберите дату';

    return Container(
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
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Выбор дня начала поездки',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF4B555D),
            ),
          ),
          const SizedBox(height: 4),
          GestureDetector(
            onTap: () async {
              final pickedDate = await showDatePicker(
                context: context,
                initialDate: viewModel.startDate ?? DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
                builder: (BuildContext context, Widget? child) {
                  return Theme(
                    data: ThemeData.light().copyWith(
                      colorScheme: ColorScheme.light(
                        primary: AppColors.secondary,
                        onPrimary: Colors.black,
                        surface: Colors.white,
                      ),
                    ),
                    child: child!,
                  );
                },
              );
              
              if (pickedDate != null) {
                final endDate = viewModel.endDate;
                if (endDate != null && pickedDate.isAfter(endDate)) {
                  // If new start date is after current end date, update both
                  viewModel.setDateRange(pickedDate, pickedDate);
                } else {
                  // Otherwise, keep current end date
                  viewModel.setDateRange(pickedDate, endDate);
                }
              }
            },
            child: Container(
              height: 41,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: const Color(0xFFE5E7EB)),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              alignment: Alignment.centerLeft,
              child: Row(
                children: [
                  const Icon(Icons.calendar_today, size: 16, color: Colors.black),
                  const SizedBox(width: 8),
                  Text(
                    displayDate,
                    style: TextStyle(
                      fontSize: 16,
                      color: viewModel.startDate != null
                          ? Colors.black
                          : const Color(0xFFADAFBC),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEndDateInput(BuildContext context, TripCreationViewModel viewModel) {
    final DateFormat formatter = DateFormat('dd.MM.yyyy');
    final String displayDate = viewModel.endDate != null
        ? formatter.format(viewModel.endDate!)
        : 'Выберите дату';

    return Container(
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
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Выбор дня конца поездки',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF4B555D),
            ),
          ),
          const SizedBox(height: 4),
          GestureDetector(
            onTap: () async {
              // Can't pick end date if start date isn't set
              if (viewModel.startDate == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Сначала выберите дату начала поездки')),
                );
                return;
              }
              
              final pickedDate = await showDatePicker(
                context: context,
                initialDate: viewModel.endDate ?? viewModel.startDate!,
                firstDate: viewModel.startDate!, // End date must be after or equal to start date
                lastDate: DateTime(2100),
                builder: (BuildContext context, Widget? child) {
                  return Theme(
                    data: ThemeData.light().copyWith(
                      colorScheme: ColorScheme.light(
                        primary: AppColors.secondary,
                        onPrimary: Colors.black,
                        surface: Colors.white,
                      ),
                    ),
                    child: child!,
                  );
                },
              );
              
              if (pickedDate != null) {
                viewModel.setDateRange(viewModel.startDate!, pickedDate);
              }
            },
            child: Container(
              height: 41,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: const Color(0xFFE5E7EB)),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              alignment: Alignment.centerLeft,
              child: Row(
                children: [
                  const Icon(Icons.calendar_today, size: 16, color: Colors.black),
                  const SizedBox(width: 8),
                  Text(
                    displayDate,
                    style: TextStyle(
                      fontSize: 16,
                      color: viewModel.endDate != null
                          ? Colors.black
                          : const Color(0xFFADAFBC),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildCountryInput(TripCreationViewModel viewModel) {
    return Container(
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
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Введите страны поездки',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF4B555D),
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(Icons.public, size: 24, color: Colors.black),
              const SizedBox(width: 8),
              Expanded(
                child: Container(
                  height: 41,
                  color: Colors.white,
                  child: TextField(
                    controller: viewModel.countryController,
                    decoration: const InputDecoration(
                      hintText: 'Страна',
                      hintStyle: TextStyle(
                        color: Color(0xFFADAFBC),
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 8),
                    ),
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCityInput(TripCreationViewModel viewModel) {
    return Container(
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
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Введите города поездки',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF4B555D),
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(Icons.location_on_outlined, size: 24, color: Colors.black),
              const SizedBox(width: 8),
              Expanded(
                child: Container(
                  height: 41,
                  color: Colors.white,
                  child: TextField(
                    controller: viewModel.cityController,
                    decoration: const InputDecoration(
                      hintText: 'Город',
                      hintStyle: TextStyle(
                        color: Color(0xFFADAFBC),
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 8),
                    ),
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDescriptionInput(TripCreationViewModel viewModel) {
    return Container(
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
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Введите описание',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF4B555D),
            ),
          ),
          const SizedBox(height: 4),
          Container(
            color: Colors.white,
            child: TextField(
              controller: viewModel.descriptionController,
              decoration: const InputDecoration(
                hintText: 'Описание',
                hintStyle: TextStyle(
                  color: Color(0xFFADAFBC),
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 8),
              ),
              style: const TextStyle(
                fontSize: 16,
              ),
              maxLines: 3,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCreateButton(BuildContext context, TripCreationViewModel viewModel) {
    return GestureDetector(
      onTap: () async {
        if (viewModel.validateForm()) {
          try {
            final trip = await viewModel.saveTrip();
            
            // Add trip to TripsViewModel
            final tripsViewModel = context.read<TripsViewModel>();
            if (viewModel.isEditingMode) {
              tripsViewModel.updateTrip(trip);
            } else {
              tripsViewModel.addTrip(trip);
            }
            
            if (mounted) {
              // Navigate to trip detail screen instead of just popping
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => TripDetailScreen(tripId: trip.id),
                ),
              );
            }
          } catch (e) {
            // Show error message
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Ошибка: ${e.toString()}')),
            );
          }
        } else {
          // Show validation error
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Пожалуйста, заполните все обязательные поля')),
          );
        }
      },
      child: Container(
        height: 56,
        decoration: BoxDecoration(
          color: AppColors.accent,
          borderRadius: BorderRadius.circular(12),
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
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                viewModel.isEditingMode ? 'Сохранить поездку' : 'Создать поездку',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 8),
              const Icon(
                Icons.arrow_forward,
                color: Colors.white,
                size: 14,
              ),
            ],
          ),
        ),
      ),
    );
  }
} 