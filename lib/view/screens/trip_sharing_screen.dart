import 'package:flutter/material.dart';
import 'package:putevod/model/trip.dart';
import 'package:putevod/model/app_colors.dart';
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

class TripSharingView extends StatelessWidget {
  const TripSharingView({super.key});

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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _TripCard(trip: trip),
            const SizedBox(height: 24),
            _AddParticipantsSection(viewModel: viewModel),
            const SizedBox(height: 24),
            _CurrentParticipantsSection(viewModel: viewModel),
            const SizedBox(height: 24),
            _SendInvitationsButton(viewModel: viewModel),
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
            // ClipRRect(
            //   borderRadius: BorderRadius.circular(8),
            //   child: Image(
            //     image: NetworkImage(trip.imageUrl),
            //     width: 94,
            //     height: 94,
            //     //fit: BoxFit.cover,
            //   ),
            // ),
            // const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    trip.name,
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
                        '${context.watch<TripSharingViewModel>().participants.length} участника',
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
            controller: viewModel.emailController,
            hintText: 'Email участника',
            icon: Icons.mail_outline,
          ),
          const SizedBox(height: 16),
          _InputField(
            controller: viewModel.searchController,
            hintText: 'Поиск по имени',
            icon: Icons.person_outline,
          ),
          const SizedBox(height: 16),
          TextField(
            controller: viewModel.messageController,
            decoration: const InputDecoration(
              hintText: 'Добавить сообщение (необязательно)',
              hintStyle: TextStyle(
                color: AppColors.text,
                fontSize: 14,
                fontFamily: 'NotoSans',
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(8)),
                borderSide: BorderSide(color: AppColors.text),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(8)),
                borderSide: BorderSide(color: AppColors.text),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(8)),
                borderSide: BorderSide(color: AppColors.accent),
              ),
            ),
            maxLines: 4,
          ),
        ],
      ),
    );
  }
}

class _InputField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData icon;

  const _InputField({
    required this.controller,
    required this.hintText,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.text),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(9),
            child: Icon(icon, color: AppColors.text),
          ),
          Expanded(
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: const TextStyle(
                  color: AppColors.text,
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
          ...viewModel.participants.map((participant) => _ParticipantTile(
            participant: participant,
            onRemove: () => viewModel.removeParticipant(participant),
          )),
        ],
      ),
    );
  }
}

class _ParticipantTile extends StatelessWidget {
  final TripParticipant participant;
  final VoidCallback onRemove;

  const _ParticipantTile({
    required this.participant,
    required this.onRemove,
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
              color: AppColors.accent.withOpacity(0.3),
            ),
            child: ClipOval(
              child: Image.asset(
                participant.avatarUrl,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  participant.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontFamily: 'NotoSans',
                    color: AppColors.text,
                  ),
                ),
                Text(
                  participant.role == ParticipantRole.owner 
                    ? 'Владелец' 
                    : 'Участник',
                  style: const TextStyle(
                    fontSize: 14,
                    fontFamily: 'NotoSans',
                    color: AppColors.text,
                  ),
                ),
              ],
            ),
          ),
          if (participant.role != ParticipantRole.owner)
            IconButton(
              icon: const Icon(
                Icons.close,
                size: 16,
                color: AppColors.accent,
              ),
              onPressed: onRemove,
            ),
        ],
      ),
    );
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
        onPressed: viewModel.sendInvitations,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.accent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Row(
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
} 