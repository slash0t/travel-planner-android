import 'package:flutter/material.dart';
import 'package:putevod/model/trip.dart';

class TripSharingViewModel extends ChangeNotifier {
  final Trip trip;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController searchController = TextEditingController();
  final TextEditingController messageController = TextEditingController();

  List<TripParticipant> participants = [
    TripParticipant(
      name: 'Александр Петров',
      role: ParticipantRole.owner,
      avatarUrl: 'assets/images/profile_avatar.png',
    ),
    TripParticipant(
      name: 'Елена Соколова',
      role: ParticipantRole.participant,
      avatarUrl: 'assets/images/profile_avatar.png',
    ),
  ];

  TripSharingViewModel({required this.trip});

  void addParticipant(String email) {
    // TODO: Implement adding participant logic
    notifyListeners();
  }

  void removeParticipant(TripParticipant participant) {
    if (participant.role != ParticipantRole.owner) {
      participants.remove(participant);
      notifyListeners();
    }
  }

  void sendInvitations() {
    // TODO: Implement sending invitations logic
    notifyListeners();
  }

  @override
  void dispose() {
    emailController.dispose();
    searchController.dispose();
    messageController.dispose();
    super.dispose();
  }
}

class TripParticipant {
  final String name;
  final ParticipantRole role;
  final String avatarUrl;

  const TripParticipant({
    required this.name,
    required this.role,
    required this.avatarUrl,
  });
}

enum ParticipantRole {
  owner,
  participant,
} 