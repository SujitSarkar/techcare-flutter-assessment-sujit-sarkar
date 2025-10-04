import 'package:take_home/domain/repositories/transaction_repository.dart';

class DeleteTransaction {
  final TransactionRepository repository;

  DeleteTransaction({required this.repository});

  Future<bool> call(String transactionId) async {
    return await repository.deleteTransaction(transactionId);
  }
}
