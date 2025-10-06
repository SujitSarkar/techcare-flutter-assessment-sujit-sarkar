import 'package:take_home/core/errors/failure.dart';
import 'package:take_home/core/errors/result.dart';
import 'package:take_home/domain/repositories/transaction_repository.dart';

class DeleteTransaction {
  final TransactionRepository repository;

  DeleteTransaction({required this.repository});

  Future<Result<Failure, bool>> call(String transactionId) async {
    return await repository.deleteTransaction(transactionId);
  }
}
