import 'package:flutter/material.dart';
import 'package:expense_tracker/data/dummy_expenses.dart';
import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/widgets/common/empty_state.dart';
import 'package:expense_tracker/widgets/expenses_list/expenses_list.dart';
import 'package:expense_tracker/widgets/new_expense.dart';
import 'package:expense_tracker/widgets/views/landscape_expenses_view.dart';
import 'package:expense_tracker/widgets/views/portrait_expenses_view.dart';

enum SortOption { dateDescending, dateAscending, amountDescending, amountAscending }

class Expenses extends StatefulWidget {
  const Expenses({
    super.key,
    required this.onToggleTheme,
    required this.currentThemeMode,
  });

  final VoidCallback onToggleTheme;
  final ThemeMode currentThemeMode;

  @override
  State<Expenses> createState() {
    return _ExpensesState();
  }
}

class _ExpensesState extends State<Expenses> {
  final List<Expense> _registeredExpenses = List.from(dummyExpenses);
  Category? _selectedCategoryFilter;
  String _searchQuery = '';
  double _budgetLimit = 1000.0;
  SortOption _currentSort = SortOption.dateDescending;

  void _openAddExpenseOverlay() {
    showModalBottomSheet(
      useSafeArea: true,
      isScrollControlled: true,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => NewExpense(onAddExpense: _addOrUpdateExpense),
    );
  }

  void _openEditExpenseOverlay(Expense expense) {
    showModalBottomSheet(
      useSafeArea: true,
      isScrollControlled: true,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => NewExpense(
        onAddExpense: _addOrUpdateExpense,
        expenseToEdit: expense,
      ),
    );
  }

  void _addOrUpdateExpense(Expense expense) {
    setState(() {
      final existingIndex = _registeredExpenses.indexWhere((e) => e.id == expense.id);
      if (existingIndex >= 0) {
        _registeredExpenses[existingIndex] = expense;
      } else {
        _registeredExpenses.insert(0, expense);
      }
    });
  }

  void _removeExpense(Expense expense) {
    final expenseIndex = _registeredExpenses.indexOf(expense);
    setState(() {
      _registeredExpenses.remove(expense);
    });

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 4),
        content: Text('Deleted "${expense.title}"'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(() {
              _registeredExpenses.insert(expenseIndex, expense);
            });
          },
        ),
      ),
    );
  }

  void _openSetBudgetDialog() {
    final controller = TextEditingController(
      text: _budgetLimit.toStringAsFixed(0),
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
                setState(() {
                  _budgetLimit = newBudget;
                });
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
    var list = _registeredExpenses.where((expense) {
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
    return _registeredExpenses.fold(0.0, (sum, item) => sum + item.amount);
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
        onRemoveExpense: _removeExpense,
        onEditExpense: _openEditExpenseOverlay,
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
              budgetLimit: _budgetLimit,
              expenseCount: _registeredExpenses.length,
              registeredExpenses: _registeredExpenses,
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
              budgetLimit: _budgetLimit,
              expenseCount: _registeredExpenses.length,
              registeredExpenses: _registeredExpenses,
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
