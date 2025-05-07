import '../../data/forgot_password/forgot_password_model.dart';
import 'forgot_passcode_entity.dart';
import 'forgot_passcode_repo.dart';

class ChangePasswordUseCase {
  final ForgotPasswordRepository repository;

  ChangePasswordUseCase({required this.repository});

  Future<PasswordResetEntity> call(ChangePasswordRequest request) {
    return repository.changePassword(request);
  }
}