part of 'register_bloc.dart';


abstract class UserState {}

class UserInitial extends UserState {}

class UserLoading extends UserState {}

class UserRegistered extends UserState {}

class UserOtpVerified extends UserState {}

class UserError extends UserState {
  final String message;

  UserError(this.message);
}