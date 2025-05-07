part of 'login_bloc.dart';

abstract class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object?> get props => [];
}

class LoginInitialState extends LoginState {}

class LoginLoadingState extends LoginState {}

class LoginSuccessState extends LoginState {
  final LoginEntity loginEntity;
  final InputType inputType;

  const LoginSuccessState(this.loginEntity, {required this.inputType});

  @override
  List<Object?> get props => [loginEntity, inputType];
}

class LoginErrorState extends LoginState {
  final String message;

  const LoginErrorState(this.message);

  @override
  List<Object?> get props => [message];
}