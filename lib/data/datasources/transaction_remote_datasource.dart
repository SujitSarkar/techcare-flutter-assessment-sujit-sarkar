import 'package:dio/dio.dart';
import 'package:finance_tracker/core/config/api_config.dart';
import 'package:finance_tracker/data/models/transaction_model.dart';
import 'package:finance_tracker/data/models/transaction_response_model.dart';

abstract class TransactionRemoteDataSource {
  Future<TransactionResponseModel> getTransactions({int? page, int? limit});
  Future<TransactionModel> addTransaction(TransactionModel transaction);
  Future<TransactionModel> updateTransaction(TransactionModel transaction);
  Future<bool> deleteTransaction(String transactionId);
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

  @override
  Future<TransactionModel> addTransaction(TransactionModel transaction) async {
    try {
      final response = await dio.post(ApiConfig.transactionsUrl, data: transaction.toJson());

      if (response.statusCode == 201 || response.statusCode == 200) {
        try {
          return transaction;
        } catch (e) {
          throw Exception('Failed to parse created transaction data: $e');
        }
      } else {
        throw Exception('Failed to create transaction: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  @override
  Future<TransactionModel> updateTransaction(TransactionModel transaction) async {
    try {
      final response = await dio.put(ApiConfig.transactionsUrl, data: transaction.toJson());

      if (response.statusCode == 200) {
        return transaction;
      } else {
        throw Exception('Failed to update transaction: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  @override
  Future<bool> deleteTransaction(String transactionId) async {
    try {
      final response = await dio.delete(ApiConfig.transactionsUrl, data: {'id': transactionId});

      return response.statusCode == 200;
    } on DioException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }
}
