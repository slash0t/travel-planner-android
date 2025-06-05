import 'package:flutter/material.dart';

/// Represents a category for trip search
class TripCategory {
  /// Unique identifier for the category
  final String id;
  
  /// Display name of the category
  final String name;
  
  /// Whether the category is currently selected
  final bool isSelected;

  /// Creates a trip category
  const TripCategory({
    required this.id,
    required this.name,
    this.isSelected = false,
  });

  /// Creates a copy of this category with the given fields replaced
  TripCategory copyWith({
    String? id,
    String? name,
    bool? isSelected,
  }) {
    return TripCategory(
      id: id ?? this.id,
      name: name ?? this.name,
      isSelected: isSelected ?? this.isSelected,
    );
  }
} 