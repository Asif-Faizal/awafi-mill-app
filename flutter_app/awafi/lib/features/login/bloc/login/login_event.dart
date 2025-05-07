part of 'login_bloc.dart';


abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object?> get props => [];
}

class LoginWithEmailEvent extends LoginEvent {
  final LoginRequest request;

  const LoginWithEmailEvent(this.request);

  @override
  List<Object?> get props => [request];
}

class LoginWithNumberEvent extends LoginEvent {
  final LoginRequest request;

  const LoginWithNumberEvent(this.request);

  @override
  List<Object?> get props => [request];
}