import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../controllers/expense_controller.dart';
import '../widgets/app_button.dart';
import '../widgets/app_text_field.dart';

class ExpenseFormScreen extends StatelessWidget {
  final bool isEditing;

  const ExpenseFormScreen({super.key, this.isEditing = false});

  @override
  Widget build(BuildContext context) {
    final ExpenseController expenseController = Get.find<ExpenseController>();

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Expense' : 'Add Expense'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: expenseController.expenseFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AppTextField(
                  controller: expenseController.titleController,
                  label: 'Title',
                  hint: 'Enter expense title',
                  textInputAction: TextInputAction.next,
                  validator: expenseController.validateTitle,
                  prefixIcon: Icons.title_outlined,
                ),
                const SizedBox(height: 20),
                AppTextField(
                  controller: expenseController.amountController,
                  label: 'Amount',
                  hint: 'Enter amount',
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  textInputAction: TextInputAction.next,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                  ],
                  validator: expenseController.validateAmount,
                  prefixIcon: Icons.attach_money_outlined,
                ),
                const SizedBox(height: 20),
                Obx(
                  () => DropdownButtonFormField<String>(
                    value: expenseController.selectedCategory.value.isEmpty
                        ? null
                        : expenseController.selectedCategory.value,
                    decoration: InputDecoration(
                      labelText: 'Category',
                      hintText: 'Select category',
                      prefixIcon: const Icon(Icons.category_outlined),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.primary,
                          width: 2,
                        ),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                    ),
                    items: expenseController.categories.map((category) {
                      return DropdownMenuItem<String>(
                        value: category,
                        child: Text(category),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        expenseController.selectedCategory.value = value;
                        expenseController.categoryController.text = value;
                      }
                    },
                    validator: expenseController.validateCategory,
                  ),
                ),
                const SizedBox(height: 20),
                AppTextField(
                  controller: expenseController.dateController,
                  label: 'Date',
                  hint: 'Select date',
                  readOnly: true,
                  validator: expenseController.validateDate,
                  prefixIcon: Icons.calendar_today_outlined,
                  suffixIcon: const Icon(Icons.arrow_drop_down),
                  onTap: () => expenseController.selectDate(context),
                ),

                const SizedBox(height: 32),
                Obx(
                  () => AppButton(
                    text: isEditing ? 'Update Expense' : 'Add Expense',
                    onPressed: isEditing
                        ? expenseController.updateExpense
                        : expenseController.addExpense,
                    loading: expenseController.isLoading.value,
                  ),
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () {
                    expenseController.clearForm();
                    Get.back();
                  },
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
