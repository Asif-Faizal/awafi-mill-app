part of 'user_data_bloc.dart';

abstract class UserProfileEvent extends Equatable {
  const UserProfileEvent();

  @override
  List<Object?> get props => [];
}

class FetchUserProfile extends UserProfileEvent {}


class EditUserDataEvent extends UserProfileEvent {
  final String name;
  final String email;
  final int phone;

  const EditUserDataEvent({required this.name, required this.email, required this.phone});

  @override
  List<Object?> get props => [name, email, phone];
}