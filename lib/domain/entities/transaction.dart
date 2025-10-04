import 'category.dart';

enum TransactionType { income, expense }

class Transaction {
  final String? id;
  final String? title;
  final double? amount;
  final TransactionType? type;
  final Category? category;
  final DateTime? date;
  final String? description;

  const Transaction({this.id, this.title, this.amount, this.type, this.category, this.date, this.description});
}
