import 'userData_entity.dart';
import 'userData_repo.dart';

class GetUserProfileUseCase {
  final UserRepository userRepository;

  GetUserProfileUseCase({required this.userRepository});

  Future<UserProfileEntity> execute() async {
    return await userRepository.getUserProfile();
  }
}