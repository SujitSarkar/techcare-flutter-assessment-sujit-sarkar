import 'package:take_home/core/errors/failure.dart';
import 'package:take_home/core/errors/result.dart';
import 'package:take_home/domain/entities/transaction_response.dart';
import 'package:take_home/domain/repositories/transaction_repository.dart';

class GetTransactions {
  final TransactionRepository repository;

  GetTransactions({required this.repository});

  Future<Result<Failure, TransactionResponse>> call({int? page, int? limit}) async {
    return await repository.getTransactions(page: page, limit: limit);
  }
}
