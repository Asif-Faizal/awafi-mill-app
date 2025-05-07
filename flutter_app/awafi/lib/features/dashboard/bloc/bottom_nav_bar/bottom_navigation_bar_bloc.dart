import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'bottom_navigation_bar_event.dart';
part 'bottom_navigation_bar_state.dart';

class BottomNavigationBloc extends Bloc<BottomNavigationEvent, BottomNavigationState> {
  BottomNavigationBloc() : super(const BottomNavigationState(0)) {
    on<ChangeTab>((event, emit) {
      emit(BottomNavigationState(event.index));
    });
  }
}