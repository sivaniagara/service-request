import 'package:flutter/material.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../data/models/dashboard_models.dart';

class AuditTimeline extends StatelessWidget {
  final List<TimelineEvent> events;

  const AuditTimeline({super.key, required this.events});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.line, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
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
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: AppColors.blue100.withOpacity(0.5),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.history, size: 16, color: AppColors.blue500),
                      ),
                      const SizedBox(width: 10),
                      Text('Audit Timeline Log', style: textTheme.titleMedium?.copyWith(fontSize: 14)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Complete chronological history of the ticket',
                    style: textTheme.labelLarge?.copyWith(color: AppColors.ink400, fontWeight: FontWeight.normal, fontSize: 10),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.bg,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${events.length} EVENTS',
                  style: textTheme.labelLarge?.copyWith(
                    color: AppColors.ink400,
                    fontWeight: FontWeight.w900,
                    fontSize: 8.5,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 28),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: events.length,
            itemBuilder: (context, index) {
              final event = events[index];
              final isLast = index == events.length - 1;
              return _TimelineItem(event: event, isLast: isLast);
            },
          ),
        ],
      ),
    );
  }
}

class _TimelineItem extends StatelessWidget {
  final TimelineEvent event;
  final bool isLast;

  const _TimelineItem({required this.event, required this.isLast});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: AppColors.bg,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.line, width: 2),
                ),
                child: Center(
                  child: Icon(_getIcon(event.badgeType), size: 14, color: AppColors.ink600),
                ),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    color: AppColors.line,
                  ),
                ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(bottom: 24),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.bg.withOpacity(0.3),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.line),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        event.title,
                        style: textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w900,
                          fontSize: 12.5,
                          color: AppColors.navy900,
                        )
                      ),
                      const SizedBox(width: 10),
                      _RoleBadge(label: event.badgeType),
                      const Spacer(),
                      Text(
                        event.timestamp,
                        style: textTheme.labelLarge?.copyWith(color: AppColors.ink400, fontSize: 9.5),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    event.description,
                    style: textTheme.bodyMedium?.copyWith(
                      color: AppColors.ink600,
                      fontSize: 11.5,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(Icons.person_outline, size: 14, color: AppColors.ink400),
                      const SizedBox(width: 6),
                      Text(
                        'Logged by: ',
                        style: textTheme.labelLarge?.copyWith(
                          color: AppColors.ink400,
                          fontWeight: FontWeight.normal,
                          fontSize: 10,
                        ),
                      ),
                      Text(
                        event.actor,
                        style: textTheme.labelLarge?.copyWith(
                          color: AppColors.ink900,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getIcon(String badgeType) {
    switch (badgeType.toLowerCase()) {
      case 'customer':
      case 'create':
        return Icons.edit_note_outlined;
      case 'admin':
      case 'assignment':
        return Icons.assignment_ind_outlined;
      case 'dealer handle':
        return Icons.handyman_outlined;
      default:
        return Icons.notifications_none_outlined;
    }
  }
}

class _RoleBadge extends StatelessWidget {
  final String label;

  const _RoleBadge({required this.label});

  @override
  Widget build(BuildContext context) {
    Color color;
    switch (label.toLowerCase()) {
      case 'customer':
        color = AppColors.blue500;
        break;
      case 'admin':
        color = AppColors.purple500;
        break;
      case 'dealer handle':
        color = AppColors.orange500;
        break;
      default:
        color = AppColors.ink400;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Text(
        label.toUpperCase(),
        style: TextStyle(
          color: color,
          fontSize: 7.5,
          fontWeight: FontWeight.w900,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
