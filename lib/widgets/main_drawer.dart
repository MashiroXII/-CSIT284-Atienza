import 'package:flutter/material.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({
    super.key,
    required this.onSelectScreen,
  });

  final void Function(String identifier) onSelectScreen;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  theme.colorScheme.primary,
                  theme.colorScheme.primaryContainer,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.onPrimary.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.account_balance_wallet_rounded,
                    size: 36,
                    color: theme.colorScheme.onPrimary,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAlignment.start,
                    children: [
                      Text(
                        'Expense Tracker',
                        style: theme.textTheme.titleLarge?.copyWith(
                          color: theme.colorScheme.onPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Smart Budget Manager',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onPrimary.withValues(alpha: 0.8),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.receipt_long_rounded,
              size: 24,
              color: theme.colorScheme.primary,
            ),
            title: Text(
              'Expenses',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            onTap: () {
              onSelectScreen('expenses');
            },
          ),
          ListTile(
            leading: Icon(
              Icons.bar_chart_rounded,
              size: 24,
              color: theme.colorScheme.primary,
            ),
            title: Text(
              'Analytics & Stats',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            onTap: () {
              onSelectScreen('analytics');
            },
          ),
          ListTile(
            leading: Icon(
              Icons.settings_rounded,
              size: 24,
              color: theme.colorScheme.primary,
            ),
            title: Text(
              'Settings & Target',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            onTap: () {
              onSelectScreen('settings');
            },
          ),
          const Divider(height: 24, indent: 16, endIndent: 16),
          ListTile(
            leading: Icon(
              Icons.info_outline_rounded,
              size: 24,
              color: theme.colorScheme.outline,
            ),
            title: Text(
              'About App',
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            onTap: () {
              onSelectScreen('about');
            },
          ),
        ],
      ),
    );
  }
}
