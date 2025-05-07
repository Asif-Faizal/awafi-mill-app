import '../../data/forgot_password/forgot_password_model.dart';
import 'forgot_passcode_entity.dart';

abstract class ForgotPasswordRepository {
  Future<PasswordResetEntity> forgotPassword(ForgotPasswordRequest request);
  Future<PasswordResetEntity> verifyOtp(VerifyOtpRequest request);
  Future<PasswordResetEntity> changePassword(ChangePasswordRequest request);
}
