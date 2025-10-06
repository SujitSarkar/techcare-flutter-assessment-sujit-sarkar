import 'package:take_home/core/errors/failure.dart';
import 'package:take_home/core/errors/result.dart';
import 'package:take_home/domain/entities/analytics.dart';

abstract class AnalyticsRepository {
  Future<Result<Failure, Analytics>> getAnalytics({DateTime? startDate, DateTime? endDate});
}
