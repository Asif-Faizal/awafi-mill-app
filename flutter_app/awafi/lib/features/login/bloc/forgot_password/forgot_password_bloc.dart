import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../data/forgot_password/forgot_password_model.dart';
import '../../domain/forgot_password/change_password.dart';
import '../../domain/forgot_password/forgot_password.dart';
import '../../domain/forgot_password/verify_password_otp.dart';

part 'forgot_password_event.dart';
part 'forgot_password_state.dart';

class ForgotPasswordBloc extends Bloc<ForgotPasswordEvent, ForgotPasswordState> {
  final ForgotPasswordUseCase forgotPasswordUseCase;
  final VerifyOtpUseCase verifyOtpUseCase;
  final ChangePasswordUseCase changePasswordUseCase;

  ForgotPasswordBloc({
    required this.forgotPasswordUseCase,
    required this.verifyOtpUseCase,
    required this.changePasswordUseCase,
  }) : super(ForgotPasswordInitial()) {
    // ForgotPasswordRequested event handler
    on<ForgotPasswordRequested>((event, emit) async {
      emit(ForgotPasswordLoading());
      try {
        final result = await forgotPasswordUseCase(ForgotPasswordRequest(email: event.email));
        emit(ForgotPasswordSuccess(result.message));
      } catch (e) {
        emit(ForgotPasswordFailure(e.toString()));
      }
    });

    // VerifyOtpRequested event handler
    on<VerifyOtpRequested>((event, emit) async {
      emit(ForgotPasswordLoading());
      try {
        final result = await verifyOtpUseCase(VerifyOtpRequest(email: event.email, otp: event.otp));
        emit(ForgotPasswordSuccess(result.message));
      } catch (e) {
        emit(ForgotPasswordFailure(e.toString()));
      }
    });

    // ChangePasswordRequested event handler
    on<ChangePasswordRequested>((event, emit) async {
      emit(ForgotPasswordLoading());
      try {
        final result = await changePasswordUseCase(ChangePasswordRequest(
          email: event.email,
          otp: event.otp,
          newPassword: event.newPassword,
        ));
        emit(ForgotPasswordSuccess(result.message));
      } catch (e) {
        emit(ForgotPasswordFailure(e.toString()));
      }
    });
  }
}
