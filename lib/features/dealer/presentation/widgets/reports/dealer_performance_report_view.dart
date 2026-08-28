import 'package:flutter/material.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../data/models/dealer_report_model.dart';
import 'report_header_widget.dart';
import 'weekly_trends_chart.dart';
import 'category_breakdown_section.dart';
import 'status_breakdown_donut_section.dart';

class DealerPerformanceReportView extends StatelessWidget {
  final DealerPerformanceReport report;

  const DealerPerformanceReportView({
    super.key,
    required this.report,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.line),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ReportHeaderWidget(header: report.header),
                const SizedBox(height: 20),
                WeeklyTrendsChart(trends: report.weeklyTrends),
                const SizedBox(height: 24),
                const Divider(height: 1, color: AppColors.line),
                const SizedBox(height: 24),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 1,
                      child: CategoryBreakdownSection(breakdown: report.categoryBreakdown),
                    ),
                    const SizedBox(width: 32),
                    Expanded(
                      flex: 1,
                      child: StatusBreakdownDonutSection(breakdown: report.statusBreakdown),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
