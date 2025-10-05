part of 'analytics_bloc.dart';

sealed class AnalyticsEvent extends Equatable {
  const AnalyticsEvent();

  @override
  List<Object?> get props => [];
}

class GetAnalyticsEvent extends AnalyticsEvent {
  final DateTime? startDate;
  final DateTime? endDate;

  const GetAnalyticsEvent({this.startDate, this.endDate});

  @override
  List<Object?> get props => [startDate, endDate];
}
