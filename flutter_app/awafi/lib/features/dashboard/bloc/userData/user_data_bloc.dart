import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../data/userData/userData_datasource.dart';
import '../../domain/userData/edit_profile.dart';
import '../../domain/userData/get_profile.dart';
import '../../domain/userData/userData_entity.dart';

part 'user_data_event.dart';
part 'user_data_state.dart';

class UserProfileBloc extends Bloc<UserProfileEvent, UserProfileState> {
  final GetUserProfileUseCase getUserProfileUseCase;
  final EditUserUseCase editUserUseCase;

  UserProfileBloc(
      {required this.getUserProfileUseCase, required this.editUserUseCase})
      : super(UserProfileInitial()) {
    on<FetchUserProfile>(_onFetchUserProfile);
    on<EditUserDataEvent>(_onEditUserDataEvent);
  }

  Future<void> _onFetchUserProfile(
    FetchUserProfile event,
    Emitter<UserProfileState> emit,
  ) async {
    emit(UserProfileLoading());
    try {
      final userProfile = await getUserProfileUseCase.execute();
      emit(UserProfileLoaded(userProfile: userProfile));
    } on UnauthorizedException {
      emit(UserProfileUnauthorized());
    } catch (e) {
      emit(UserProfileError(message: e.toString()));
    }
  }

  Future<void> _onEditUserDataEvent(
      EditUserDataEvent event, Emitter<UserProfileState> emit) async {
    emit(UserEditInProgress());
    try {
      bool success = await editUserUseCase.execute(
        UserProfileEntity(
            name: event.name, email: event.email, phone: event.phone),
      );
      print(success); // Make sure this line is executed
      if (success) {
        emit(UserEditSuccess('User data updated successfully'));
        add(FetchUserProfile());
      } else {
        emit(UserEditFailure('Failed to update user data'));
      }
    } catch (e) {
      print("Error: $e");
      emit(UserEditFailure(e.toString()));
    }
  }
}
