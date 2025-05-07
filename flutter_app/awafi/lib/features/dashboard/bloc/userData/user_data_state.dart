part of 'user_data_bloc.dart';

abstract class UserProfileState extends Equatable {
  const UserProfileState();

  @override
  List<Object?> get props => [];
}

class UserProfileInitial extends UserProfileState {}

class UserProfileLoading extends UserProfileState {}

class UserProfileLoaded extends UserProfileState {
  final UserProfileEntity userProfile;

  const UserProfileLoaded({required this.userProfile});

  @override
  List<Object?> get props => [userProfile];
}

class UserProfileError extends UserProfileState {
  final String message;

  const UserProfileError({required this.message});

  @override
  List<Object?> get props => [message];
}

class UserProfileUnauthorized extends UserProfileState {}

class UserEditInitial extends UserProfileState {}

class UserEditInProgress extends UserProfileState {}

class UserEditSuccess extends UserProfileState {
  final String message;

  const UserEditSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class UserEditFailure extends UserProfileState {
  final String error;

  const UserEditFailure(this.error);

  @override
  List<Object?> get props => [error];
}