part of 'analytics_bloc.dart';

sealed class AnalyticsState extends Equatable {
  const AnalyticsState();

  @override
  List<Object> get props => [];
}

final class AnalyticsInitial extends AnalyticsState {}

final class AnalyticsLoading extends AnalyticsState {}

final class AnalyticsLoaded extends AnalyticsState {
  final Analytics analytics;

  const AnalyticsLoaded({required this.analytics});

  @override
  List<Object> get props => [analytics];
}

final class AnalyticsError extends AnalyticsState {
  final String message;

  const AnalyticsError({required this.message});

  @override
  List<Object> get props => [message];
}
