import 'package:take_home/core/utils/network_connection.dart';
import 'package:take_home/domain/entities/analytics.dart';
import 'package:take_home/domain/repositories/analytics_repository.dart';
import 'package:take_home/data/datasources/analytics_remote_datasource.dart';
import 'package:take_home/core/errors/failure.dart';
import 'package:take_home/core/errors/result.dart';

class AnalyticsRepositoryImpl implements AnalyticsRepository {
  final AnalyticsRemoteDataSource remoteDataSource;
  final NetworkConnection networkConnection;

  AnalyticsRepositoryImpl({required this.remoteDataSource, required this.networkConnection});

  @override
  Future<Result<Failure, Analytics>> getAnalytics({DateTime? startDate, DateTime? endDate}) async {
    final isOnline = await networkConnection.checkConnection();
    if (isOnline) {
      try {
        final analyticsModel = await remoteDataSource.getAnalytics(startDate: startDate, endDate: endDate);
        return Success(analyticsModel);
      } catch (e) {
        return FailureResult(UnknownFailure('Failed to get analytics', cause: e));
      }
    }
    return const FailureResult(NetworkFailure('No internet connection'));
  }
}
