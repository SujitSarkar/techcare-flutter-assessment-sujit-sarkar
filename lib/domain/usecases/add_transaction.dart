import 'package:finance_tracker/core/errors/failure.dart';
import 'package:finance_tracker/core/errors/result.dart';
import 'package:finance_tracker/domain/entities/transaction.dart';
import 'package:finance_tracker/domain/repositories/transaction_repository.dart';

class AddTransaction {
  final TransactionRepository repository;

  AddTransaction({required this.repository});

  Future<Result<Failure, Transaction>> call(Transaction transaction) async {
    return await repository.addTransaction(transaction);
  }
}
