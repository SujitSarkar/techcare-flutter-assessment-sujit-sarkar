import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'bottom_nav_bar_event.dart';
part 'bottom_nav_bar_state.dart';

class BottomNavBarBloc extends Bloc<BottomNavBarEvent, BottomNavBarState> {
  BottomNavBarBloc() : super(const BottomNavBarChangedState(0)) {
    on<BottomNavBarTabChangedEvent>(_onTabChanged);
  }

  void _onTabChanged(BottomNavBarTabChangedEvent event, Emitter<BottomNavBarState> emit) {
    emit(BottomNavBarChangedState(event.selectedIndex));
  }
}
