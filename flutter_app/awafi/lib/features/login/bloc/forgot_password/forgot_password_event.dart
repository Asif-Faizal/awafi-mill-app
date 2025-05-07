part of 'forgot_password_bloc.dart';

abstract class ForgotPasswordEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class ForgotPasswordRequested extends ForgotPasswordEvent {
  final String email;

  ForgotPasswordRequested(this.email);

  @override
  List<Object> get props => [email];
}

class VerifyOtpRequested extends ForgotPasswordEvent {
  final String email;
  final String otp;

  VerifyOtpRequested(this.email, this.otp);

  @override
  List<Object> get props => [email, otp];
}

class ChangePasswordRequested extends ForgotPasswordEvent {
  final String email;
  final String otp;
  final String newPassword;

  ChangePasswordRequested(this.email, this.otp, this.newPassword);

  @override
  List<Object> get props => [email, otp, newPassword];
}