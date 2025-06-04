import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:putevod/model/app_colors.dart';
import 'package:putevod/view/screens/notifications_screen.dart';
import 'package:putevod/view-model/app_header_view_model.dart';

class AppHeader extends StatelessWidget {
  final bool showBackButton;
  
  final String? title;
  
  final List<Widget>? actions;

  /// Creates a header widget that can be used across the app
  const AppHeader({
    super.key,
    this.showBackButton = false,
    this.title,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AppHeaderViewModel(),
      child: Consumer<AppHeaderViewModel>(
        builder: (context, headerViewModel, child) {
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
                if (showBackButton) _buildBackButton(context) else _buildLogo(),
                Row(
                  children: [
                    if (actions != null) ...actions!,
                    // _buildNotificationButton(context, headerViewModel),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void onBackPressed(BuildContext context) {
    Navigator.pop(context);
  }
  
  Widget _buildBackButton(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => onBackPressed(context),
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

  void onNotificationPressed(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const NotificationsScreen(),
      ),
    );
  }
  
  Widget _buildNotificationButton(BuildContext context, AppHeaderViewModel headerViewModel) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        IconButton(
          icon: const Icon(Icons.notifications_none_outlined),
          onPressed: () => onNotificationPressed(context),
        ),
        if (headerViewModel.hasUnreadNotifications)
          Positioned(
            right: 8,
            top: 8,
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: AppColors.accent,
                borderRadius: BorderRadius.circular(10),
              ),
              constraints: const BoxConstraints(
                minWidth: 12,
                minHeight: 12,
              ),
              child: headerViewModel.unreadCount > 9
                  ? const Text(
                      '9+',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 8,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'NotoSans',
                      ),
                      textAlign: TextAlign.center,
                    )
                  : Text(
                      '${headerViewModel.unreadCount}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 8,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'NotoSans',
                      ),
                      textAlign: TextAlign.center,
                    ),
            ),
          ),
      ],
    );
  }
} 