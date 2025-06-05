class User {
  final int id;
  final String username;
  final String email;
  final bool admin;
  final bool verified;

  const User({
    required this.id,
    required this.username,
    required this.email,
    required this.admin,
    required this.verified,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int,
      username: json['username'] as String,
      email: json['email'] as String,
      admin: json['admin'] as bool,
      verified: json['verified'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'admin': admin,
      'verified': verified,
    };
  }

  User copyWith({
    int? id,
    String? username,
    String? email,
    bool? admin,
    bool? verified,
  }) {
    return User(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      admin: admin ?? this.admin,
      verified: verified ?? this.verified,
    );
  }
}

class SharedUser {
  final int id;
  final int tripId;
  final User user;
  final String accessLevel;
  final String invitationStatus;

  const SharedUser({
    required this.id,
    required this.tripId,
    required this.user,
    required this.accessLevel,
    required this.invitationStatus,
  });

  factory SharedUser.fromJson(Map<String, dynamic> json) {
    return SharedUser(
      id: json['id'] as int,
      tripId: json['tripId'] as int,
      user: User.fromJson(json['user'] as Map<String, dynamic>),
      accessLevel: json['accessLevel'] as String,
      invitationStatus: json['invitationStatus'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tripId': tripId,
      'user': user.toJson(),
      'accessLevel': accessLevel,
      'invitationStatus': invitationStatus,
    };
  }

  SharedUser copyWith({
    int? id,
    int? tripId,
    User? user,
    String? accessLevel,
    String? invitationStatus,
  }) {
    return SharedUser(
      id: id ?? this.id,
      tripId: tripId ?? this.tripId,
      user: user ?? this.user,
      accessLevel: accessLevel ?? this.accessLevel,
      invitationStatus: invitationStatus ?? this.invitationStatus,
    );
  }
}