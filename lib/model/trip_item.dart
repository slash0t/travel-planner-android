import 'package:flutter/material.dart';

/// Represents a trip item in the search results
class TripItem {
  /// Unique identifier for the trip
  final String id;
  
  /// Title of the trip
  final String title;
  
  /// Description of the trip
  final String description;
  
  /// Image URL for the trip
  final String imageUrl;
  
  /// Rating of the trip (0-5)
  final double rating;
  
  /// Number of reviews
  final int reviewCount;

  /// Creates a trip item
  const TripItem({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    this.rating = 0,
    this.reviewCount = 0,
  });

  /// Creates a copy of this item with the given fields replaced
  TripItem copyWith({
    String? id,
    String? title,
    String? description,
    String? imageUrl,
    double? rating,
    int? reviewCount,
  }) {
    return TripItem(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
    );
  }
} 