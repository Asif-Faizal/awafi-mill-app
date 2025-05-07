import 'userData_entity.dart';
import 'userData_repo.dart';

class EditUserUseCase {
  final UserRepository repository;

  EditUserUseCase({required this.repository});

  Future<bool> execute(UserProfileEntity userEntity) {
    print("Executing edit user...");
    return repository.editUser(userEntity);
  }
}