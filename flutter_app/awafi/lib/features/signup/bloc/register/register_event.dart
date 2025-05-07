part of 'register_bloc.dart';

abstract class UserEvent {}

class RegisterUserEvent extends UserEvent {
  final UserEntity user;

  RegisterUserEvent(this.user);
}

class VerifyOtpEvent extends UserEvent {
  final OtpEntity otp;

  VerifyOtpEvent(this.otp);
}