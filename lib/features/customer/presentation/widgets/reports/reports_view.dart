import 'package:flutter/material.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../data/models/dashboard_models.dart';
import 'report_history_table.dart';
import 'requests_over_time_chart.dart';

class ReportsView extends StatelessWidget {
  final CustomerReport report;

  const ReportsView({super.key, required this.report});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'My Service Request Report',
                    style: textTheme.headlineMedium?.copyWith(fontSize: 18),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'A summary of the service requests you\'ve raised and their resolution turnaround',
                    style: textTheme.bodyMedium?.copyWith(color: AppColors.ink400, fontSize: 12),
                  ),
                ],
              ),
              Row(
                children: [
                  _TimeframeButton(label: '3M', isActive: false),
                  const SizedBox(width: 8),
                  _TimeframeButton(label: '6M', isActive: false),
                  const SizedBox(width: 8),
                  _TimeframeButton(label: '1Y', isActive: true),
                  const SizedBox(width: 16),
                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.file_download_outlined, size: 16),
                    label: const Text('Download PDF'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.navy900,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          const RequestsOverTimeChart(),
          const SizedBox(height: 32),
          const ReportHistoryTable(),
        ],
      ),
    );
  }
}

class _TimeframeButton extends StatelessWidget {
  final String label;
  final bool isActive;
  const _TimeframeButton({required this.label, required this.isActive});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isActive ? AppColors.blue100 : Colors.transparent,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isActive ? AppColors.blue500 : AppColors.ink600,
          fontWeight: FontWeight.bold,
          fontSize: 11,
        ),
      ),
    );
  }
}
