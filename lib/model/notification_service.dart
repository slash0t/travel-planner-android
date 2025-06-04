import 'package:flutter/material.dart';
import 'package:putevod/model/notification.dart';
import 'package:putevod/external/notifications_service.dart';

/// Service for managing notifications in the application
class NotificationService extends ChangeNotifier {
  final NotificationsService _notificationsApi = NotificationsService();
  
  /// List of all notifications
  List<AppNotification> _notifications = [];
  
  /// Current page for pagination
  int _currentPage = 0;
  
  /// Page size for pagination
  final int _pageSize = 20;
  
  /// Whether there are more notifications to load
  bool _hasMoreData = true;
  
  /// Loading state
  bool _isLoading = false;
  
  /// Current unread count
  int _unreadCount = 0;
  
  /// Get all notifications
  List<AppNotification> get notifications => List.unmodifiable(_notifications);
  
  /// Get unread notifications count
  int get unreadCount => _unreadCount;
  
  /// Get loading state
  bool get isLoading => _isLoading;
  
  /// Get whether there are more notifications to load
  bool get hasMoreData => _hasMoreData;
  
  /// Load notifications from backend
  Future<void> loadNotifications({bool refresh = false}) async {
    if (_isLoading) return;
    
    if (refresh) {
      _currentPage = 0;
      _hasMoreData = true;
      _notifications.clear();
    }
    
    if (!_hasMoreData) return;
    
    _isLoading = true;
    notifyListeners();
    
    try {
      final response = await _notificationsApi.getUserNotifications(
        page: _currentPage,
        size: _pageSize,
      );
      
      final List<dynamic> notificationsData = response['content'] ?? [];
      final List<AppNotification> newNotifications = notificationsData
          .map((data) => AppNotification.fromJson(data))
          .toList();
      
      if (refresh) {
        _notifications = newNotifications;
      } else {
        _notifications.addAll(newNotifications);
      }
      
      _hasMoreData = newNotifications.length == _pageSize;
      _currentPage++;
      
      // Also update unread count
      await _updateUnreadCount();
      
    } catch (e) {
      print('Error loading notifications: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  /// Load unread count from backend
  Future<void> _updateUnreadCount() async {
    try {
      _unreadCount = await _notificationsApi.getUnreadCount();
    } catch (e) {
      print('Error updating unread count: $e');
    }
  }
  
  /// Get initial unread count
  Future<void> getUnreadCount() async {
    try {
      _unreadCount = await _notificationsApi.getUnreadCount();
      notifyListeners();
    } catch (e) {
      print('Error getting unread count: $e');
    }
  }
  
  /// Add a new notification (for local testing)
  void addNotification(AppNotification notification) {
    _notifications.insert(0, notification);
    if (!notification.isRead) {
      _unreadCount++;
    }
    notifyListeners();
  }
  
  /// Mark a notification as read by its ID
  Future<void> markAsRead(String notificationId) async {
    try {
      // Call backend API
      await _notificationsApi.markAsRead(int.parse(notificationId));
      
      // Update local state
      final index = _notifications.indexWhere((notification) => notification.id == notificationId);
      if (index != -1 && !_notifications[index].isRead) {
        _notifications[index] = _notifications[index].markAsRead();
        _unreadCount = (_unreadCount - 1).clamp(0, _unreadCount);
        notifyListeners();
      }
    } catch (e) {
      print('Error marking notification as read: $e');
    }
  }
  
  /// Mark all notifications as read
  Future<void> markAllAsRead() async {
    try {
      // Call backend API
      await _notificationsApi.markAllAsRead();
      
      // Update local state
      for (int i = 0; i < _notifications.length; i++) {
        if (!_notifications[i].isRead) {
          _notifications[i] = _notifications[i].markAsRead();
        }
      }
      _unreadCount = 0;
      notifyListeners();
    } catch (e) {
      print('Error marking all notifications as read: $e');
    }
  }
  
  /// Remove a notification by its ID (local only)
  void removeNotification(String notificationId) {
    final index = _notifications.indexWhere((notification) => notification.id == notificationId);
    if (index != -1) {
      final notification = _notifications[index];
      _notifications.removeAt(index);
      if (!notification.isRead) {
        _unreadCount = (_unreadCount - 1).clamp(0, _unreadCount);
      }
      notifyListeners();
    }
  }
  
  /// Clear all notifications (local only)
  void clearAll() {
    _notifications.clear();
    _unreadCount = 0;
    _currentPage = 0;
    _hasMoreData = true;
    notifyListeners();
  }
  
  /// Add a sample notification for testing
  void addSampleNotification() {
    final notification = AppNotification(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: 1, // Mock user ID
      type: 'trip_invitation',
      content: 'Анна пригласил вас к поездке "Поездка в Санкт-Петербург"',
      relatedId: 123, // Mock trip ID
      isRead: false,
      createdAt: DateTime.now(),
      title: 'Приглашение в поездку',
      message: 'Анна пригласил вас к поездке "Поездка в Санкт-Петербург"',
      invitationStatus: 'pending', // This makes the buttons appear
    );
    
    addNotification(notification);
  }
  
  /// Refresh notifications
  Future<void> refresh() async {
    await loadNotifications(refresh: true);
  }
  
  /// Load more notifications
  Future<void> loadMore() async {
    await loadNotifications(refresh: false);
  }
} 