import 'package:equatable/equatable.dart';

class LoginEntity extends Equatable {
  final String jwtToken;
  final String refreshToken;
  final String customerId;
  final String message;
  final int statusCode;

  const LoginEntity({
    required this.jwtToken,
    required this.refreshToken,
    required this.customerId,
    required this.message,
    required this.statusCode,
  });

  // Factory method to create an instance of LoginEntity from JSON
  factory LoginEntity.fromJson(Map<String, dynamic> json) {
    return LoginEntity(
      jwtToken: json['jwt_token'] ?? '',
      refreshToken: json['refresh_token'] ?? '',
      customerId: json['customer_id'] ?? '',
      message: json['message'] ?? '',
      statusCode: json['status_code'] ?? 0,
    );
  }

  // Method to convert LoginEntity to JSON
  Map<String, dynamic> toJson() {
    return {
      'jwt_token': jwtToken,
      'refresh_token': refreshToken,
      'customer_id': customerId,
      'message': message,
      'status_code': statusCode,
    };
  }

  @override
  List<Object> get props => [jwtToken, refreshToken, customerId, message, statusCode];
}
