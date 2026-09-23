import 'package:expense_tracker/models/expense.dart';

final dummyExpenses = [
  Expense(
    title: 'Grocery Shopping',
    amount: 64.80,
    date: DateTime.now().subtract(const Duration(days: 1)),
    category: Category.food,
  ),
  Expense(
    title: 'Flutter Masterclass',
    amount: 19.99,
    date: DateTime.now().subtract(const Duration(days: 2)),
    category: Category.work,
  ),
  Expense(
    title: 'Cinema Movie Tickets',
    amount: 28.50,
    date: DateTime.now().subtract(const Duration(days: 3)),
    category: Category.leisure,
  ),
  Expense(
    title: 'Flight to Tokyo',
    amount: 450.00,
    date: DateTime.now().subtract(const Duration(days: 5)),
    category: Category.travel,
  ),
  Expense(
    title: 'Electric & Internet Bill',
    amount: 112.30,
    date: DateTime.now().subtract(const Duration(days: 7)),
    category: Category.bills,
  ),
];
