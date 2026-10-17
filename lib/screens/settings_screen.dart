import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({
    super.key,
    required this.budgetLimit,
    required this.onUpdateBudget,
    required this.currentThemeMode,
    required this.onToggleTheme,
    required this.onResetExpenses,
  });

  final double budgetLimit;
  final void Function(double newBudget) onUpdateBudget;
  final ThemeMode currentThemeMode;
  final VoidCallback onToggleTheme;
  final VoidCallback onResetExpenses;

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late final TextEditingController _budgetController;

  @override
  void initState() {
    super.initState();
    _budgetController = TextEditingController(
      text: widget.budgetLimit.toStringAsFixed(0),
    );
  }

  void _saveBudget() {
    final value = double.tryParse(_budgetController.text);
    if (value != null && value > 0) {
      widget.onUpdateBudget(value);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Budget limit updated successfully!'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  void dispose() {
    _budgetController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings & Target'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Text(
            'Target Budget',
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _budgetController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      decoration: const InputDecoration(
                        prefixText: '\$ ',
                        label: Text('Monthly Budget Target'),
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: _saveBudget,
                    child: const Text('Save'),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Appearance & Preferences',
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Card(
            child: ListTile(
              leading: Icon(
                widget.currentThemeMode == ThemeMode.dark
                    ? Icons.dark_mode_rounded
                    : Icons.light_mode_rounded,
                color: theme.colorScheme.primary,
              ),
              title: const Text('Dark Mode'),
              subtitle: Text(
                widget.currentThemeMode == ThemeMode.dark
                    ? 'Dark Theme Active'
                    : 'Light Theme Active',
              ),
              trailing: Switch(
                value: widget.currentThemeMode == ThemeMode.dark,
                onChanged: (_) => widget.onToggleTheme(),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Data Management',
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Card(
            child: ListTile(
              leading: Icon(
                Icons.restore_rounded,
                color: theme.colorScheme.error,
              ),
              title: const Text('Reset Sample Expenses'),
              subtitle: const Text('Restore default sample dataset'),
              onTap: () {
                widget.onResetExpenses();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Expenses reset to default sample dataset.'),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
