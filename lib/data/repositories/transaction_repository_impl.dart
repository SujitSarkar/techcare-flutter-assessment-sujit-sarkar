import 'package:take_home/data/datasources/transaction_remote_datasource.dart';
import 'package:take_home/domain/repositories/transaction_repository.dart';

class TransactionRepositoryImpl implements TransactionRepository {
  final TransactionRemoteDataSource remoteDataSource;

  TransactionRepositoryImpl({required this.remoteDataSource});

  @override
  Future<TransactionResponse> getTransactions({int? page, int? limit}) async {
    try {
      final responseModel = await remoteDataSource.getTransactions(page: page, limit: limit);

      return TransactionResponse(
        transactions: responseModel.transactions.map((model) => model).toList(),
        currentPage: responseModel.currentPage,
        totalPages: responseModel.totalPages,
        totalItems: responseModel.totalItems,
        itemsPerPage: responseModel.itemsPerPage,
        hasMore: responseModel.hasMore,
      );
    } catch (e) {
      throw Exception('Failed to fetch transactions: $e');
    }
  }
}
