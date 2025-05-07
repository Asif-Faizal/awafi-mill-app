// models/user_model.dart
class UserModel {
  final String email;
  final String name;
  final int phone;
  final String password;

  UserModel({
    required this.email,
    required this.name,
    required this.phone,
    required this.password,
  });

  Map<String, dynamic> toJson() => {
        "email": email,
        "name": name,
        "phone": phone,
        "password": password,
      };
}

class OtpVerificationModel {
  final String email;
  final String otp;

  OtpVerificationModel({
    required this.email,
    required this.otp,
  });

  Map<String, dynamic> toJson() => {
        "email": email,
        "otp": otp,
      };
}
