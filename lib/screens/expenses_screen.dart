import 'package:flutter/material.dart';
import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/screens/expense_details_screen.dart';
import 'package:expense_tracker/widgets/common/empty_state.dart';
import 'package:expense_tracker/widgets/expenses_list/expenses_list.dart';
import 'package:expense_tracker/widgets/new_expense.dart';
import 'package:expense_tracker/widgets/views/landscape_expenses_view.dart';
import 'package:expense_tracker/widgets/views/portrait_expenses_view.dart';

enum SortOption { dateDescending, dateAscending, amountDescending, amountAscending }

class ExpensesScreen extends StatefulWidget {
  const ExpensesScreen({
    super.key,
    required this.registeredExpenses,
    required this.budgetLimit,
    required this.onAddOrUpdateExpense,
    required this.onRemoveExpense,
    required this.onUpdateBudget,
    required this.onToggleTheme,
    required this.currentThemeMode,
  });

  final List<Expense> registeredExpenses;
  final double budgetLimit;
  final void Function(Expense expense) onAddOrUpdateExpense;
  final void Function(Expense expense) onRemoveExpense;
  final void Function(double newBudget) onUpdateBudget;
  final VoidCallback onToggleTheme;
  final ThemeMode currentThemeMode;

  @override
  State<ExpensesScreen> createState() {
    return _ExpensesScreenState();
  }
}

class _ExpensesScreenState extends State<ExpensesScreen> {
  Category? _selectedCategoryFilter;
  String _searchQuery = '';
  SortOption _currentSort = SortOption.dateDescending;

  void _openAddExpenseOverlay() {
    showModalBottomSheet(
      useSafeArea: true,
      isScrollControlled: true,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => NewExpense(onAddExpense: widget.onAddOrUpdateExpense),
    );
  }

  void _navigateToExpenseDetails(Expense expense) async {
    final result = await Navigator.of(context).push<dynamic>(
      MaterialPageRoute(
        builder: (ctx) => ExpenseDetailsScreen(expense: expense),
      ),
    );

    if (result == 'delete') {
      widget.onRemoveExpense(expense);
    } else if (result is Expense) {
      widget.onAddOrUpdateExpense(result);
    }
  }

  void _openSetBudgetDialog() {
    final controller = TextEditingController(
      text: widget.budgetLimit.toStringAsFixed(0),
    );

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text('Set Monthly Budget Target'),
        content: TextField(
          controller: controller,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: const InputDecoration(
            prefixText: '\$ ',
            label: Text('Budget Limit'),
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final newBudget = double.tryParse(controller.text);
              if (newBudget != null && newBudget > 0) {
                widget.onUpdateBudget(newBudget);
              }
              Navigator.pop(ctx);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  List<Expense> get _filteredAndSortedExpenses {
    var list = widget.registeredExpenses.where((expense) {
      final matchesCategory = _selectedCategoryFilter == null ||
          expense.category == _selectedCategoryFilter;
      final matchesSearch = _searchQuery.isEmpty ||
          expense.title.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();

    switch (_currentSort) {
      case SortOption.dateDescending:
        list.sort((a, b) => b.date.compareTo(a.date));
        break;
      case SortOption.dateAscending:
        list.sort((a, b) => a.date.compareTo(b.date));
        break;
      case SortOption.amountDescending:
        list.sort((a, b) => b.amount.compareTo(a.amount));
        break;
      case SortOption.amountAscending:
        list.sort((a, b) => a.amount.compareTo(b.amount));
        break;
    }

    return list;
  }

  double get _totalSpent {
    return widget.registeredExpenses.fold(0.0, (sum, item) => sum + item.amount);
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final theme = Theme.of(context);
    final displayedExpenses = _filteredAndSortedExpenses;

    Widget mainContent = EmptyState(
      title: 'No expenses found',
      message: 'Try adjusting your search query or add a new expense item.',
      icon: Icons.receipt_long_outlined,
      actionLabel: 'Add Expense',
      onActionPressed: _openAddExpenseOverlay,
    );

    if (displayedExpenses.isNotEmpty) {
      mainContent = ExpensesList(
        expenses: displayedExpenses,
        onRemoveExpense: widget.onRemoveExpense,
        onEditExpense: _navigateToExpenseDetails,
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.account_balance_wallet_rounded,
                size: 20,
                color: theme.colorScheme.onPrimaryContainer,
              ),
            ),
            const SizedBox(width: 10),
            const Text('Expense Tracker'),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Toggle Light/Dark Theme',
            onPressed: widget.onToggleTheme,
            icon: Icon(
              widget.currentThemeMode == ThemeMode.dark
                  ? Icons.light_mode_rounded
                  : Icons.dark_mode_rounded,
            ),
          ),
          PopupMenuButton<SortOption>(
            tooltip: 'Sort Expenses',
            icon: const Icon(Icons.sort_rounded),
            onSelected: (option) {
              setState(() {
                _currentSort = option;
              });
            },
            itemBuilder: (context) => const [
              PopupMenuItem(
                value: SortOption.dateDescending,
                child: Row(
                  children: [
                    Icon(Icons.calendar_today, size: 18),
                    SizedBox(width: 8),
                    Text('Newest First'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: SortOption.dateAscending,
                child: Row(
                  children: [
                    Icon(Icons.history, size: 18),
                    SizedBox(width: 8),
                    Text('Oldest First'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: SortOption.amountDescending,
                child: Row(
                  children: [
                    Icon(Icons.arrow_downward, size: 18),
                    SizedBox(width: 8),
                    Text('Highest Amount'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: SortOption.amountAscending,
                child: Row(
                  children: [
                    Icon(Icons.arrow_upward, size: 18),
                    SizedBox(width: 8),
                    Text('Lowest Amount'),
                  ],
                ),
              ),
            ],
          ),
          IconButton(
            tooltip: 'Add New Expense',
            onPressed: _openAddExpenseOverlay,
            icon: const Icon(Icons.add_rounded),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openAddExpenseOverlay,
        icon: const Icon(Icons.add_rounded),
        label: const Text('Add Expense'),
      ),
      body: width < 600
          ? PortraitExpensesView(
              totalSpent: _totalSpent,
              budgetLimit: widget.budgetLimit,
              expenseCount: widget.registeredExpenses.length,
              registeredExpenses: widget.registeredExpenses,
              selectedCategoryFilter: _selectedCategoryFilter,
              searchQuery: _searchQuery,
              mainContent: mainContent,
              onSetBudget: _openSetBudgetDialog,
              onSelectCategory: (category) {
                setState(() {
                  _selectedCategoryFilter = category;
                });
              },
              onSearchChanged: (query) {
                setState(() {
                  _searchQuery = query;
                });
              },
            )
          : LandscapeExpensesView(
              totalSpent: _totalSpent,
              budgetLimit: widget.budgetLimit,
              expenseCount: widget.registeredExpenses.length,
              registeredExpenses: widget.registeredExpenses,
              selectedCategoryFilter: _selectedCategoryFilter,
              searchQuery: _searchQuery,
              mainContent: mainContent,
              onSetBudget: _openSetBudgetDialog,
              onSelectCategory: (category) {
                setState(() {
                  _selectedCategoryFilter = category;
                });
              },
              onSearchChanged: (query) {
                setState(() {
                  _searchQuery = query;
                });
              },
            ),
    );
  }
}
