import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

final formatter = DateFormat.yMd();

class ExpenseDatePicker extends StatelessWidget {
  const ExpenseDatePicker({
    super.key,
    required this.selectedDate,
    required this.onSelectDate,
  });

  final DateTime? selectedDate;
  final VoidCallback onSelectDate;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          selectedDate == null
              ? 'No Date Selected'
              : formatter.format(selectedDate!),
          style: theme.textTheme.bodyMedium,
        ),
        IconButton(
          onPressed: onSelectDate,
          icon: const Icon(Icons.calendar_month_rounded),
        ),
      ],
    );
  }
}
