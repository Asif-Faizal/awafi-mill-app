part of 'forgot_password_bloc.dart';

abstract class ForgotPasswordState extends Equatable {
  @override
  List<Object> get props => [];
}

class ForgotPasswordInitial extends ForgotPasswordState {}

class ForgotPasswordLoading extends ForgotPasswordState {}

class ForgotPasswordSuccess extends ForgotPasswordState {
  final String message;

  ForgotPasswordSuccess(this.message);

  @override
  List<Object> get props => [message];
}

class ForgotPasswordFailure extends ForgotPasswordState {
  final String message;

  ForgotPasswordFailure(this.message);

  @override
  List<Object> get props => [message];
}