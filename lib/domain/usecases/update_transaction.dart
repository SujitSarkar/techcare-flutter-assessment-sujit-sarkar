import 'package:take_home/domain/entities/transaction.dart';
import 'package:take_home/domain/repositories/transaction_repository.dart';

class UpdateTransaction {
  final TransactionRepository repository;

  UpdateTransaction({required this.repository});

  Future<Transaction> call(Transaction transaction) async {
    return await repository.updateTransaction(transaction);
  }
}
