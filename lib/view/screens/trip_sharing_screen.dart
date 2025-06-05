import 'package:flutter/material.dart';
import 'package:putevod/model/trip.dart';
import 'package:putevod/model/app_colors.dart';
import 'package:putevod/model/shared_user.dart';
import 'package:putevod/view-model/trip_sharing_view_model.dart';
import 'package:provider/provider.dart';

class TripSharingScreen extends StatelessWidget {
  final Trip trip;

  const TripSharingScreen({super.key, required this.trip});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TripSharingViewModel(trip: trip),
      child: const TripSharingView(),
    );
  }
}

class TripSharingView extends StatefulWidget {
  const TripSharingView({super.key});

  @override
  State<TripSharingView> createState() => _TripSharingViewState();
}

class _TripSharingViewState extends State<TripSharingView> {
  late TripSharingViewModel _viewModel;
  bool _isLoading = true;
  String? _error;
  
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _viewModel = Provider.of<TripSharingViewModel>(context, listen: false);
      _loadData();
    });
  }
  
  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    
    try {
      await _viewModel.loadParticipants();
    } catch (e) {
      setState(() {
        _error = 'Не удалось загрузить участников: ${e.toString()}';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<TripSharingViewModel>();
    final trip = viewModel.trip;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        shadowColor: Colors.black.withOpacity(0.05),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.text),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Поделиться поездкой',
          style: TextStyle(
            color: AppColors.text,
            fontSize: 20,
            fontFamily: 'NotoSans',
          ),
        ),
      ),
      body: _isLoading 
          ? const Center(child: CircularProgressIndicator(color: AppColors.accent))
          : _error != null
              ? _buildErrorView()
              : _buildContentView(viewModel, trip),
    );
  }
  
  Widget _buildErrorView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            color: AppColors.accent,
            size: 48,
          ),
          const SizedBox(height: 16),
          Text(
            _error!,
            style: const TextStyle(
              color: AppColors.text,
              fontSize: 16,
              fontFamily: 'NotoSans',
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _loadData,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.accent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Повторить',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontFamily: 'NotoSans',
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildContentView(TripSharingViewModel viewModel, Trip trip) {
    return RefreshIndicator(
      onRefresh: _loadData,
      color: AppColors.accent,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _TripCard(trip: trip),
            const SizedBox(height: 24),
            _AddParticipantsSection(viewModel: viewModel),
            const SizedBox(height: 24),
            _CurrentParticipantsSection(viewModel: viewModel),
          ],
        ),
      ),
    );
  }
}

class _TripCard extends StatelessWidget {
  final Trip trip;

  const _TripCard({required this.trip});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    trip.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontFamily: 'NotoSans',
                      color: AppColors.text,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '${_formatDate(trip.startDate)} - ${_formatDate(trip.endDate)}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontFamily: 'NotoSans',
                      color: AppColors.text,
                    ),
                  ),
                  const SizedBox(height: 9),
                  Row(
                    children: [
                      const Icon(Icons.group_outlined, 
                        size: 16, 
                        color: Color(0xFF4851D3),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${context.watch<TripSharingViewModel>().sharedUsers.length} участника',
                        style: const TextStyle(
                          fontSize: 14,
                          fontFamily: 'NotoSans',
                          color: AppColors.text,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'января', 'февраля', 'марта', 'апреля', 'мая', 'июня',
      'июля', 'августа', 'сентября', 'октября', 'ноября', 'декабря'
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }
}

class _AddParticipantsSection extends StatelessWidget {
  final TripSharingViewModel viewModel;

  const _AddParticipantsSection({required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Добавить участников',
            style: TextStyle(
              fontSize: 16,
              fontFamily: 'NotoSans',
              fontWeight: FontWeight.w500,
              color: AppColors.text,
            ),
          ),
          const SizedBox(height: 16),
          _InputField(
            controller: viewModel.searchController,
            hintText: 'Ник участника',
            icon: Icons.person,
            enabled: !viewModel.isAddingParticipant,
          ),
          const SizedBox(height: 16),
          _SendInvitationsButton(viewModel: viewModel),
        ],
      ),
    );
  }
}

