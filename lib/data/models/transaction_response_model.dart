import 'package:finance_tracker/data/models/transaction_model.dart';

class TransactionResponseModel {
  final List<TransactionModel> transactions;
  final int currentPage;
  final int totalPages;
  final int totalItems;
  final int itemsPerPage;
  final bool hasMore;

  const TransactionResponseModel({
    required this.transactions,
    required this.currentPage,
    required this.totalPages,
    required this.totalItems,
    required this.itemsPerPage,
    required this.hasMore,
  });

  factory TransactionResponseModel.fromJson(Map<String, dynamic> json) {
    final List<dynamic> transactionsJson = json['transactions'] as List<dynamic>? ?? [];
    final meta = json['meta'] as Map<String, dynamic>? ?? {};

    return TransactionResponseModel(
      transactions: transactionsJson.map((transaction) => TransactionModel.fromJson(transaction)).toList(),
      currentPage: (meta['currentPage'] as num?)?.toInt() ?? 1,
      totalPages: (meta['totalPages'] as num?)?.toInt() ?? 1,
      totalItems: (meta['totalItems'] as num?)?.toInt() ?? 0,
      itemsPerPage: (meta['itemsPerPage'] as num?)?.toInt() ?? 20,
      hasMore: meta['hasMore'] as bool? ?? false,
    );
  }
}
