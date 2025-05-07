import 'sign_in_entity.dart';
import 'sign_in_repo.dart';

class VerifyOtp {
  final SignInRepo repository;

  VerifyOtp(this.repository);

  Future<void> call(OtpEntity otp) async {
    await repository.verifyOtp(otp);
  }
}