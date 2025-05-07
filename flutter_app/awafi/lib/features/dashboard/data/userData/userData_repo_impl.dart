import '../../domain/userData/userData_entity.dart';
import '../../domain/userData/userData_repo.dart';
import 'userData_datasource.dart';
import 'userData_model.dart';

class UserRepositoryImpl implements UserRepository {
  final UserDataDatasource datasource;

  UserRepositoryImpl({required this.datasource});

  @override
  Future<UserProfileEntity> getUserProfile() async {
    try {
      final userDataModel = await datasource.getUserData();
      if (userDataModel.status) {
        return UserProfileEntity(
          name: userDataModel.profileData.name,
          email: userDataModel.profileData.email,
          phone: userDataModel.profileData.phone,
        );
      } else {
        throw Exception('User not logged in');
      }
    } catch (e) {
      rethrow;
    }
  }
@override
Future<bool> editUser(UserProfileEntity userEntity) async {
  print("Editing user...");
  return await datasource.editUserData(UserProfileData(
    name: userEntity.name,
    email: userEntity.email,
    phone: userEntity.phone,
  ));
}
}