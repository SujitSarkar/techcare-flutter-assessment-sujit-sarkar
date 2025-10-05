part of 'dashboard_bloc.dart';

sealed class DashboardEvent extends Equatable {
  const DashboardEvent();

  @override
  List<Object> get props => [];
}

class LoadDashboardDataEvent extends DashboardEvent {
  const LoadDashboardDataEvent();
}

class RefreshDashboardEvent extends DashboardEvent {
  const RefreshDashboardEvent();
}

class ToggleBalanceVisibilityEvent extends DashboardEvent {
  const ToggleBalanceVisibilityEvent();
}

class UpdateDashboardFromTransactionsEvent extends DashboardEvent {
  const UpdateDashboardFromTransactionsEvent();
}
