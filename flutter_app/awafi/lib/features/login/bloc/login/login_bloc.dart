import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../data/input_type/input_type_model.dart';
import '../../data/login/login_model.dart';
import '../../domain/login/login.dart';
import '../../domain/login/login_entity.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginWithEmailUseCase emailUseCase;
  final LoginWithNumberUseCase numberUseCase;

  LoginBloc({
    required this.emailUseCase,
    required this.numberUseCase,
  }) : super(LoginInitialState()) {
    on<LoginWithEmailEvent>(_onLoginWithEmail);
    on<LoginWithNumberEvent>(_onLoginWithNumber);
  }

  Future<void> _onLoginWithEmail(LoginWithEmailEvent event, Emitter<LoginState> emit) async {
    emit(LoginLoadingState());
    try {
      final loginEntity = await emailUseCase.execute(event.request);
      emit(LoginSuccessState(loginEntity, inputType: InputType.email));
    } catch (e) {
      emit(LoginErrorState(e.toString()));
    }
  }

  Future<void> _onLoginWithNumber(LoginWithNumberEvent event, Emitter<LoginState> emit) async {
    emit(LoginLoadingState());
    try {
      final loginEntity = await numberUseCase.execute(event.request);
      emit(LoginSuccessState(loginEntity, inputType: InputType.phone));
    } catch (e) {
      emit(LoginErrorState(e.toString()));
    }
  }
}
