import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:take_home/domain/entities/analytics.dart';
import 'package:take_home/domain/usecases/get_analytics.dart';

part 'analytics_event.dart';
part 'analytics_state.dart';

class AnalyticsBloc extends Bloc<AnalyticsEvent, AnalyticsState> {
  final GetAnalytics getAnalytics;

  AnalyticsBloc({required this.getAnalytics}) : super(AnalyticsInitial()) {
    on<GetAnalyticsEvent>(_onGetAnalytics);
  }

  Future<void> _onGetAnalytics(GetAnalyticsEvent event, Emitter<AnalyticsState> emit) async {
    emit(AnalyticsLoading());

    try {
      final analytics = await getAnalytics.call(startDate: event.startDate, endDate: event.endDate);
      emit(AnalyticsLoaded(analytics: analytics));
    } catch (e) {
      emit(AnalyticsError(message: e.toString()));
    }
  }
}
