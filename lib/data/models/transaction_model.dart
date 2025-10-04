import 'package:take_home/domain/entities/transaction.dart';
import 'category_model.dart';

class TransactionModel extends Transaction {
  const TransactionModel({
    required super.id,
    required super.title,
    required super.amount,
    required super.type,
    required super.category,
    required super.date,
    required super.description,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id']?.toString(),
      title: json['title']?.toString(),
      amount: (json['amount'] as num?)?.toDouble(),
      type: json['type'] == 'income' ? TransactionType.income : TransactionType.expense,
      category: json['category'] != null ? CategoryModel.fromJson(json['category']) : null,
      date: json['date'] != null ? DateTime.tryParse(json['date'].toString()) : null,
      description: json['description']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'type': type == TransactionType.income ? 'income' : 'expense',
      'category': category != null ? (category as CategoryModel).toJson() : null,
      'date': date?.toIso8601String(),
      'description': description,
    };
  }
}
