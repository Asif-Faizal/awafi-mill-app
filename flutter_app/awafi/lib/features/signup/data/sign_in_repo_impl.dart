import '../domain/sign_in_entity.dart';
import '../domain/sign_in_repo.dart';
import 'sign_in_datasource.dart';

class SignInRepoImpl implements SignInRepo {
  final UserRemoteDataSource remoteDataSource;

  SignInRepoImpl({required this.remoteDataSource});

  @override
  Future<void> registerUser(UserEntity user) {
    return remoteDataSource.registerUser(user);
  }

  @override
  Future<void> verifyOtp(OtpEntity otp) {
    return remoteDataSource.verifyOtp(otp);
  }
}