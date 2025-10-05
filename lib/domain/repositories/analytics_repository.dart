import 'package:take_home/domain/entities/analytics.dart';

abstract class AnalyticsRepository {
  Future<Analytics> getAnalytics({DateTime? startDate, DateTime? endDate});
}
