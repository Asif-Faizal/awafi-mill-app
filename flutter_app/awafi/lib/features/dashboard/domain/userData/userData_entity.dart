import 'package:equatable/equatable.dart';

class UserProfileEntity extends Equatable {
  final String name;
  final String email;
  final int phone;

  const UserProfileEntity({required this.name, required this.email, required this.phone});

  @override
  List<Object?> get props => [name, email, phone];
}
