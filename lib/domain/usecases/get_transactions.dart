import 'package:take_home/domain/repositories/transaction_repository.dart';

class GetTransactions {
  final TransactionRepository repository;

  GetTransactions({required this.repository});

  Future<TransactionResponse> call({int? page, int? limit}) async {
    return await repository.getTransactions(page: page, limit: limit);
  }
}
