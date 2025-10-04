import 'package:take_home/domain/entities/transaction.dart';
import 'package:take_home/data/models/transaction_response.dart';

abstract class TransactionRepository {
  Future<TransactionResponse> getTransactions({int? page, int? limit});
  Future<Transaction> addTransaction(Transaction transaction);
  Future<Transaction> updateTransaction(Transaction transaction);
  Future<bool> deleteTransaction(String transactionId);
}
