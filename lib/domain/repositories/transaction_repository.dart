import 'package:take_home/domain/entities/transaction.dart';

class TransactionResponse {
  final List<Transaction> transactions;
  final int currentPage;
  final int totalPages;
  final int totalItems;
  final int itemsPerPage;
  final bool hasMore;

  const TransactionResponse({
    required this.transactions,
    required this.currentPage,
    required this.totalPages,
    required this.totalItems,
    required this.itemsPerPage,
    required this.hasMore,
  });
}

abstract class TransactionRepository {
  Future<TransactionResponse> getTransactions({int? page, int? limit});
}
