class AuthModel {
  final String email;
  final String password;
  final String? deviceId;
  final String? confirmPassword;
  
  AuthModel({
    required this.email,
    required this.password,
    this.deviceId,
    this.confirmPassword,
  });
  
  Map<String, dynamic> toLoginJson() {
    return {
      'email': email,
      'password': password,
      'deviceId': deviceId,
    };
  }
  
  Map<String, dynamic> toRegisterJson() {
    return {
      'email': email,
      'password': password,
      'deviceId': deviceId,
      'username': email,
      'firstName': '',
      'lastName': '',
    };
  }
  
  Map<String, dynamic> toForgotPasswordJson() {
    return {
      'email': email,
    };
  }
  
  Map<String, dynamic> toVerifyResetCodeJson(String code) {
    return {
      'email': email,
      'code': code,
    };
  }
  
  Map<String, dynamic> toResetPasswordJson(String resetToken) {
    return {
      'resetToken': resetToken,
      'newPassword': password,
    };
  }
  
  bool passwordsMatch() {
    return password == confirmPassword;
  }
}

class AuthResponse {
  final bool success;
  final String? accessToken;
  final String? refreshToken;
  final String? resetToken;
  final String? message;
  
  AuthResponse({
    required this.success,
    this.accessToken,
    this.refreshToken,
    this.resetToken,
    this.message,
  });
  
  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      success: true,
      accessToken: json['accessToken'],
      refreshToken: json['refreshToken'],
      resetToken: json['resetToken'],
      message: json['message'],
    );
  }
  
  factory AuthResponse.error(String message) {
    return AuthResponse(
      success: false,
      message: message,
    );
  }
} 