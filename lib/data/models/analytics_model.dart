import 'package:take_home/domain/entities/analytics.dart';
import 'package:take_home/data/models/category_model.dart';

class AnalyticsSummaryModel extends AnalyticsSummary {
  const AnalyticsSummaryModel({
    required super.totalIncome,
    required super.totalExpense,
    required super.netBalance,
    required super.savingsRate,
  });

  factory AnalyticsSummaryModel.fromJson(Map<String, dynamic> json) {
    return AnalyticsSummaryModel(
      totalIncome: (json['totalIncome'] as num?)?.toDouble() ?? 0.0,
      totalExpense: (json['totalExpense'] as num?)?.toDouble() ?? 0.0,
      netBalance: (json['netBalance'] as num?)?.toDouble() ?? 0.0,
      savingsRate: (json['savingsRate'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalIncome': totalIncome,
      'totalExpense': totalExpense,
      'netBalance': netBalance,
      'savingsRate': savingsRate,
    };
  }
}

class CategoryBreakdownModel extends CategoryBreakdown {
  const CategoryBreakdownModel({
    required super.category,
    required super.amount,
    required super.percentage,
    required super.transactionCount,
    required super.budget,
    required super.budgetUtilization,
  });

  factory CategoryBreakdownModel.fromJson(Map<String, dynamic> json) {
    return CategoryBreakdownModel(
      category: CategoryModel.fromJson(json['category'] as Map<String, dynamic>),
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      percentage: (json['percentage'] as num?)?.toDouble() ?? 0.0,
      transactionCount: json['transactionCount'] as int? ?? 0,
      budget: (json['budget'] as num?)?.toDouble() ?? 0.0,
      budgetUtilization: (json['budgetUtilization'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'category': (category as CategoryModel).toJson(),
      'amount': amount,
      'percentage': percentage,
      'transactionCount': transactionCount,
      'budget': budget,
      'budgetUtilization': budgetUtilization,
    };
  }
}

class MonthlyTrendModel extends MonthlyTrend {
  const MonthlyTrendModel({required super.month, required super.income, required super.expense});

  factory MonthlyTrendModel.fromJson(Map<String, dynamic> json) {
    return MonthlyTrendModel(
      month: json['month']?.toString() ?? '',
      income: (json['income'] as num?)?.toDouble() ?? 0.0,
      expense: (json['expense'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {'month': month, 'income': income, 'expense': expense};
  }
}

class AnalyticsModel extends Analytics {
  const AnalyticsModel({required super.summary, required super.categoryBreakdown, required super.monthlyTrend});

  factory AnalyticsModel.fromJson(Map<String, dynamic> json) {
    return AnalyticsModel(
      summary: AnalyticsSummaryModel.fromJson(json['summary'] as Map<String, dynamic>),
      categoryBreakdown: (json['categoryBreakdown'] as List<dynamic>)
          .map((item) => CategoryBreakdownModel.fromJson(item as Map<String, dynamic>))
          .toList(),
      monthlyTrend: (json['monthlyTrend'] as List<dynamic>)
          .map((item) => MonthlyTrendModel.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'summary': (summary as AnalyticsSummaryModel).toJson(),
      'categoryBreakdown': categoryBreakdown.map((item) => (item as CategoryBreakdownModel).toJson()).toList(),
      'monthlyTrend': monthlyTrend.map((item) => (item as MonthlyTrendModel).toJson()).toList(),
    };
  }
}
