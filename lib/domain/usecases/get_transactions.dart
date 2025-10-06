import 'package:finance_tracker/core/errors/failure.dart';
import 'package:finance_tracker/core/errors/result.dart';
import 'package:finance_tracker/domain/entities/transaction_response.dart';
import 'package:finance_tracker/domain/repositories/transaction_repository.dart';

class GetTransactions {
  final TransactionRepository repository;

  GetTransactions({required this.repository});

  Future<Result<Failure, TransactionResponse>> call({int? page, int? limit}) async {
    return await repository.getTransactions(page: page, limit: limit);
  }
}
