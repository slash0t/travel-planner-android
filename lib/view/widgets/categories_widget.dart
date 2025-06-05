import 'package:flutter/material.dart';
import 'package:putevod/model/app_colors.dart';
import 'package:putevod/model/trip_category.dart';

/// A widget to display and select trip categories
class CategoriesWidget extends StatelessWidget {
  /// List of available categories
  final List<TripCategory> categories;
  
  /// Callback when a category is selected
  final Function(String) onCategorySelected;

  /// Creates a categories widget
  const CategoriesWidget({
    super.key,
    required this.categories,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: categories.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final category = categories[index];
          return _buildCategoryChip(category);
        },
      ),
    );
  }

  Widget _buildCategoryChip(TripCategory category) {
    return InkWell(
      onTap: () => onCategorySelected(category.id),
      borderRadius: BorderRadius.circular(9999),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: category.isSelected ? AppColors.accent : Colors.white,
          borderRadius: BorderRadius.circular(9999),
        ),
        child: Text(
          category.name,
          style: TextStyle(
            fontSize: 14,
            fontFamily: 'NotoSans',
            color: category.isSelected ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }
} 