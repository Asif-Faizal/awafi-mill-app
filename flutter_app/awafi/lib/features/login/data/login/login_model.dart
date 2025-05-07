import 'package:equatable/equatable.dart';

class LoginRequest extends Equatable {
  final String? email;
  final String? number;
  final String password;

  const LoginRequest({this.email, this.number, required this.password});

  @override
  List<Object?> get props => [email, number, password];
}
