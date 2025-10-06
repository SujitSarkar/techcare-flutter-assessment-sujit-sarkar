import 'package:finance_tracker/core/errors/failure.dart';
import 'package:finance_tracker/core/errors/result.dart';
import 'package:finance_tracker/domain/entities/transaction.dart';
import 'package:finance_tracker/domain/entities/transaction_response.dart';

abstract class TransactionRepository {
  Future<Result<Failure, TransactionResponse>> getTransactions({int? page, int? limit});
  Future<Result<Failure, Transaction>> addTransaction(Transaction transaction);
  Future<Result<Failure, Transaction>> updateTransaction(Transaction transaction);
  Future<Result<Failure, bool>> deleteTransaction(String transactionId);
}
