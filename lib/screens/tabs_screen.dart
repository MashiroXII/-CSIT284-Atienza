import 'package:flutter/material.dart';
import 'package:expense_tracker/data/dummy_expenses.dart';
import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/screens/about_screen.dart';
import 'package:expense_tracker/screens/analytics_screen.dart';
import 'package:expense_tracker/screens/expenses_screen.dart';
import 'package:expense_tracker/screens/settings_screen.dart';
import 'package:expense_tracker/widgets/main_drawer.dart';

class TabsScreen extends StatefulWidget {
  const TabsScreen({
    super.key,
    required this.onToggleTheme,
    required this.currentThemeMode,
  });

  final VoidCallback onToggleTheme;
  final ThemeMode currentThemeMode;

  @override
  State<TabsScreen> createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  int _selectedPageIndex = 0;
  final List<Expense> _registeredExpenses = List.from(dummyExpenses);
  double _budgetLimit = 1000.0;

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
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

  void _resetExpenses() {
    setState(() {
      _registeredExpenses.clear();
      _registeredExpenses.addAll(dummyExpenses);
    });
  }

  void _setDrawerScreen(String identifier) {
    Navigator.of(context).pop(); // Close drawer
    if (identifier == 'expenses') {
      setState(() {
        _selectedPageIndex = 0;
      });
    } else if (identifier == 'analytics') {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (ctx) => AnalyticsScreen(expenses: _registeredExpenses),
        ),
      );
    } else if (identifier == 'settings') {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (ctx) => SettingsScreen(
            budgetLimit: _budgetLimit,
            onUpdateBudget: (newBudget) {
              setState(() {
                _budgetLimit = newBudget;
              });
            },
            currentThemeMode: widget.currentThemeMode,
            onToggleTheme: widget.onToggleTheme,
            onResetExpenses: _resetExpenses,
          ),
        ),
      );
    } else if (identifier == 'about') {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (ctx) => const AboutScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget activePage = ExpensesScreen(
      registeredExpenses: _registeredExpenses,
      budgetLimit: _budgetLimit,
      onAddOrUpdateExpense: _addOrUpdateExpense,
      onRemoveExpense: _removeExpense,
      onUpdateBudget: (newBudget) {
        setState(() {
          _budgetLimit = newBudget;
        });
      },
      onToggleTheme: widget.onToggleTheme,
      currentThemeMode: widget.currentThemeMode,
    );

    if (_selectedPageIndex == 1) {
      activePage = AnalyticsScreen(expenses: _registeredExpenses);
    } else if (_selectedPageIndex == 2) {
      activePage = SettingsScreen(
        budgetLimit: _budgetLimit,
        onUpdateBudget: (newBudget) {
          setState(() {
            _budgetLimit = newBudget;
          });
        },
        currentThemeMode: widget.currentThemeMode,
        onToggleTheme: widget.onToggleTheme,
        onResetExpenses: _resetExpenses,
      );
    }

    return Scaffold(
      drawer: MainDrawer(onSelectScreen: _setDrawerScreen),
      body: activePage,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedPageIndex,
        onTap: _selectPage,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long_rounded),
            label: 'Expenses',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart_rounded),
            label: 'Analytics',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_rounded),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
