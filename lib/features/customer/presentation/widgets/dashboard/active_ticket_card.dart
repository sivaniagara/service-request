import 'package:flutter/material.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../data/models/dashboard_models.dart';

class ActiveTicketCard extends StatelessWidget {
  final ActiveTicket ticket;

  const ActiveTicketCard({super.key, required this.ticket});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(20),
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
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.blue100,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'ACTIVE LIVE TICKET',
                  style: TextStyle(
                    color: AppColors.blue500,
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              TextButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.arrow_forward, size: 14),
                label: const Text('View Details'),
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.blue500,
                  visualDensity: VisualDensity.compact,
                  textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '#${ticket.ticketNumber} — ${ticket.title}',
            style: textTheme.titleLarge?.copyWith(fontSize: 17),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _InfoBox(
                  label: 'CURRENT STAGE',
                  value: ticket.status,
                  valueColor: AppColors.blue500,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _InfoBox(
                  label: 'ASSIGNED DEALER',
                  value: ticket.assignedDealer.isNotEmpty
                      ? ticket.assignedDealer.first.name
                      : 'Not Assigned',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _InfoBox(
                  label: 'ASSIGNED TECH',
                  value: ticket.assignedDealer.isNotEmpty &&
                          ticket.assignedDealer.first.assignedTechnician.isNotEmpty
                      ? ticket.assignedDealer.first.assignedTechnician.first.name
                      : 'Not Assigned',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InfoBox extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _InfoBox({required this.label, required this.value, this.valueColor});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.bg,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: textTheme.labelLarge?.copyWith(
              fontSize: 9,
              color: AppColors.ink400,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: textTheme.bodyMedium?.copyWith(
              color: valueColor ?? AppColors.ink900,
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
