import 'package:flutter/material.dart';
import 'package:expense_tracker/models/expense.dart';

class ExpenseCategoryDropdown extends StatelessWidget {
  const ExpenseCategoryDropdown({
    super.key,
    required this.selectedCategory,
    required this.onCategoryChanged,
  });

  final Category selectedCategory;
  final void Function(Category? category) onCategoryChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DropdownButton<Category>(
      value: selectedCategory,
      items: Category.values
          .map(
            (category) => DropdownMenuItem(
              value: category,
              child: Row(
                children: [
                  Icon(
                    categoryIcons[category],
                    size: 20,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(width: 8),
                  Text(categoryNames[category] ?? ''),
                ],
              ),
            ),
          )
          .toList(),
      onChanged: onCategoryChanged,
    );
  }
}
