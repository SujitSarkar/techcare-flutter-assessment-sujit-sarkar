part of 'analytics_bloc.dart';

sealed class AnalyticsState extends Equatable {
  const AnalyticsState();

  @override
  List<Object> get props => [];
}

final class AnalyticsInitialState extends AnalyticsState {}

final class AnalyticsLoadingState extends AnalyticsState {}

final class AnalyticsLoadedState extends AnalyticsState {
  final Analytics analytics;

  const AnalyticsLoadedState({required this.analytics});

  @override
  List<Object> get props => [analytics];
}

final class AnalyticsErrorState extends AnalyticsState {
  final String message;

  const AnalyticsErrorState({required this.message});

  @override
  List<Object> get props => [message];
}
