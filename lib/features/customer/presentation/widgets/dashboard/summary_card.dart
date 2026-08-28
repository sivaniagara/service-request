import 'package:flutter/material.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../data/models/dashboard_models.dart';

class SummaryCard extends StatelessWidget {
  final DashboardMetrics metrics;

  const SummaryCard({super.key, required this.metrics});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.navy900,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'SERVICE EXPERIENCE SUMMARY',
                  style: textTheme.labelLarge?.copyWith(color: Colors.white70),
                ),
                const SizedBox(height: 8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      metrics.overallSatisfactionRating.toStringAsFixed(1),
                      style: textTheme.headlineMedium?.copyWith(
                        color: Colors.white,
                        fontSize: 36,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(Icons.star, color: AppColors.orange500, size: 24),
                    const SizedBox(width: 8),
                    Text(
                      'Overall satisfaction rate',
                      style: textTheme.bodyMedium?.copyWith(color: Colors.white60),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: _MetricItem(
              label: 'Requests Raised',
              value: metrics.totalComplaintsRaised.toString(),
              valueColor: Colors.white,
            ),
          ),
          Expanded(
            child: _MetricItem(
              label: 'Resolved',
              value: metrics.resolvedCount.toString(),
              valueColor: AppColors.green500,
            ),
          ),
          Expanded(
            child: _MetricItem(
              label: 'Open Tickets',
              value: (metrics.totalComplaintsRaised - metrics.resolvedCount).toString(),
              valueColor: AppColors.orange500,
            ),
          ),
        ],
      ),
    );
  }
}

class _MetricItem extends StatelessWidget {
  final String label;
  final String value;
  final Color valueColor;

  const _MetricItem({
    required this.label,
    required this.value,
    required this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: textTheme.labelLarge?.copyWith(color: Colors.white60, fontSize: 10),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: textTheme.titleLarge?.copyWith(
            color: valueColor,
            fontSize: 24,
          ),
        ),
      ],
    );
  }
}
