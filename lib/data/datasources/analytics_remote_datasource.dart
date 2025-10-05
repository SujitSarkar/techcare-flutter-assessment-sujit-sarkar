import 'package:dio/dio.dart';
import '../../core/config/api_config.dart';
import '../models/analytics_model.dart';

abstract class AnalyticsRemoteDataSource {
  Future<AnalyticsModel> getAnalytics({DateTime? startDate, DateTime? endDate});
}

class AnalyticsRemoteDataSourceImpl implements AnalyticsRemoteDataSource {
  final Dio dio;

  AnalyticsRemoteDataSourceImpl({required this.dio});

  @override
  Future<AnalyticsModel> getAnalytics({DateTime? startDate, DateTime? endDate}) async {
    try {
      final Map<String, dynamic> queryParams = {};

      if (startDate != null) {
        queryParams['startDate'] = startDate.toIso8601String().split('T')[0]; // Format as YYYY-MM-DD
      }

      if (endDate != null) {
        queryParams['endDate'] = endDate.toIso8601String().split('T')[0]; // Format as YYYY-MM-DD
      }

      final response = await dio.get(
        ApiConfig.analyticsUrl,
        queryParameters: queryParams.isNotEmpty ? queryParams : null,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = response.data['data'] as Map<String, dynamic>;
        return AnalyticsModel.fromJson(jsonData);
      } else {
        throw Exception('Failed to load analytics: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }
}
