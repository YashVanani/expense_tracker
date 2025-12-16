import 'package:expense_tracker_app/models/expense_model.dart';

class ExpenseListResponse {
  final List<ExpenseModel> expenses;
  final double totalAmount;
  final int count;
  final String? message;

  ExpenseListResponse({
    required this.expenses,
    required this.totalAmount,
    required this.count,
    this.message,
  });

  factory ExpenseListResponse.fromJson(Map<String, dynamic> json) {
    final expensesList = json['expenses'] as List<dynamic>? ?? [];
    final expenses = expensesList
        .map((item) => ExpenseModel.fromJson(item as Map<String, dynamic>))
        .toList();

    return ExpenseListResponse(
      expenses: expenses,
      totalAmount: (json['totalAmount'] ?? json['total'] ?? 0.0).toDouble(),
      count: json['count'] ?? expenses.length,
      message: json['message'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'expenses': expenses.map((e) => e.toJson()).toList(),
      'totalAmount': totalAmount,
      'count': count,
      if (message != null) 'message': message,
    };
  }
}

class ExpenseItemResponse {
  final ExpenseModel expense;
  final String? message;

  ExpenseItemResponse({required this.expense, this.message});

  factory ExpenseItemResponse.fromJson(Map<String, dynamic> json) {
    final expenseJson = (json['expense'] ?? json) as Map<String, dynamic>;
    return ExpenseItemResponse(
      expense: ExpenseModel.fromJson(expenseJson),
      message: json['message'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'expense': expense.toJson(),
      if (message != null) 'message': message,
    };
  }
}

class ExpenseSummaryResponse {
  final double totalAmount;
  final Map<String, double> categoryBreakdown;
  final int totalExpenses;

  ExpenseSummaryResponse({
    required this.totalAmount,
    required this.categoryBreakdown,
    required this.totalExpenses,
  });

  factory ExpenseSummaryResponse.fromJson(Map<String, dynamic> json) {
    final breakdown = json['categoryBreakdown'] as Map<String, dynamic>? ?? {};
    final categoryBreakdown = breakdown.map(
      (key, value) => MapEntry(key, (value as num).toDouble()),
    );

    return ExpenseSummaryResponse(
      totalAmount: (json['totalAmount'] ?? json['total'] ?? 0.0).toDouble(),
      categoryBreakdown: categoryBreakdown,
      totalExpenses: json['totalExpenses'] ?? json['count'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalAmount': totalAmount,
      'categoryBreakdown': categoryBreakdown,
      'totalExpenses': totalExpenses,
    };
  }
}
