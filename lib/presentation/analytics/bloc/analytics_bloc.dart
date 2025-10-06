import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:finance_tracker/domain/entities/analytics.dart';
import 'package:finance_tracker/domain/usecases/get_analytics.dart';

part 'analytics_event.dart';
part 'analytics_state.dart';

class AnalyticsBloc extends Bloc<AnalyticsEvent, AnalyticsState> {
  final GetAnalytics getAnalytics;

  AnalyticsBloc({required this.getAnalytics}) : super(AnalyticsInitialState()) {
    on<GetAnalyticsEvent>(_onGetAnalytics);
  }

  Future<void> _onGetAnalytics(GetAnalyticsEvent event, Emitter<AnalyticsState> emit) async {
    emit(AnalyticsLoadingState());

    final result = await getAnalytics.call(startDate: event.startDate, endDate: event.endDate);
    result.fold(
      onSuccess: (analytics) => emit(AnalyticsLoadedState(analytics: analytics)),
      onFailure: (failure) => emit(AnalyticsErrorState(message: failure.message)),
    );
  }
}
