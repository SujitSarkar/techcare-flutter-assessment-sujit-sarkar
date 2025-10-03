part of 'bottom_nav_bar_bloc.dart';

sealed class BottomNavBarEvent extends Equatable {
  const BottomNavBarEvent();

  @override
  List<Object> get props => [];
}

class BottomNavBarTabChangedEvent extends BottomNavBarEvent {
  final int selectedIndex;

  const BottomNavBarTabChangedEvent(this.selectedIndex);

  @override
  List<Object> get props => [selectedIndex];
}
