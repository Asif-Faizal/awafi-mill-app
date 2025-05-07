part of 'signup_input_bloc.dart';

abstract class CountryCodeState extends Equatable {
  final String selectedCode;

  const CountryCodeState(this.selectedCode);

  @override
  List<Object> get props => [selectedCode];
}

class CountryCodeInitial extends CountryCodeState {
  const CountryCodeInitial(super.selectedCode);
}

class CountryCodeUpdated extends CountryCodeState {
  const CountryCodeUpdated(super.selectedCode);
}