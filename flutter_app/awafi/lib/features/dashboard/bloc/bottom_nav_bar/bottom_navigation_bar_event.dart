part of 'bottom_navigation_bar_bloc.dart';

abstract class BottomNavigationEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class ChangeTab extends BottomNavigationEvent {
  final int index;

  ChangeTab(this.index);

  @override
  List<Object?> get props => [index];
}