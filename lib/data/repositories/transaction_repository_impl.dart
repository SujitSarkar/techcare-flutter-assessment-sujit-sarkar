import 'package:take_home/data/datasources/transaction_remote_datasource.dart';
import 'package:take_home/data/models/transaction_model.dart';
import 'package:take_home/data/models/transaction_response.dart';
import 'package:take_home/domain/entities/transaction.dart';
import 'package:take_home/domain/repositories/transaction_repository.dart';

class TransactionRepositoryImpl implements TransactionRepository {
  final TransactionRemoteDataSource remoteDataSource;

  TransactionRepositoryImpl({required this.remoteDataSource});

  @override
  Future<TransactionResponse> getTransactions({int? page, int? limit}) async {
    try {
      final responseModel = await remoteDataSource.getTransactions(page: page, limit: limit);

      return TransactionResponse(
        transactions: responseModel.transactions.map((model) => model).toList(),
        currentPage: responseModel.currentPage,
        totalPages: responseModel.totalPages,
        totalItems: responseModel.totalItems,
        itemsPerPage: responseModel.itemsPerPage,
        hasMore: responseModel.hasMore,
      );
    } catch (e) {
      throw Exception('Failed to fetch transactions: $e');
    }
  }

  @override
  Future<Transaction> addTransaction(Transaction transaction) async {
    try {
      final transactionModel = TransactionModel(
        id: transaction.id,
        title: transaction.title,
        amount: transaction.amount,
        type: transaction.type,
        category: transaction.category,
        date: transaction.date,
        description: transaction.description,
      );

      final createdTransaction = await remoteDataSource.addTransaction(transactionModel);
      return createdTransaction;
    } catch (e) {
      throw Exception('Failed to add transaction: $e');
    }
  }

  @override
  Future<Transaction> updateTransaction(Transaction transaction) async {
    try {
      final transactionModel = TransactionModel(
        id: transaction.id,
        title: transaction.title,
        amount: transaction.amount,
        type: transaction.type,
        category: transaction.category,
        date: transaction.date,
        description: transaction.description,
      );

      final updatedTransaction = await remoteDataSource.updateTransaction(transactionModel);
      return updatedTransaction;
    } catch (e) {
      throw Exception('Failed to update transaction: $e');
    }
  }

  @override
  Future<bool> deleteTransaction(String transactionId) async {
    try {
      return await remoteDataSource.deleteTransaction(transactionId);
    } catch (e) {
      throw Exception('Failed to delete transaction: $e');
    }
  }
}
