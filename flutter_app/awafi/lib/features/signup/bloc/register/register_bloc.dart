import 'package:bloc/bloc.dart';

import '../../domain/register_user.dart';
import '../../domain/sign_in_entity.dart';
import '../../domain/verify_otp.dart';

part 'register_event.dart';
part 'register_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final RegisterUser registerUser;
  final VerifyOtp verifyOtp;

  UserBloc({required this.registerUser, required this.verifyOtp}) : super(UserInitial()) {
    on<RegisterUserEvent>((event, emit) async {
      emit(UserLoading());
      try {
        await registerUser(event.user);
        emit(UserRegistered());
      } catch (e) {
        emit(UserError(e.toString()));
      }
    });

    on<VerifyOtpEvent>((event, emit) async {
      emit(UserLoading());
      try {
        await verifyOtp(event.otp);
        emit(UserOtpVerified());
      } catch (e) {
        emit(UserError(e.toString()));
      }
    });
  }
}