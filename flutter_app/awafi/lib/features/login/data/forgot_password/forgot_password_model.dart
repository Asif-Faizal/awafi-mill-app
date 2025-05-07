// forgot_password_request.dart
class ForgotPasswordRequest {
  final String email;

  ForgotPasswordRequest({required this.email});

  Map<String, dynamic> toJson() {
    return {
      'email': email,
    };
  }
}

// verify_otp_request.dart
class VerifyOtpRequest {
  final String email;
  final String otp;

  VerifyOtpRequest({required this.email, required this.otp});

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'otp': otp,
    };
  }
}

// change_password_request.dart
class ChangePasswordRequest {
  final String email;
  final String otp;
  final String newPassword;

  ChangePasswordRequest({required this.email, required this.otp, required this.newPassword});

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'otp': otp,
      'newPassword': newPassword,
    };
  }
}

// forgot_password_response.dart
class ForgotPasswordResponse {
  final String message;
  final bool status;

  ForgotPasswordResponse({required this.message, required this.status});

  factory ForgotPasswordResponse.fromJson(Map<String, dynamic> json) {
    return ForgotPasswordResponse(
      message: json['message'],
      status: json['status'],
    );
  }
}
