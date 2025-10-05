import 'package:take_home/domain/entities/analytics.dart';
import 'package:take_home/domain/repositories/analytics_repository.dart';

class GetAnalytics {
  final AnalyticsRepository repository;

  GetAnalytics({required this.repository});

  Future<Analytics> call({DateTime? startDate, DateTime? endDate}) async {
    return await repository.getAnalytics(startDate: startDate, endDate: endDate);
  }
}
