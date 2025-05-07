import '../../data/forgot_password/forgot_password_model.dart';
import 'forgot_passcode_entity.dart';
import 'forgot_passcode_repo.dart';

class ForgotPasswordUseCase {
  final ForgotPasswordRepository repository;

  ForgotPasswordUseCase({required this.repository});

  Future<PasswordResetEntity> call(ForgotPasswordRequest request) {
    return repository.forgotPassword(request);
  }
}