import '../../domain/forgot_password/forgot_passcode_entity.dart';
import '../../domain/forgot_password/forgot_passcode_repo.dart';
import 'forgot_password_datasource.dart';
import 'forgot_password_model.dart';

class ForgotPasswordRepositoryImpl implements ForgotPasswordRepository {
  final ForgotPasswordDatasource datasource;

  ForgotPasswordRepositoryImpl({required this.datasource});

  @override
  Future<PasswordResetEntity> forgotPassword(ForgotPasswordRequest request) async {
    final response = await datasource.forgotPassword(request);
    return PasswordResetEntity(
      status: response.status,
      message: response.message,
    );
  }

  @override
  Future<PasswordResetEntity> verifyOtp(VerifyOtpRequest request) async {
    final response = await datasource.verifyOtp(request);
    return PasswordResetEntity(
      status: response.status,
      message: response.message,
    );
  }

  @override
  Future<PasswordResetEntity> changePassword(ChangePasswordRequest request) async {
    final response = await datasource.changePassword(request);
    return PasswordResetEntity(
      status: response.status,
      message: response.message,
    );
  }
}
