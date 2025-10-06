import 'package:finance_tracker/core/errors/failure.dart';
import 'package:finance_tracker/core/errors/result.dart';
import 'package:finance_tracker/domain/entities/analytics.dart';
import 'package:finance_tracker/domain/repositories/analytics_repository.dart';

class GetAnalytics {
  final AnalyticsRepository repository;

  GetAnalytics({required this.repository});

  Future<Result<Failure, Analytics>> call({DateTime? startDate, DateTime? endDate}) async {
    return await repository.getAnalytics(startDate: startDate, endDate: endDate);
  }
}
