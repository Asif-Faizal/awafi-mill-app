import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../data/input_type/input_type_model.dart';

part 'login_input_event.dart';
part 'login_input_state.dart';

class LoginInputBloc extends Bloc<LoginInputEvent, LoginInputState> {
  LoginInputBloc() : super(const LoginInputState(inputType: InputType.email)) {
    // Toggle between email and phone input types
    on<ToggleInputTypeEvent>((event, emit) {
      final newType = state.inputType == InputType.email ? InputType.phone : InputType.email;
      emit(state.copyWith(inputType: newType));
    });

    // Change country code
    on<ChangeCountryCode>((event, emit) {
      emit(state.copyWith(countryCode: event.countryCode));
    });
  }
}
