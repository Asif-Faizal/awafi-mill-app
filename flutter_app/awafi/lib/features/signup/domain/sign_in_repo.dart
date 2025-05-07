import 'sign_in_entity.dart';

abstract class SignInRepo {
  Future<void> registerUser(UserEntity user);
  Future<void> verifyOtp(OtpEntity otp);
}