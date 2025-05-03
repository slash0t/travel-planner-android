import 'package:flutter/material.dart';
import 'package:putevod/model/app_colors.dart';

/// A reusable header widget for the application
class AppHeader extends StatelessWidget {
  /// Callback when the notification button is pressed
  final VoidCallback? onNotificationPressed;
  
  /// Callback when the back button is pressed
  final VoidCallback? onBackPressed;
  
  /// Flag to show back button instead of logo
  final bool showBackButton;
  
  /// Optional title to display when back button is shown
  final String? title;

  /// Creates a header widget that can be used across the app
  const AppHeader({
    super.key,
    this.onNotificationPressed,
    this.onBackPressed,
    this.showBackButton = false,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: const Offset(0, 1),
            blurRadius: 2,
          ),
        ],
        border: Border(
          bottom: BorderSide(
            color: const Color(0xFFE5E7EB),
            width: 1,
          ),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (showBackButton) _buildBackButton() else _buildLogo(),
          IconButton(
            icon: const Icon(Icons.notifications_none_outlined),
            onPressed: onNotificationPressed,
          ),
        ],
      ),
    );
  }
  
  Widget _buildBackButton() {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: onBackPressed,
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
        ),
        if (title != null)
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Text(
              title!,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                fontFamily: 'NotoSans',
              ),
            ),
          ),
      ],
    );
  }
  
  Widget _buildLogo() {
    return SizedBox(
      height: 36,
      child: Image.asset(
        'assets/images/wide_logo.png',
        fit: BoxFit.contain,
      ),
    );
  }
} 