import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:putevod/model/analytics_service.dart';
import 'package:putevod/model/app_colors.dart';
import 'package:putevod/model/notification.dart';
import 'package:putevod/view/widgets/app_header.dart';
import 'package:putevod/view-model/notifications_view_model.dart';

/// Screen that displays all notifications
class NotificationsScreen extends StatefulWidget {
  /// Constructor
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent * 0.8) {
      final viewModel = Provider.of<NotificationsViewModel>(context, listen: false);
      viewModel.loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    AnalyticsService.trackNotificationsView();

    final viewModel = Provider.of<NotificationsViewModel>(context);
    
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            AppHeader(
              showBackButton: true,
              title: 'Уведомления',
              actions: [
                if (viewModel.hasNotifications && !viewModel.isInitialLoading)
                  IconButton(
                    icon: const Icon(Icons.done_all),
                    onPressed: () => _markAllAsRead(viewModel),
                    tooltip: 'Отметить все как прочитанные',
                  ),
              ],
            ),
            Expanded(
              child: _buildContent(context, viewModel),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, NotificationsViewModel viewModel) {
    if (viewModel.isInitialLoading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.accent),
      );
    }

    if (viewModel.errorMessage != null) {
      return _buildErrorState(viewModel);
    }

    if (!viewModel.hasNotifications) {
      return _buildEmptyState();
    }

    return RefreshIndicator(
      onRefresh: () => viewModel.refresh(),
      child: _buildNotificationsList(context, viewModel),
    );
  }

  Widget _buildErrorState(NotificationsViewModel viewModel) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: AppColors.accent,
            ),
            const SizedBox(height: 16),
            Text(
              'Ошибка загрузки',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: AppColors.text,
                fontFamily: 'NotoSans',
              ),
            ),
            const SizedBox(height: 8),
            Text(
              viewModel.errorMessage ?? 'Неизвестная ошибка',
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.darkGrey,
                fontFamily: 'NotoSans',
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                viewModel.clearError();
                viewModel.refresh();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accent,
                foregroundColor: Colors.white,
              ),
              child: const Text('Повторить'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_off_outlined,
            size: 64,
            color: AppColors.darkGrey,
          ),
          SizedBox(height: 16),
          Text(
            'Нет уведомлений',
            style: TextStyle(
              fontSize: 16,
              color: AppColors.darkGrey,
              fontFamily: 'NotoSans',
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildNotificationsList(BuildContext context, NotificationsViewModel viewModel) {
    return ListView.separated(
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      itemCount: viewModel.notifications.length + (viewModel.hasMoreData ? 1 : 0),
      separatorBuilder: (context, index) {
        if (index < viewModel.notifications.length - 1) {
          return const Divider(height: 1);
        }
        return const SizedBox.shrink();
      },
      itemBuilder: (context, index) {
        if (index < viewModel.notifications.length) {
          final notification = viewModel.notifications[index];
          return _buildNotificationItem(context, notification, viewModel);
        } else {
          // Loading indicator for pagination
          return _buildLoadingIndicator(viewModel);
        }
      },
    );
  }

  Widget _buildLoadingIndicator(NotificationsViewModel viewModel) {
    if (viewModel.isLoadingMore) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: Center(
          child: CircularProgressIndicator(color: AppColors.accent),
        ),
      );
    }
    return const SizedBox.shrink();
  }
  
  Widget _buildNotificationItem(
    BuildContext context, 
    AppNotification notification, 
    NotificationsViewModel viewModel
  ) {
    final dateFormat = DateFormat('MMM dd, yyyy · HH:mm');
    final formattedDate = dateFormat.format(notification.createdAt);
    
    return Dismissible(
      key: Key(notification.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        color: AppColors.accent,
        child: const Icon(
          Icons.delete_outline,
          color: Colors.white,
        ),
      ),
      onDismissed: (direction) {
        viewModel.removeNotification(notification.id);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Уведомление удалено'),
            duration: Duration(seconds: 2),
          ),
        );
      },
      child: InkWell(
        onTap: () => viewModel.handleNotificationTap(notification),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          decoration: BoxDecoration(
            color: notification.isRead ? Colors.white : AppColors.grey,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.yellow.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      notification.icon ?? Icons.notifications_none,
                      color: AppColors.yellow,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          notification.title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'NotoSans',
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          notification.message,
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.darkGrey,
                            fontFamily: 'NotoSans',
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          formattedDate,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.darkGrey,
                            fontFamily: 'NotoSans',
                          ),
                        ),
                        if (notification.isInvitationResponded)
                          Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: notification.invitationStatus == 'accepted'
                                    ? Colors.green.withOpacity(0.1)
                                    : AppColors.accent.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                notification.invitationStatus == 'accepted'
                                    ? 'Приглашение принято'
                                    : 'Приглашение отклонено',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: notification.invitationStatus == 'accepted'
                                      ? Colors.green.shade700
                                      : AppColors.accent,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'NotoSans',
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  if (!notification.isRead)
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: AppColors.accent,
                        shape: BoxShape.circle,
                      ),
                    ),
                ],
              ),
              if (notification.shouldShowInvitationButtons)
                _buildInvitationButtons(context, notification, viewModel),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInvitationButtons(
    BuildContext context,
    AppNotification notification,
    NotificationsViewModel viewModel,
  ) {
    final isLoading = viewModel.isInvitationLoading(notification.id);
    final tripId = notification.relatedId!;

    return Padding(
      padding: const EdgeInsets.only(top: 12, left: 44),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton.icon(
              onPressed: isLoading
                  ? null
                  : () => _handleAcceptInvitation(context, viewModel, notification.id, tripId),
              icon: isLoading
                  ? SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.check, size: 16),
              label: const Text(
                'Принять',
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: 'NotoSans',
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: isLoading
                  ? null
                  : () => _handleDeclineInvitation(context, viewModel, notification.id, tripId),
              icon: const Icon(Icons.close, size: 16),
              label: const Text(
                'Отклонить',
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: 'NotoSans',
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accent,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleAcceptInvitation(
    BuildContext context,
    NotificationsViewModel viewModel,
    String notificationId,
    int tripId,
  ) async {
    final success = await viewModel.acceptInvitation(notificationId, tripId);
    
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            success
                ? 'Приглашение принято'
                : 'Ошибка при принятии приглашения',
          ),
          backgroundColor: success ? Colors.green : AppColors.accent,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> _handleDeclineInvitation(
    BuildContext context,
    NotificationsViewModel viewModel,
    String notificationId,
    int tripId,
  ) async {
    final success = await viewModel.declineInvitation(notificationId, tripId);
    
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            success
                ? 'Приглашение отклонено'
                : 'Ошибка при отклонении приглашения',
          ),
          backgroundColor: success ? AppColors.darkGrey : AppColors.accent,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  void _markAllAsRead(NotificationsViewModel viewModel) async {
    try {
      await viewModel.markAllAsRead();
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Все уведомления отмечены как прочитанные'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Ошибка: $e'),
            duration: const Duration(seconds: 3),
            backgroundColor: AppColors.accent,
          ),
        );
      }
    }
  }
} 