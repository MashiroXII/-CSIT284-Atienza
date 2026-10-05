import 'package:flutter/material.dart';
import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/widgets/adaptive/adaptive_dialog.dart';
import 'package:expense_tracker/widgets/form/expense_amount_input.dart';
import 'package:expense_tracker/widgets/form/expense_category_dropdown.dart';
import 'package:expense_tracker/widgets/form/expense_date_picker.dart';
import 'package:expense_tracker/widgets/form/expense_title_input.dart';

class NewExpense extends StatefulWidget {
  const NewExpense({
    super.key,
    required this.onAddExpense,
    this.expenseToEdit,
  });

  final void Function(Expense expense) onAddExpense;
  final Expense? expenseToEdit;

  @override
  State<NewExpense> createState() {
    return _NewExpenseState();
  }
}

class _NewExpenseState extends State<NewExpense> {
  late final TextEditingController _titleController;
  late final TextEditingController _amountController;
  DateTime? _selectedDate;
  Category _selectedCategory = Category.food;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(
      text: widget.expenseToEdit?.title ?? '',
    );
    _amountController = TextEditingController(
      text: widget.expenseToEdit?.amount.toString() ?? '',
    );
    _selectedDate = widget.expenseToEdit?.date ?? DateTime.now();
    _selectedCategory = widget.expenseToEdit?.category ?? Category.food;
  }

  void _presentDatePicker() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 1, now.month, now.day);
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? now,
      firstDate: firstDate,
      lastDate: now,
    );
    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  void _submitExpenseData() {
    final enteredAmount = double.tryParse(_amountController.text);
    final amountIsInvalid = enteredAmount == null || enteredAmount <= 0;

    if (_titleController.text.trim().isEmpty ||
        amountIsInvalid ||
        _selectedDate == null) {
      AdaptiveDialog.showAlert(
        context: context,
        title: 'Invalid Input',
        message: 'Please make sure a valid title, amount, date and category were entered.',
      );
      return;
    }

    final newOrUpdatedExpense = Expense(
      id: widget.expenseToEdit?.id,
      title: _titleController.text.trim(),
      amount: enteredAmount,
      date: _selectedDate!,
      category: _selectedCategory,
    );

    widget.onAddExpense(newOrUpdatedExpense);
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final keyboardSpace = MediaQuery.of(context).viewInsets.bottom;
    final theme = Theme.of(context);
    final isEditing = widget.expenseToEdit != null;

    return LayoutBuilder(
      builder: (ctx, constraints) {
        final width = constraints.maxWidth;

        return SizedBox(
          height: double.infinity,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.fromLTRB(16, 16, 16, keyboardSpace + 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  Text(
                    isEditing ? 'Edit Expense' : 'Add New Expense',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (width >= 600)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: ExpenseTitleInput(controller: _titleController),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: ExpenseAmountInput(controller: _amountController),
                        ),
                      ],
                    )
                  else ...[
                    ExpenseTitleInput(controller: _titleController),
                    const SizedBox(height: 12),
                  ],
                  if (width >= 600)
                    Row(
                      children: [
                        ExpenseCategoryDropdown(
                          selectedCategory: _selectedCategory,
                          onCategoryChanged: (value) {
                            if (value == null) return;
                            setState(() {
                              _selectedCategory = value;
                            });
                          },
                        ),
                        const Spacer(),
                        ExpenseDatePicker(
                          selectedDate: _selectedDate,
                          onSelectDate: _presentDatePicker,
                        ),
                      ],
                    )
                  else
                    Row(
                      children: [
                        Expanded(
                          child: ExpenseAmountInput(controller: _amountController),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: ExpenseDatePicker(
                            selectedDate: _selectedDate,
                            onSelectDate: _presentDatePicker,
                          ),
                        ),
                      ],
                    ),
                  const SizedBox(height: 16),
                  if (width < 600)
                    Row(
                      children: [
                        ExpenseCategoryDropdown(
                          selectedCategory: _selectedCategory,
                          onCategoryChanged: (value) {
                            if (value == null) return;
                            setState(() {
                              _selectedCategory = value;
                            });
                          },
                        ),
                        const Spacer(),
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Cancel'),
                        ),
                        ElevatedButton.icon(
                          onPressed: _submitExpenseData,
                          icon: Icon(isEditing ? Icons.check : Icons.add),
                          label: Text(isEditing ? 'Save' : 'Save Expense'),
                        ),
                      ],
                    )
                  else
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Cancel'),
                        ),
                        ElevatedButton.icon(
                          onPressed: _submitExpenseData,
                          icon: Icon(isEditing ? Icons.check : Icons.add),
                          label: Text(isEditing ? 'Save' : 'Save Expense'),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
