part of 'bottom_navigation_bar_bloc.dart';

class BottomNavigationState extends Equatable {
  final int selectedIndex;

  const BottomNavigationState(this.selectedIndex);

  @override
  List<Object?> get props => [selectedIndex];
}