class _InputField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData icon;
  final bool enabled;

  const _InputField({
    required this.controller,
    required this.hintText,
    required this.icon,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: enabled ? AppColors.text : Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(9),
            child: Icon(icon, color: enabled ? AppColors.text : Colors.grey.shade400),
          ),
          Expanded(
            child: TextField(
              controller: controller,
              enabled: enabled,
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: TextStyle(
                  color: enabled ? AppColors.text : Colors.grey.shade400,
                  fontSize: 14,
                  fontFamily: 'NotoSans',
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CurrentParticipantsSection extends StatelessWidget {
  final TripSharingViewModel viewModel;

  const _CurrentParticipantsSection({required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Текущие участники',
            style: TextStyle(
              fontSize: 16,
              fontFamily: 'NotoSans',
              fontWeight: FontWeight.w500,
              color: AppColors.text,
            ),
          ),
          const SizedBox(height: 16),
          if (viewModel.sharedUsers.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 24),
                child: Text(
                  'Нет участников',
                  style: TextStyle(
                    color: AppColors.text,
                    fontSize: 16,
                    fontFamily: 'NotoSans',
                  ),
                ),
              ),
            )
          else
            ...viewModel.sharedUsers.map((sharedUser) => _ParticipantTile(
              sharedUser: sharedUser,
              canRemove: viewModel.canRemoveUser(sharedUser),
              onRemove: () => viewModel.removeParticipant(sharedUser),
              isRemoving: viewModel.isRemovingParticipant,
            )),
        ],
      ),
    );
  }
}

class _ParticipantTile extends StatelessWidget {
  final SharedUser sharedUser;
  final bool canRemove;
  final VoidCallback onRemove;
  final bool isRemoving;

  const _ParticipantTile({
    required this.sharedUser,
    required this.canRemove,
    required this.onRemove,
    required this.isRemoving,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.accent,
                width: 3,
              ),
              color: AppColors.accent.withOpacity(0),
            ),
            child: ClipOval(
              child: Center(
                child: Text(
                  sharedUser.user.username.substring(0, 1).toUpperCase(),
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.accent,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  sharedUser.user.username,
                  style: const TextStyle(
                    fontSize: 16,
                    fontFamily: 'NotoSans',
                    color: AppColors.text,
                  ),
                ),
                Text(
                  _getRoleText(sharedUser),
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: 'NotoSans',
                    color: sharedUser.invitationStatus == 'pending' 
                        ? AppColors.accent 
                        : AppColors.text,
                  ),
                ),
              ],
            ),
          ),
          if (canRemove)
            isRemoving
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.accent,
                    ),
                  )
                : IconButton(
                    icon: const Icon(
                      Icons.close,
                      size: 16,
                      color: AppColors.accent,
                    ),
                    onPressed: onRemove,
                    tooltip: 'Удалить участника',
                  ),
        ],
      ),
    );
  }
  
  String _getRoleText(SharedUser sharedUser) {
    if (sharedUser.invitationStatus == 'pending') {
      return 'Ожидает подтверждения';
    }
    
    return sharedUser.accessLevel == 'admin' ? 'Администратор' : 'Участник';
  }
}

class _SendInvitationsButton extends StatelessWidget {
  final TripSharingViewModel viewModel;

  const _SendInvitationsButton({required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: viewModel.isAddingParticipant ? null : () => _handleSendInvitations(context),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.accent,
          disabledBackgroundColor: AppColors.accent.withOpacity(0.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: viewModel.isAddingParticipant
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.send, color: AppColors.background),
                  SizedBox(width: 8),
                  Text(
                    'Отправить приглашения',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontFamily: 'NotoSans',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
  
  Future<void> _handleSendInvitations(BuildContext context) async {
    try {
      await viewModel.sendInvitations();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Ошибка: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
} 