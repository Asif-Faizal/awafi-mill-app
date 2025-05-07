part of 'login_input_bloc.dart';

class LoginInputState extends Equatable {
  final InputType inputType;
  final String countryCode; // for storing the country code

  const LoginInputState({
    required this.inputType,
    this.countryCode = '+1', // Default country code
  });
  LoginInputState copyWith({
    InputType? inputType,
    String? countryCode,
  }) {
    return LoginInputState(
      inputType: inputType ?? this.inputType,
      countryCode: countryCode ?? this.countryCode,
    );
  }

  @override
  List<Object> get props => [inputType, countryCode];
}
