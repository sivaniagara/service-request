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
              if (ticket.issueCategory.isNotEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.bg,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    ticket.issueCategory.join(', '),
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
            ticket.description ?? 'No description provided',
            style: textTheme.bodyMedium?.copyWith(
              color: AppColors.ink600,
              fontSize: 13,
              height: 1.6,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.bg.withOpacity(0.4),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.line.withOpacity(0.8)),
            ),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final items = [
                  _SummaryItem(
                    label: 'STATUS',
                    value: ticket.status.toUpperCase(),
                    valueColor: AppColors.blue500,
                    icon: Icons.info_outline,
                  ),
                  _SummaryItem(
                    label: 'PRIORITY',
                    value: ticket.priority.toUpperCase(),
                    valueColor: AppColors.orange500,
                    icon: Icons.priority_high,
                  ),
                  _SummaryItem(
                    label: 'SITE LOCATION',
                    value: ticket.siteLocation ?? 'Not specified',
                    icon: Icons.location_on_outlined,
                  ),
                  _SummaryItem(
                    label: 'RAISED ON',
                    value: '${ticket.createdAt.day} ${_getMonth(ticket.createdAt.month)}, ${ticket.createdAt.year}',
                    icon: Icons.calendar_today_outlined,
                  ),
                ];

                // Below ~560px (phones) a single row of four items with
                // three dividers has no room to show real values, so we
                // switch to a two-column grid instead.
                // Note: _SummaryItem's own root widget is already an
                // Expanded, so it can drop straight into these Rows as
                // a flex child — don't wrap it in another Expanded.
                if (constraints.maxWidth < 560) {
                  return Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          items[0],
                          const SizedBox(width: 16),
                          items[1],
                        ],
                      ),
                      const SizedBox(height: 18),
                      const Divider(height: 1, color: AppColors.line),
                      const SizedBox(height: 18),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          items[2],
                          const SizedBox(width: 16),
                          items[3],
                        ],
                      ),
                    ],
                  );
                }

                return Row(
                  children: [
                    items[0],
                    const _VerticalDivider(),
                    items[1],
                    const _VerticalDivider(),
                    items[2],
                    const _VerticalDivider(),
                    items[3],
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  String _getMonth(int month) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return months[month - 1];
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
              fontSize: 10,
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