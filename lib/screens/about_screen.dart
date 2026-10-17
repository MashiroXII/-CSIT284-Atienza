import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('About App'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.account_balance_wallet_rounded,
                size: 64,
                color: theme.colorScheme.onPrimaryContainer,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Expense Tracker App',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Version 1.0.0',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.outline,
              ),
            ),
            const SizedBox(height: 24),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAlignment.start,
                  children: [
                    Text(
                      'About This Application',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Expense Tracker is a cross-platform mobile application designed to help users track personal finances, manage monthly budgets, analyze category spending, and maintain financial clarity.',
                      style: theme.textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Column(
                children: [
                  ListTile(
                    leading: Icon(Icons.check_circle_outline_rounded),
                    title: Text('Cross-Screen Navigation'),
                    subtitle: Text('Built using Section 8 Navigator and Named Routes'),
                  ),
                  Divider(height: 1),
                  ListTile(
                    leading: Icon(Icons.auto_graph_rounded),
                    title: Text('Analytics & Visual Charts'),
                    subtitle: Text('Category spending breakdown bar graph'),
                  ),
                  Divider(height: 1),
                  ListTile(
                    leading: Icon(Icons.devices_rounded),
                    title: Text('Responsive & Adaptive'),
                    subtitle: Text('Supports phone, tablet, portrait, and landscape views'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
