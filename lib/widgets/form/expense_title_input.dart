import 'package:flutter/material.dart';

class ExpenseTitleInput extends StatelessWidget {
  const ExpenseTitleInput({
    super.key,
    required this.controller,
  });

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLength: 50,
      decoration: const InputDecoration(
        label: Text('Title'),
        hintText: 'e.g. Groceries',
        border: OutlineInputBorder(),
      ),
    );
  }
}
