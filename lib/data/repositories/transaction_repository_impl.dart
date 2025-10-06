import 'package:finance_tracker/data/datasources/transaction_remote_datasource.dart';
import 'package:finance_tracker/data/datasources/transaction_local_datasource.dart';
import 'package:finance_tracker/data/models/transaction_model.dart';
import 'package:finance_tracker/domain/entities/transaction_response.dart';
import 'package:finance_tracker/domain/entities/transaction.dart';
import 'package:finance_tracker/domain/repositories/transaction_repository.dart';
import 'package:finance_tracker/core/utils/network_connection.dart';
import 'package:finance_tracker/core/errors/failure.dart';
import 'package:finance_tracker/core/errors/result.dart';

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
  Future<Result<Failure, TransactionResponse>> getTransactions({int? page, int? limit}) async {
    final isOnline = await networkConnection.checkConnection();
    try {
      // If offline, try to return cached data even if expired
      if (!isOnline) {
        final cachedTransactions = await localDataSource.getCachedTransactions();
        if (cachedTransactions.isNotEmpty) {
          return Success(
            TransactionResponse(
              transactions: cachedTransactions,
              currentPage: 1,
              totalPages: 1,
              totalItems: cachedTransactions.length,
              itemsPerPage: cachedTransactions.length,
              hasMore: false,
            ),
          );
        }
        return const FailureResult(NetworkFailure('No internet connection'));
      }

      // Fetch from remote if online
      final responseModel = await remoteDataSource.getTransactions(page: page, limit: limit);

      // Cache the data if it's the first page and we're online
      if (page == null || page == 1) {
        await localDataSource.cacheTransactions(responseModel.transactions);
      }

      return Success(
        TransactionResponse(
          transactions: responseModel.transactions.map((model) => model).toList(),
          currentPage: responseModel.currentPage,
          totalPages: responseModel.totalPages,
          totalItems: responseModel.totalItems,
          itemsPerPage: responseModel.itemsPerPage,
          hasMore: responseModel.hasMore,
        ),
      );
    } catch (e) {
      return FailureResult(UnknownFailure('Failed to fetch transactions', cause: e));
    }
  }

  @override
  Future<Result<Failure, Transaction>> addTransaction(Transaction transaction) async {
    try {
      final isOnline = await networkConnection.checkConnection();

      if (!isOnline) {
        return const FailureResult(NetworkFailure('No internet connection. Cannot add transaction.'));
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

      return Success(createdTransaction);
    } catch (e) {
      return FailureResult(UnknownFailure('Failed to add transaction', cause: e));
    }
  }

  @override
  Future<Result<Failure, Transaction>> updateTransaction(Transaction transaction) async {
    try {
      final isOnline = await networkConnection.checkConnection();

      if (!isOnline) {
        return const FailureResult(NetworkFailure('No internet connection. Cannot update transaction.'));
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

      return Success(updatedTransaction);
    } catch (e) {
      return FailureResult(UnknownFailure('Failed to update transaction', cause: e));
    }
  }

  @override
  Future<Result<Failure, bool>> deleteTransaction(String transactionId) async {
    try {
      final isOnline = await networkConnection.checkConnection();

      if (!isOnline) {
        return const FailureResult(NetworkFailure('No internet connection. Cannot delete transaction.'));
      }

      final result = await remoteDataSource.deleteTransaction(transactionId);

      // Clear cache after successful deletion
      if (result) {
        await localDataSource.clearCache();
      }

      return Success(result);
    } catch (e) {
      return FailureResult(UnknownFailure('Failed to delete transaction', cause: e));
    }
  }
}
