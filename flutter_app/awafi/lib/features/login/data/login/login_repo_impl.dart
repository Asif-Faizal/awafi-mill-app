import '../../domain/login/login_entity.dart';
import '../../domain/login/login_repo.dart';
import 'login_datasource.dart';
import 'login_model.dart';

class LoginRepositoryImpl implements LoginRepository {
  final LoginDataSource dataSource;

  LoginRepositoryImpl({required this.dataSource});

  @override
  Future<LoginEntity> loginWithEmail(LoginRequest request) async {
    return await dataSource.loginWithEmail(request);
  }

  @override
  Future<LoginEntity> loginWithNumber(LoginRequest request) async {
    return await dataSource.loginWithNumber(request);
  }
}