import 'package:take_home/domain/entities/transaction.dart';
import 'package:take_home/domain/repositories/transaction_repository.dart';

class AddTransaction {
  final TransactionRepository repository;

  AddTransaction({required this.repository});

  Future<Transaction> call(Transaction transaction) async {
    return await repository.addTransaction(transaction);
  }
}
