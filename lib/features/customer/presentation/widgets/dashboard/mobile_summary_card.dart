import 'package:flutter/material.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../data/models/dashboard_models.dart';

/// A phone-width stats card for the customer dashboard.
///
/// The desktop [SummaryCard] packs a rating block plus three metric
/// columns into a single Row — on a ~375px phone that squeezes every
/// label down to unreadable widths. This version stacks the rating on
/// its own row (room to breathe) and puts the three counts into equal
/// pill-style tiles underneath.
class MobileSummaryCard extends StatelessWidget {
  final DashboardMetrics metrics;

  const MobileSummaryCard({super.key, required this.metrics});

  @override
  Widget build(BuildContext context) {
    final openCount = metrics.totalComplaintsRaised - metrics.resolvedCount;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.navy900, AppColors.navy800],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.navy900.withOpacity(0.25),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.insights_rounded, size: 14, color: Colors.white70),
              ),
              const SizedBox(width: 8),
              Text(
                'SERVICE EXPERIENCE',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.6),
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.8,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                metrics.overallSatisfactionRating.toStringAsFixed(1),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 40,
                  fontWeight: FontWeight.w900,
                  height: 1,
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(bottom: 6, left: 4, right: 6),
                child: Icon(Icons.star_rounded, color: AppColors.orange500, size: 22),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 9),
                  child: Text(
                    'Overall satisfaction rating',
                    style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 12, fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: _MobileMetricTile(
                  label: 'Raised',
                  value: metrics.totalComplaintsRaised.toString(),
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _MobileMetricTile(
                  label: 'Resolved',
                  value: metrics.resolvedCount.toString(),
                  color: AppColors.green500,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _MobileMetricTile(
                  label: 'Open',
                  value: openCount.toString(),
                  color: AppColors.orange500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MobileMetricTile extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _MobileMetricTile({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.06),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(color: color, fontSize: 20, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(color: Colors.white.withOpacity(0.55), fontSize: 10, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}