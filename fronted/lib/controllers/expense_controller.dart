import 'package:expense_tracker_app/models/expense_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/api_service.dart';
import '../models/expense_response.dart';

class ExpenseController extends GetxController {
  final ApiService _apiService = Get.find<ApiService>();

  final expenses = <ExpenseModel>[].obs;
  final isLoading = false.obs;
  final totalAmount = 0.0.obs;

  final titleController = TextEditingController();
  final amountController = TextEditingController();
  final categoryController = TextEditingController();
  final dateController = TextEditingController();

  final expenseFormKey = GlobalKey<FormState>();

  final selectedExpense = Rx<ExpenseModel?>(null);

  final selectedDate = Rx<DateTime>(DateTime.now());

  final selectedCategory = Rx<String>('');

  final categories = [
    'Food',
    'Transport',
    'Shopping',
    'Bills',
    'Entertainment',
    'Health',
    'Education',
    'Other',
  ];

  double get totalExpenses {
    return totalAmount.value > 0
        ? totalAmount.value
        : expenses.fold(0.0, (sum, expense) => sum + expense.amount);
  }

  void initializeDate() {
    dateController.text = _formatDate(selectedDate.value);
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate.value,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != selectedDate.value) {
      selectedDate.value = picked;
      dateController.text = _formatDate(picked);
    }
  }

  String? validateTitle(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter expense title';
    }
    if (value.length < 2) {
      return 'Title must be at least 2 characters';
    }
    return null;
  }

  String? validateAmount(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter amount';
    }
    final amount = double.tryParse(value);
    if (amount == null) {
      return 'Please enter a valid amount';
    }
    if (amount <= 0) {
      return 'Amount must be greater than 0';
    }
    return null;
  }

  String? validateCategory(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please select a category';
    }
    return null;
  }

  String? validateDate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please select a date';
    }
    return null;
  }

  Future<void> loadExpenses() async {
    isLoading.value = true;
    try {
      final response = await _apiService.get<ExpenseListResponse>(
        '/expenses',
        requiresAuth: true,
        fromJson: (json) => ExpenseListResponse.fromJson(json),
      );

      if (response.success && response.data != null) {
        expenses.value = response.data!.expenses;
        totalAmount.value = response.data!.totalAmount;
      } else {
        Get.snackbar(
          'Error',
          response.message,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Get.theme.colorScheme.error,
          colorText: Get.theme.colorScheme.onError,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load expenses: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Get.theme.colorScheme.onError,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addExpense() async {
    if (expenseFormKey.currentState!.validate()) {
      isLoading.value = true;
      try {
        final category = selectedCategory.value.isNotEmpty
            ? selectedCategory.value
            : categoryController.text.trim();

        final response = await _apiService.post<ExpenseItemResponse>(
          '/expenses',
          {
            'title': titleController.text.trim(),
            'amount': double.parse(amountController.text.trim()),
            'category': category,
            'date': selectedDate.value.toIso8601String(),
          },
          requiresAuth: true,
          fromJson: (json) => ExpenseItemResponse.fromJson(json),
        );

        if (response.success && response.data != null) {
          final created = response.data!.expense;
          expenses.add(created);
          totalAmount.value += created.amount;
          clearForm();
          Get.back();

          Get.snackbar(
            'Success',
            response.data!.message ?? response.message,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Get.theme.colorScheme.primary,
            colorText: Get.theme.colorScheme.onPrimary,
          );
        } else {
          Get.snackbar(
            'Error',
            response.message,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Get.theme.colorScheme.error,
            colorText: Get.theme.colorScheme.onError,
          );
        }
      } catch (e) {
        Get.snackbar(
          'Error',
          'Failed to add expense: ${e.toString()}',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Get.theme.colorScheme.error,
          colorText: Get.theme.colorScheme.onError,
        );
      } finally {
        isLoading.value = false;
      }
    }
  }

  Future<void> updateExpense() async {
    if (expenseFormKey.currentState!.validate() &&
        selectedExpense.value != null) {
      isLoading.value = true;
      try {
        final category = selectedCategory.value.isNotEmpty
            ? selectedCategory.value
            : categoryController.text.trim();

        final oldAmount = selectedExpense.value!.amount;

        final response = await _apiService.put<ExpenseItemResponse>(
          '/expenses/${selectedExpense.value!.id}',
          {
            'title': titleController.text.trim(),
            'amount': double.parse(amountController.text.trim()),
            'category': category,
            'date': selectedDate.value.toIso8601String(),
          },
          requiresAuth: true,
          fromJson: (json) => ExpenseItemResponse.fromJson(json),
        );

        if (response.success && response.data != null) {
          final updated = response.data!.expense;
          final index = expenses.indexWhere(
            (e) => e.id == selectedExpense.value!.id,
          );
          if (index != -1) {
            expenses[index] = updated;
            totalAmount.value = totalAmount.value - oldAmount + updated.amount;
          }
          clearForm();
          Get.back();

          Get.snackbar(
            'Success',
            response.data!.message ?? response.message,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Get.theme.colorScheme.primary,
            colorText: Get.theme.colorScheme.onPrimary,
          );
        } else {
          Get.snackbar(
            'Error',
            response.message,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Get.theme.colorScheme.error,
            colorText: Get.theme.colorScheme.onError,
          );
        }
      } catch (e) {
        Get.snackbar(
          'Error',
          'Failed to update expense: ${e.toString()}',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Get.theme.colorScheme.error,
          colorText: Get.theme.colorScheme.onError,
        );
      } finally {
        isLoading.value = false;
      }
    }
  }

  Future<void> deleteExpense(String expenseId) async {
    isLoading.value = true;
    try {
      final expenseToDelete = expenses.firstWhere((e) => e.id == expenseId);
      final amountToRemove = expenseToDelete.amount;

      final response = await _apiService.delete<Map<String, dynamic>>(
        '/expenses/$expenseId',
        requiresAuth: true,
      );

      if (response.success) {
        expenses.removeWhere((expense) => expense.id == expenseId);
        totalAmount.value -= amountToRemove;

        Get.snackbar(
          'Success',
          response.message,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Get.theme.colorScheme.primary,
          colorText: Get.theme.colorScheme.onPrimary,
        );
      } else {
        Get.snackbar(
          'Error',
          response.message,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Get.theme.colorScheme.error,
          colorText: Get.theme.colorScheme.onError,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to delete expense: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Get.theme.colorScheme.onError,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadExpenseSummary() async {
    try {
      final response = await _apiService.get<ExpenseSummaryResponse>(
        '/expenses/summary',
        requiresAuth: true,
        fromJson: (json) => ExpenseSummaryResponse.fromJson(json),
      );

      if (response.success && response.data != null) {
        totalAmount.value = response.data!.totalAmount;
      }
    } catch (e) {
      print('Failed to load summary: $e');
    }
  }

  void initializeFormForEdit(ExpenseModel expense) {
    selectedExpense.value = expense;
    titleController.text = expense.title;
    amountController.text = expense.amount.toString();
    categoryController.text = expense.category;
    selectedCategory.value = expense.category;
    selectedDate.value = expense.date;
    dateController.text = _formatDate(expense.date);
  }

  void clearForm() {
    titleController.clear();
    amountController.clear();
    categoryController.clear();
    selectedCategory.value = '';
    selectedDate.value = DateTime.now();
    dateController.text = _formatDate(DateTime.now());
    selectedExpense.value = null;
  }

  @override
  void onInit() {
    super.onInit();
    initializeDate();
    loadExpenses();
  }

  @override
  void onClose() {
    titleController.dispose();
    amountController.dispose();
    categoryController.dispose();
    dateController.dispose();
    super.onClose();
  }
}
