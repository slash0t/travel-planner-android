import 'package:flutter/material.dart';
import 'package:putevod/model/notification.dart';
import 'package:putevod/model/notification_service.dart';
import 'package:putevod/external/trip_invitation_service.dart';

/// ViewModel for the notifications screen
class NotificationsViewModel extends ChangeNotifier {
  /// Service that manages notifications
  final NotificationService _notificationService;
  
  /// Service for handling trip invitations
  final TripInvitationService _tripInvitationService = TripInvitationService();
  
  /// Loading state for initial load
  bool _isInitialLoading = true;
  
  /// Error message if any
  String? _errorMessage;
  
  /// Loading state for invitation responses
  final Set<String> _loadingInvitations = {};
  
  /// Constructor that takes a notification service
  NotificationsViewModel(this._notificationService) {
    _initializeNotifications();
  }
  
  /// Get all notifications
  List<AppNotification> get notifications => _notificationService.notifications;
  
  /// Get unread notifications count
  int get unreadCount => _notificationService.unreadCount;
  
  /// Whether there are any notifications
  bool get hasNotifications => notifications.isNotEmpty;
  
  /// Get loading state for initial load
  bool get isInitialLoading => _isInitialLoading;
  
  /// Get loading state for more data
  bool get isLoadingMore => _notificationService.isLoading && !_isInitialLoading;
  
  /// Get whether there are more notifications to load
  bool get hasMoreData => _notificationService.hasMoreData;
  
  /// Get error message
  String? get errorMessage => _errorMessage;
  
  /// Check if an invitation response is loading
  bool isInvitationLoading(String notificationId) => _loadingInvitations.contains(notificationId);
  
  /// Initialize notifications by loading from backend
  Future<void> _initializeNotifications() async {
    try {
      _isInitialLoading = true;
      _errorMessage = null;
      notifyListeners();
      
      // Get initial unread count
      await _notificationService.getUnreadCount();
      
      // Load notifications
      await _notificationService.loadNotifications(refresh: true);
      
    } catch (e) {
      _errorMessage = 'Ошибка загрузки уведомлений: $e';
    } finally {
      _isInitialLoading = false;
      notifyListeners();
    }
  }
  
  /// Refresh notifications
  Future<void> refresh() async {
    try {
      _errorMessage = null;
      await _notificationService.refresh();
    } catch (e) {
      _errorMessage = 'Ошибка обновления уведомлений: $e';
    } finally {
      notifyListeners();
    }
  }
  
  /// Load more notifications
  Future<void> loadMore() async {
    if (!hasMoreData || isLoadingMore) return;
    
    try {
      _errorMessage = null;
      await _notificationService.loadMore();
    } catch (e) {
      _errorMessage = 'Ошибка загрузки уведомлений: $e';
    } finally {
      notifyListeners();
    }
  }
  
  /// Mark a notification as read
  Future<void> markAsRead(String notificationId) async {
    try {
      await _notificationService.markAsRead(notificationId);
    } catch (e) {
      _errorMessage = 'Ошибка отметки уведомления как прочитанного: $e';
      notifyListeners();
    }
  }
  
  /// Mark all notifications as read
  Future<void> markAllAsRead() async {
    try {
      _errorMessage = null;
      await _notificationService.markAllAsRead();
    } catch (e) {
      _errorMessage = 'Ошибка отметки всех уведомлений как прочитанных: $e';
      notifyListeners();
    }
  }
  
  /// Accept a trip invitation
  Future<bool> acceptInvitation(String notificationId, int tripId) async {
    if (_loadingInvitations.contains(notificationId)) return false;
    
    _loadingInvitations.add(notificationId);
    notifyListeners();
    
    try {
      await _tripInvitationService.acceptInvitation(tripId);
      
      // Update notification status locally
      final notificationIndex = _notificationService.notifications
          .indexWhere((n) => n.id == notificationId);
      if (notificationIndex != -1) {
        final notification = _notificationService.notifications[notificationIndex];
        final updatedNotification = notification.updateInvitationStatus('accepted');
        _notificationService.notifications[notificationIndex] = updatedNotification;
      }
      
      // Mark notification as read
      await markAsRead(notificationId);
      
      return true;
    } catch (e) {
      _errorMessage = 'Ошибка принятия приглашения: $e';
      return false;
    } finally {
      _loadingInvitations.remove(notificationId);
      notifyListeners();
    }
  }
  
  /// Decline a trip invitation
  Future<bool> declineInvitation(String notificationId, int tripId) async {
    if (_loadingInvitations.contains(notificationId)) return false;
    
    _loadingInvitations.add(notificationId);
    notifyListeners();
    
    try {
      await _tripInvitationService.declineInvitation(tripId);
      
      // Update notification status locally
      final notificationIndex = _notificationService.notifications
          .indexWhere((n) => n.id == notificationId);
      if (notificationIndex != -1) {
        final notification = _notificationService.notifications[notificationIndex];
        final updatedNotification = notification.updateInvitationStatus('declined');
        _notificationService.notifications[notificationIndex] = updatedNotification;
      }
      
      // Mark notification as read
      await markAsRead(notificationId);
      
      return true;
    } catch (e) {
      _errorMessage = 'Ошибка отклонения приглашения: $e';
      return false;
    } finally {
      _loadingInvitations.remove(notificationId);
      notifyListeners();
    }
  }
  
  /// Remove a notification (local only)
  void removeNotification(String notificationId) {
    _notificationService.removeNotification(notificationId);
  }
  
  /// Clear all notifications (local only)
  void clearAll() {
    _notificationService.clearAll();
  }
  
  /// Add a sample notification (for testing)
  void addSampleNotification() {
    _notificationService.addSampleNotification();
  }
  
  /// Handle notification tap
  Future<void> handleNotificationTap(AppNotification notification) async {
    // Mark the notification as read when tapped
    if (!notification.isRead) {
      await markAsRead(notification.id);
    }
    
    // Execute the notification's onTap callback if it exists
    if (notification.onTap != null) {
      notification.onTap!();
    }
    
    // Handle navigation based on notification type and relatedId
    _handleNotificationNavigation(notification);
  }
  
  /// Handle navigation based on notification type
  void _handleNotificationNavigation(AppNotification notification) {
    // TODO: Implement navigation logic based on notification type and relatedId
    // For example:
    // switch (notification.type) {
    //   case 'trip_invitation':
    //     // Navigate to trip details screen
    //     break;
    //   case 'event_reminder':
    //     // Navigate to event details screen
    //     break;
    //   // ... other cases
    // }
  }
  
  /// Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
} 