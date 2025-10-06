import 'package:finance_tracker/core/errors/failure.dart';
import 'package:finance_tracker/core/errors/result.dart';
import 'package:finance_tracker/domain/repositories/transaction_repository.dart';

class DeleteTransaction {
  final TransactionRepository repository;

  DeleteTransaction({required this.repository});

  Future<Result<Failure, bool>> call(String transactionId) async {
    return await repository.deleteTransaction(transactionId);
  }
}
