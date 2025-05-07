import '../../data/login/login_model.dart';
import 'login_entity.dart';

abstract class LoginRepository {
  Future<LoginEntity> loginWithEmail(LoginRequest request);
  Future<LoginEntity> loginWithNumber(LoginRequest request);
}