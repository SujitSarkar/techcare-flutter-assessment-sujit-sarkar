import 'package:take_home/data/datasources/transaction_remote_datasource.dart';
import 'package:take_home/data/datasources/transaction_local_datasource.dart';
import 'package:take_home/data/models/transaction_model.dart';
import 'package:take_home/data/models/transaction_response.dart';
import 'package:take_home/domain/entities/transaction.dart';
import 'package:take_home/domain/repositories/transaction_repository.dart';
import 'package:take_home/core/utils/network_connection.dart';

class TransactionRepositoryImpl implements TransactionRepository {
  final TransactionRemoteDataSource remoteDataSource;
  final TransactionLocalDataSource localDataSource;
  final NetworkConnection networkConnection;

  TransactionRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkConnection,
  });

  @override
  Future<TransactionResponse> getTransactions({int? page, int? limit}) async {
    final isOnline = await networkConnection.checkConnection();
    try {
      // If offline, try to return cached data even if expired
      if (!isOnline) {
        final cachedTransactions = await localDataSource.getCachedTransactions();
        if (cachedTransactions.isNotEmpty) {
          return TransactionResponse(
            transactions: cachedTransactions,
            currentPage: 1,
            totalPages: 1,
            totalItems: cachedTransactions.length,
            itemsPerPage: cachedTransactions.length,
            hasMore: false,
          );
        }
        throw Exception('No internet connection and no cached data available');
      }

      // Fetch from remote if online
      final responseModel = await remoteDataSource.getTransactions(page: page, limit: limit);

      // Cache the data if it's the first page and we're online
      if (page == null || page == 1) {
        await localDataSource.cacheTransactions(responseModel.transactions);
      }

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
      final isOnline = await networkConnection.checkConnection();

      if (!isOnline) {
        throw Exception('No internet connection. Cannot add transaction.');
      }

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

      // Clear cache after successful addition
      await localDataSource.clearCache();

      return createdTransaction;
    } catch (e) {
      throw Exception('Failed to add transaction: $e');
    }
  }

  @override
  Future<Transaction> updateTransaction(Transaction transaction) async {
    try {
      final isOnline = await networkConnection.checkConnection();

      if (!isOnline) {
        throw Exception('No internet connection. Cannot update transaction.');
      }

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

      // Clear cache after successful update
      await localDataSource.clearCache();

      return updatedTransaction;
    } catch (e) {
      throw Exception('Failed to update transaction: $e');
    }
  }

  @override
  Future<bool> deleteTransaction(String transactionId) async {
    try {
      final isOnline = await networkConnection.checkConnection();

      if (!isOnline) {
        throw Exception('No internet connection. Cannot delete transaction.');
      }

      final result = await remoteDataSource.deleteTransaction(transactionId);

      // Clear cache after successful deletion
      if (result) {
        await localDataSource.clearCache();
      }

      return result;
    } catch (e) {
      throw Exception('Failed to delete transaction: $e');
    }
  }
}
