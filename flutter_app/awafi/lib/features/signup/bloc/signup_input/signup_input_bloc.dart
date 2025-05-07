import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'signup_input_event.dart';
part 'signup_input_state.dart';


class CountryCodeBloc extends Bloc<CountryCodeEvent, CountryCodeState> {
  CountryCodeBloc() : super(const CountryCodeInitial('+1')) {
    on<CountryCodeChanged>((event, emit) {
      emit(CountryCodeUpdated(event.countryCode));
    });
  }
}
