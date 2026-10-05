import 'package:flutter/material.dart';

class ExpenseAmountInput extends StatelessWidget {
  const ExpenseAmountInput({
    super.key,
    required this.controller,
  });

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: const InputDecoration(
        prefixText: '\$ ',
        label: Text('Amount'),
        border: OutlineInputBorder(),
      ),
    );
  }
}
