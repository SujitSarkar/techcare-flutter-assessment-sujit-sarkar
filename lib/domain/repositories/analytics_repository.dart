import 'package:finance_tracker/core/errors/failure.dart';
import 'package:finance_tracker/core/errors/result.dart';
import 'package:finance_tracker/domain/entities/analytics.dart';

abstract class AnalyticsRepository {
  Future<Result<Failure, Analytics>> getAnalytics({DateTime? startDate, DateTime? endDate});
}
