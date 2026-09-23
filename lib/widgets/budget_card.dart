import 'package:flutter/material.dart';

class BudgetCard extends StatelessWidget {
  const BudgetCard({
    super.key,
    required this.totalSpent,
    required this.budgetLimit,
    required this.expenseCount,
    required this.onSetBudget,
  });

  final double totalSpent;
  final double budgetLimit;
  final int expenseCount;
  final VoidCallback onSetBudget;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final progress = (budgetLimit > 0) ? (totalSpent / budgetLimit).clamp(0.0, 1.0) : 0.0;
    final isOverBudget = totalSpent > budgetLimit;
    final isNearLimit = progress >= 0.8 && !isOverBudget;

    Color statusColor = theme.colorScheme.primary;
    String statusText = 'On Track';
    IconData statusIcon = Icons.check_circle_outline_rounded;

    if (isOverBudget) {
      statusColor = theme.colorScheme.error;
      statusText = 'Over Budget!';
      statusIcon = Icons.warning_rounded;
    } else if (isNearLimit) {
      statusColor = Colors.orange;
      statusText = 'Near Limit';
      statusIcon = Icons.info_outline_rounded;
    }

    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors: [
              theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
              theme.colorScheme.surface,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Monthly Spending',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '\$${totalSpent.toStringAsFixed(2)}',
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                InkWell(
                  onTap: onSetBudget,
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: statusColor.withValues(alpha: 0.3)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(statusIcon, size: 16, color: statusColor),
                        const SizedBox(width: 4),
                        Text(
                          statusText,
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: statusColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(
                          Icons.edit_outlined,
                          size: 14,
                          color: statusColor,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 10,
                backgroundColor: theme.colorScheme.outlineVariant.withValues(alpha: 0.4),
                color: statusColor,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${(progress * 100).toStringAsFixed(0)}% of \$${budgetLimit.toStringAsFixed(0)} target',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                Text(
                  '$expenseCount ${expenseCount == 1 ? "Item" : "Items"}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
