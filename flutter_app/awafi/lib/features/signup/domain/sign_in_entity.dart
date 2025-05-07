// entities/user_entity.dart
class UserEntity {
  final String email;
  final String name;
  final int phone;
  final String password;

  UserEntity({
    required this.email,
    required this.name,
    required this.phone,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'name': name,
      'phone': phone,
      'password': password,
    };
  }
}

class OtpEntity {
  final String email;
  final String otp;

  OtpEntity({
    required this.email,
    required this.otp,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'otp': otp,
    };
  }
}
