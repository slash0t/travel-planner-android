import 'package:flutter/material.dart';
import 'package:putevod/external/auth_service.dart';
import 'package:putevod/external/trip_service.dart';
import 'package:putevod/model/trip.dart';
import 'package:putevod/model/shared_user.dart';

import '../external/api_client.dart';

class TripSharingViewModel extends ChangeNotifier {
  final TripService _tripService = TripService();
  final ApiClient _plannerClient = ApiClients.planner;
  final Trip trip;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController searchController = TextEditingController();
  final TextEditingController messageController = TextEditingController();

  List<SharedUser> _sharedUsers = [];
  SharedUser? _currentUser;
  bool _isAddingParticipant = false;
  bool _isRemovingParticipant = false;
  
  List<SharedUser> get sharedUsers => _sharedUsers;
  SharedUser? get currentUser => _currentUser;
  bool get isAddingParticipant => _isAddingParticipant;
  bool get isRemovingParticipant => _isRemovingParticipant;
  
  bool get isAdmin => _currentUser?.accessLevel == 'admin';

  TripSharingViewModel({required this.trip}) {}

  Future<void> loadParticipants() async {
    try {
      final response = await _tripService.getTripShares(trip.id);

      _sharedUsers = response.map((data) => SharedUser.fromJson(data)).toList();
      
      _currentUser = await _findCurrentUser();
      
      notifyListeners();
    } catch (e) {
      notifyListeners();
      rethrow;
    }
  }
  
  Future<SharedUser?> _findCurrentUser() async {
    try {
      final userResponse = await _plannerClient.get(
          '/users/me'
      );

      final currentUserId = userResponse.data['id'] as int;
      return _sharedUsers.firstWhere(
        (user) => user.user.id == currentUserId,
      );
    } catch (e) {
      return null;
    }
  }

  Future<void> addParticipant(String username) async {
    if (username.isEmpty) return;
    
    try {
      _isAddingParticipant = true;
      notifyListeners();

      final response = await _plannerClient.post(
          '/trips/${trip.id}/invite-by-username',
          queryParameters: { "username":  username, "accessLevel": "write" },
      );

      SharedUser newUser = SharedUser.fromJson(response.data);
      
      _sharedUsers.add(newUser);
      searchController.clear();
      notifyListeners();

      await loadParticipants();
    } catch (e) {
      rethrow;
    } finally {
      _isAddingParticipant = false;
      notifyListeners();
    }
  }

  Future<void> removeParticipant(SharedUser sharedUser) async {
    if (sharedUser.user.id == _currentUser?.user.id) return; // Can't remove yourself
    
    try {
      _isRemovingParticipant = true;
      notifyListeners();

      final response = await _plannerClient.delete(
          '/trips/${trip.id}/shares/${sharedUser.user.id}'
      );
      
      _sharedUsers.remove(sharedUser);
      notifyListeners();

      await loadParticipants();
    } catch (e) {
      rethrow;
    } finally {
      _isRemovingParticipant = false;
      notifyListeners();
    }
  }

  bool canRemoveUser(SharedUser sharedUser) {
    // Only admin can remove users, and users can't remove themselves
    return isAdmin && sharedUser.user.id != _currentUser?.user.id;
  }

  Future<void> sendInvitations() async {
    // Get the username from search controller
    final username = searchController.text.trim();
    if (username.isNotEmpty) {
      await addParticipant(username);
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    searchController.dispose();
    messageController.dispose();
    super.dispose();
  }
} 