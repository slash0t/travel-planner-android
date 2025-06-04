import 'package:flutter/material.dart';

/// Represents a notification in the application
class AppNotification {
  /// Unique identifier for the notification
  final String id;
  
  /// User ID this notification belongs to
  final int userId;
  
  /// Type of notification
  final String type;
  
  /// Content/message of the notification
  final String content;
  
  /// Related entity ID (optional)
  final int? relatedId;
  
  /// Whether the notification has been read
  final bool isRead;
  
  /// Time when the notification was created
  final DateTime createdAt;
  
  /// Title of the notification (derived from type and content)
  final String title;
  
  /// Message content of the notification (same as content)
  final String message;
  
  /// Optional icon to display with the notification
  final IconData? icon;
  
  /// Optional action to perform when the notification is tapped
  final VoidCallback? onTap;
  
  /// Invitation status for trip invitations (pending, accepted, declined, expired)
  final String? invitationStatus;
  
  /// Creates a notification instance
  const AppNotification({
    required this.id,
    required this.userId,
    required this.type,
    required this.content,
    this.relatedId,
    required this.isRead,
    required this.createdAt,
    required this.title,
    required this.message,
    this.icon,
    this.onTap,
    this.invitationStatus,
  });
  
  /// Create notification from backend API response
  factory AppNotification.fromJson(Map<String, dynamic> json) {
    final type = json['type'] as String;
    final content = json['content'] as String;
    
    return AppNotification(
      id: json['id'].toString(),
      userId: json['userId'] as int,
      type: type,
      content: content,
      relatedId: json['relatedId'] as int?,
      isRead: json['read'] as bool,
      createdAt: DateTime.parse(json['createdAt'] as String),
      title: _getTitleFromType(type),
      message: content,
      icon: _getIconFromType(type),
      invitationStatus: json['invitationStatus'] as String?,
    );
  }
  
  /// Convert to JSON for API requests
  Map<String, dynamic> toJson() {
    return {
      'id': int.tryParse(id) ?? 0,
      'userId': userId,
      'type': type,
      'content': content,
      'relatedId': relatedId,
      'read': isRead,
      'createdAt': createdAt.toIso8601String(),
      'invitationStatus': invitationStatus,
    };
  }
  
  /// Get appropriate title based on notification type
  static String _getTitleFromType(String type) {
    switch (type.toLowerCase()) {
      case 'trip_invitation':
        return 'Приглашение в поездку';
      case 'trip_update':
        return 'Обновление поездки';
      case 'trip_reminder':
        return 'Напоминание о поездке';
      case 'event_reminder':
        return 'Напоминание о событии';
      case 'todo_reminder':
        return 'Напоминание о задаче';
      case 'system':
        return 'Системное уведомление';
      default:
        return 'Уведомление';
    }
  }
  
  /// Get appropriate icon based on notification type
  static IconData _getIconFromType(String type) {
    switch (type.toLowerCase()) {
      case 'trip_invitation':
        return Icons.card_travel;
      case 'trip_update':
        return Icons.update;
      case 'trip_reminder':
        return Icons.schedule;
      case 'event_reminder':
        return Icons.event;
      case 'todo_reminder':
        return Icons.task_alt;
      case 'system':
        return Icons.info;
      default:
        return Icons.notifications;
    }
  }
  
  /// Whether this is a trip invitation notification
  bool get isTripInvitation => type.toLowerCase() == 'trip_invitation';
  
  /// Whether this trip invitation is still pending
  bool get isInvitationPending => isTripInvitation && 
      (invitationStatus == null || invitationStatus == 'pending');
  
  /// Whether this trip invitation has been responded to
  bool get isInvitationResponded => isTripInvitation && 
      (invitationStatus == 'accepted' || invitationStatus == 'declined');
  
  /// Whether this trip invitation has expired
  bool get isInvitationExpired => isTripInvitation && invitationStatus == 'expired';
  
  /// Whether this notification should show invitation response buttons
  bool get shouldShowInvitationButtons => isTripInvitation && 
      isInvitationPending && 
      relatedId != null &&
      content.contains('пригласил вас к поездке');
  
  /// Creates a copy of this notification with the given fields replaced with new values
  AppNotification copyWith({
    String? id,
    int? userId,
    String? type,
    String? content,
    int? relatedId,
    bool? isRead,
    DateTime? createdAt,
    String? title,
    String? message,
    IconData? icon,
    VoidCallback? onTap,
    String? invitationStatus,
  }) {
    return AppNotification(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      type: type ?? this.type,
      content: content ?? this.content,
      relatedId: relatedId ?? this.relatedId,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt ?? this.createdAt,
      title: title ?? this.title,
      message: message ?? this.message,
      icon: icon ?? this.icon,
      onTap: onTap ?? this.onTap,
      invitationStatus: invitationStatus ?? this.invitationStatus,
    );
  }
  
  /// Mark this notification as read
  AppNotification markAsRead() {
    return copyWith(isRead: true);
  }
  
  /// Update invitation status
  AppNotification updateInvitationStatus(String status) {
    return copyWith(invitationStatus: status);
  }
} 