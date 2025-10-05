import 'package:take_home/core/utils/network_connection.dart';
import 'package:take_home/domain/entities/analytics.dart';
import 'package:take_home/domain/repositories/analytics_repository.dart';
import 'package:take_home/data/datasources/analytics_remote_datasource.dart';

class AnalyticsRepositoryImpl implements AnalyticsRepository {
  final AnalyticsRemoteDataSource remoteDataSource;
  final NetworkConnection networkConnection;

  AnalyticsRepositoryImpl({required this.remoteDataSource, required this.networkConnection});

  @override
  Future<Analytics> getAnalytics({DateTime? startDate, DateTime? endDate}) async {
    final isOnline = await networkConnection.checkConnection();
    if (isOnline) {
      try {
        final analyticsModel = await remoteDataSource.getAnalytics(startDate: startDate, endDate: endDate);
        return analyticsModel;
      } catch (e) {
        throw Exception('Failed to get analytics: $e');
      }
    }
    throw Exception('No internet connection');
  }
}
