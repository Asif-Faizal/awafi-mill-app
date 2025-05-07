import 'package:flutter_bloc/flutter_bloc.dart';

class PasswordVisibilityCubit extends Cubit<bool> {
  PasswordVisibilityCubit() : super(true); // true means password is obscured

  void togglePasswordVisibility() {
    emit(!state);
  }
} 