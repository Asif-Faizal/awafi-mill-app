import '../../data/login/login_model.dart';
import 'login_entity.dart';
import 'login_repo.dart';

abstract class LoginUseCase {
  Future<LoginEntity> execute(LoginRequest request);
}

class LoginWithEmailUseCase implements LoginUseCase {
  final LoginRepository repository;

  LoginWithEmailUseCase({required this.repository});

  @override
  Future<LoginEntity> execute(LoginRequest request) {
    return repository.loginWithEmail(request);
  }
}

class LoginWithNumberUseCase implements LoginUseCase {
  final LoginRepository repository;

  LoginWithNumberUseCase({required this.repository});

  @override
  Future<LoginEntity> execute(LoginRequest request) {
    return repository.loginWithNumber(request);
  }
}
