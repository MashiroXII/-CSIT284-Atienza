import 'package:flutter/material.dart';
import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/widgets/expenses_list/expense_item.dart';

class ExpensesList extends StatelessWidget {
  const ExpensesList({
    super.key,
    required this.expenses,
    required this.onRemoveExpense,
    this.onEditExpense,
  });

  final List<Expense> expenses;
  final void Function(Expense expense) onRemoveExpense;
  final void Function(Expense expense)? onEditExpense;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListView.builder(
      itemCount: expenses.length,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemBuilder: (ctx, index) {
        final expense = expenses[index];
        return Dismissible(
          key: ValueKey(expense.id),
          background: Container(
            margin: EdgeInsets.only(
              bottom: theme.cardTheme.margin?.vertical ?? 12,
            ),
            decoration: BoxDecoration(
              color: theme.colorScheme.error.withValues(alpha: 0.85),
              borderRadius: BorderRadius.circular(16),
            ),
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Icon(
                  Icons.delete_outline_rounded,
                  color: theme.colorScheme.onError,
                  size: 28,
                ),
                const SizedBox(width: 8),
                Text(
                  'Delete',
                  style: TextStyle(
                    color: theme.colorScheme.onError,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          secondaryBackground: Container(
            margin: EdgeInsets.only(
              bottom: theme.cardTheme.margin?.vertical ?? 12,
            ),
            decoration: BoxDecoration(
              color: theme.colorScheme.error.withValues(alpha: 0.85),
              borderRadius: BorderRadius.circular(16),
            ),
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'Delete',
                  style: TextStyle(
                    color: theme.colorScheme.onError,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  Icons.delete_outline_rounded,
                  color: theme.colorScheme.onError,
                  size: 28,
                ),
              ],
            ),
          ),
          onDismissed: (direction) {
            onRemoveExpense(expense);
          },
          child: Padding(
            padding: const EdgeInsets.only(bottom: 4.0),
            child: ExpenseItem(
              expense: expense,
              onTap: () => onEditExpense?.call(expense),
            ),
          ),
        );
      },
    );
  }
}
