part of 'login_input_bloc.dart';

abstract class LoginInputEvent extends Equatable {
  const LoginInputEvent();

  @override
  List<Object?> get props => [];
}

class ToggleInputTypeEvent extends LoginInputEvent {}

class ChangeCountryCode extends LoginInputEvent {
  final String countryCode;

  const ChangeCountryCode(this.countryCode);

  @override
  List<Object> get props => [countryCode];
}