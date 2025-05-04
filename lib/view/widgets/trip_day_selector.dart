import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:putevod/model/app_colors.dart';

/// Widget for selecting days of a trip
class TripDaySelector extends StatelessWidget {
  /// List of days to display
  final List<DateTime> days;
  
  /// Currently selected day
  final DateTime selectedDay;
  
  /// Callback when a day is selected
  final Function(DateTime) onDaySelected;
  
  /// Creates a trip day selector widget
  const TripDaySelector({
    super.key,
    required this.days,
    required this.selectedDay,
    required this.onDaySelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 94,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: days.length,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemBuilder: (context, index) {
            final day = days[index];
            final isSelected = _isSameDay(day, selectedDay);
            
            return _buildDayItem(context, day, isSelected);
          },
        ),
      ),
    );
  }
  
  /// Builds a single day item
  Widget _buildDayItem(BuildContext context, DateTime day, bool isSelected) {
    final dayNumber = day.day.toString();
    final weekday = _getWeekdayShort(day);
    
    final Color circleColor = isSelected ? AppColors.accent : Color(0xFFF5F6F8);
    final Color dayTextColor = isSelected ? Colors.white : Colors.black;
    final Color weekdayTextColor = isSelected 
        ? AppColors.accent 
        : Color(0xFF6B7280);
    
    return GestureDetector(
      onTap: () => onDaySelected(day),
      child: Container(
        width: 40,
        margin: const EdgeInsets.only(right: 12),
        child: Column(
          children: [
            // Circle with day number
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: circleColor,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  dayNumber,
                  style: TextStyle(
                    fontFamily: 'Noto Sans',
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: dayTextColor,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 5),
            // Weekday
            Text(
              weekday,
              style: TextStyle(
                fontFamily: 'Noto Sans',
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: weekdayTextColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  /// Gets the short weekday name (Mon, Tue, etc.) in Russian
  String _getWeekdayShort(DateTime date) {
    final weekdays = ['ПН', 'ВТ', 'СР', 'ЧТ', 'ПТ', 'СБ', 'ВС'];
    // In Dart, DateTime.weekday is 1 for Monday, 7 for Sunday
    return weekdays[date.weekday - 1];
  }
  
  /// Helper to check if two dates are the same day
  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
} 