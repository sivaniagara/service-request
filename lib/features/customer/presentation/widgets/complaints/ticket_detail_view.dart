import 'package:flutter/material.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../data/models/dashboard_models.dart';
import 'audit_timeline.dart';
import 'complaint_stepper.dart';
import 'service_handler_info.dart';

class TicketDetailView extends StatelessWidget {
  final ServiceTicketDetail ticket;

  const TicketDetailView({super.key, required this.ticket});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSummaryCard(context),
          const SizedBox(height: 16),
          ServiceHandlerInfo(dealers: ticket.assignedDealer),
          const SizedBox(height: 16),
          ComplaintStepper(milestones: ticket.stepperMilestones),
          const SizedBox(height: 16),
          AuditTimeline(events: ticket.timelineEvents),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.line, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: AppColors.navy900.withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  '#${ticket.ticketNumber} — ${ticket.title}',
                  style: textTheme.headlineMedium?.copyWith(
                    fontSize: 19,
                    color: AppColors.navy900,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.bg,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  ticket.issueCategory,
                  style: textTheme.labelLarge?.copyWith(
                    fontSize: 10,
                    color: AppColors.ink600,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            ticket.description,
            style: textTheme.bodyMedium?.copyWith(
              color: AppColors.ink600,
              fontSize: 13,
              height: 1.6,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.bg.withOpacity(0.4),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.line.withOpacity(0.8)),
            ),
            child: Row(
              children: [
                _SummaryItem(
                  label: 'STATUS',
                  value: ticket.status.toUpperCase(),
                  valueColor: AppColors.blue500,
                  icon: Icons.info_outline,
                ),
                const _VerticalDivider(),
                _SummaryItem(
                  label: 'PRIORITY',
                  value: ticket.priority.toUpperCase(),
                  valueColor: AppColors.orange500,
                  icon: Icons.priority_high,
                ),
                const _VerticalDivider(),
                _SummaryItem(
                  label: 'SITE LOCATION',
                  value: ticket.siteLocation,
                  icon: Icons.location_on_outlined,
                ),
                const _VerticalDivider(),
                _SummaryItem(
                  label: 'RAISED ON',
                  value: 'Aug 20, 2026',
                  icon: Icons.calendar_today_outlined,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryItem extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;
  final IconData icon;

  const _SummaryItem({
    required this.label,
    required this.value,
    this.valueColor,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 11, color: AppColors.ink400),
              const SizedBox(width: 6),
              Text(
                label,
                style: textTheme.labelLarge?.copyWith(
                  fontSize: 8.5,
                  color: AppColors.ink400,
                  letterSpacing: 0.8,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w900,
              color: valueColor ?? AppColors.ink900,
              fontSize: 12.5,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _VerticalDivider extends StatelessWidget {
  const _VerticalDivider();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 34,
      width: 1.5,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: AppColors.line,
        borderRadius: BorderRadius.circular(1),
      ),
    );
  }
}
