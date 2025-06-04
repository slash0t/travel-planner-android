import 'dart:async';
import 'package:flutter/material.dart';
import 'package:putevod/external/notifications_service.dart';

/// ViewModel for the app header to manage notifications
class AppHeaderViewModel extends ChangeNotifier {
  final NotificationsService _notificationsService = NotificationsService();
  
  /// Current unread notifications count
  int _unreadCount = 0;
  
  /// Timer for periodic updates
  Timer? _updateTimer;
  
  /// Update interval in seconds
  static const int _updateIntervalSeconds = 30;
  
  /// Get unread notifications count
  int get unreadCount => _unreadCount;
  
  /// Whether there are any unread notifications
  bool get hasUnreadNotifications => _unreadCount > 0;
  
  /// Constructor that starts periodic updates
  AppHeaderViewModel() {
    _initializeAndStartUpdates();
  }
  
  @override
  void dispose() {
    _updateTimer?.cancel();
    super.dispose();
  }
  
  /// Initialize and start periodic updates
  void _initializeAndStartUpdates() {
    // Get initial count
    _updateUnreadCount();
    
    // Start periodic updates
    _updateTimer = Timer.periodic(
      const Duration(seconds: _updateIntervalSeconds),
      (_) => _updateUnreadCount(),
    );
  }
  
  /// Update unread count from backend
  Future<void> _updateUnreadCount() async {
    try {
      final newCount = await _notificationsService.getUnreadCount();
      if (_unreadCount != newCount) {
        _unreadCount = newCount;
        notifyListeners();
      }
    } catch (e) {
      // Silently fail - don't show errors for background updates
      debugPrint('Error updating unread count: $e');
    }
  }
  
  /// Force refresh unread count
  Future<void> refreshUnreadCount() async {
    await _updateUnreadCount();
  }
  
  /// Manually set unread count (for when user marks notifications as read)
  void setUnreadCount(int count) {
    if (_unreadCount != count) {
      _unreadCount = count;
      notifyListeners();
    }
  }
  
  /// Decrease unread count by one
  void decreaseUnreadCount() {
    if (_unreadCount > 0) {
      _unreadCount--;
      notifyListeners();
    }
  }
  
  /// Reset unread count to zero
  void resetUnreadCount() {
    setUnreadCount(0);
  }
} 