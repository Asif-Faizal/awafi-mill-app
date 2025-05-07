import 'sign_in_entity.dart';
import 'sign_in_repo.dart';

class RegisterUser {
  final SignInRepo repository;

  RegisterUser(this.repository);

  Future<void> call(UserEntity user) async {
    await repository.registerUser(user);
  }
}