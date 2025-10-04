import 'package:dio/dio.dart';
import 'package:take_home/core/config/api_config.dart';
import 'package:take_home/data/models/transaction_model.dart';

class TransactionResponseModel {
  final List<TransactionModel> transactions;
  final int currentPage;
  final int totalPages;
  final int totalItems;
  final int itemsPerPage;
  final bool hasMore;

  const TransactionResponseModel({
    required this.transactions,
    required this.currentPage,
    required this.totalPages,
    required this.totalItems,
    required this.itemsPerPage,
    required this.hasMore,
  });

  factory TransactionResponseModel.fromJson(Map<String, dynamic> json) {
    final List<dynamic> transactionsJson = json['transactions'] as List<dynamic>? ?? [];
    final meta = json['meta'] as Map<String, dynamic>? ?? {};

    return TransactionResponseModel(
      transactions: transactionsJson.map((transaction) => TransactionModel.fromJson(transaction)).toList(),
      currentPage: (meta['currentPage'] as num?)?.toInt() ?? 1,
      totalPages: (meta['totalPages'] as num?)?.toInt() ?? 1,
      totalItems: (meta['totalItems'] as num?)?.toInt() ?? 0,
      itemsPerPage: (meta['itemsPerPage'] as num?)?.toInt() ?? 20,
      hasMore: meta['hasMore'] as bool? ?? false,
    );
  }
}

abstract class TransactionRemoteDataSource {
  Future<TransactionResponseModel> getTransactions({int? page, int? limit});
}

class TransactionRemoteDataSourceImpl implements TransactionRemoteDataSource {
  final Dio dio;

  TransactionRemoteDataSourceImpl({required this.dio});

  @override
  Future<TransactionResponseModel> getTransactions({int? page, int? limit}) async {
    try {
      final Map<String, dynamic> queryParams = {};
      if (page != null) {
        queryParams['page'] = page;
      }
      if (limit != null) {
        queryParams['limit'] = limit;
      }

      final response = await dio.get(ApiConfig.transactionsUrl, queryParameters: queryParams);

      if (response.statusCode == 200) {
        try {
          return TransactionResponseModel.fromJson(response.data);
        } catch (e) {
          throw Exception('Failed to parse transaction data: $e');
        }
      } else {
        throw Exception('Failed to load transactions: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }
}
