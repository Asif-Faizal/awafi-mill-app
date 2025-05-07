import 'userData_entity.dart';

abstract class UserRepository {
  Future<UserProfileEntity> getUserProfile();
  Future<bool> editUser(UserProfileEntity userEntity);
}