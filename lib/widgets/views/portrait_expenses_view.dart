import 'package:flutter/material.dart';
import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/widgets/budget_card.dart';
import 'package:expense_tracker/widgets/category_filter_bar.dart';
import 'package:expense_tracker/widgets/chart/chart.dart';

class PortraitExpensesView extends StatelessWidget {
  const PortraitExpensesView({
    super.key,
    required this.totalSpent,
    required this.budgetLimit,
    required this.expenseCount,
    required this.registeredExpenses,
    required this.selectedCategoryFilter,
    required this.searchQuery,
    required this.mainContent,
    required this.onSetBudget,
    required this.onSelectCategory,
    required this.onSearchChanged,
  });

  final double totalSpent;
  final double budgetLimit;
  final int expenseCount;
  final List<Expense> registeredExpenses;
  final Category? selectedCategoryFilter;
  final String searchQuery;
  final Widget mainContent;
  final VoidCallback onSetBudget;
  final void Function(Category? category) onSelectCategory;
  final void Function(String query) onSearchChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        BudgetCard(
          totalSpent: totalSpent,
          budgetLimit: budgetLimit,
          expenseCount: expenseCount,
          onSetBudget: onSetBudget,
        ),
        Chart(expenses: registeredExpenses),
        CategoryFilterBar(
          selectedCategory: selectedCategoryFilter,
          onSelectCategory: onSelectCategory,
          searchQuery: searchQuery,
          onSearchChanged: onSearchChanged,
        ),
        const SizedBox(height: 4),
        Expanded(
          child: mainContent,
        ),
      ],
    );
  }
}
