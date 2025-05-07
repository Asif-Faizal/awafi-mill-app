import '../../data/forgot_password/forgot_password_model.dart';
import 'forgot_passcode_entity.dart';
import 'forgot_passcode_repo.dart';

class VerifyOtpUseCase {
  final ForgotPasswordRepository repository;

  VerifyOtpUseCase({required this.repository});

  Future<PasswordResetEntity> call(VerifyOtpRequest request) {
    return repository.verifyOtp(request);
  }
}