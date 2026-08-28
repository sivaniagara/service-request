import 'package:flutter/material.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../data/models/dashboard_models.dart';

class RecentHistoryCard extends StatelessWidget {
  final List<RecentTicket> tickets;

  const RecentHistoryCard({super.key, required this.tickets});

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
              Text(
                'Recent Service History',
                style: textTheme.titleMedium,
              ),
              TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                  visualDensity: VisualDensity.compact,
                  padding: EdgeInsets.zero,
                ),
                child: Text(
                  'View All >',
                  style: textTheme.bodyMedium?.copyWith(
                    color: AppColors.blue500,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: tickets.length,
            separatorBuilder: (context, index) => const Divider(height: 16, color: AppColors.line),
            itemBuilder: (context, index) {
              final ticket = tickets[index];
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '#${ticket.ticketNumber}',
                          style: textTheme.titleMedium?.copyWith(fontSize: 13),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          ticket.title,
                          style: textTheme.bodyMedium?.copyWith(
                            color: AppColors.ink400,
                            fontSize: 12,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: _getStatusBgColor(ticket.status),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          ticket.status,
                          style: TextStyle(
                            color: _getStatusTextColor(ticket.status),
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Aug 20',
                        style: textTheme.labelLarge?.copyWith(
                          color: AppColors.ink400,
                          fontSize: 9,
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Color _getStatusBgColor(String status) {
    switch (status.toLowerCase()) {
      case 'closed':
        return AppColors.green100;
      default:
        return AppColors.blue100;
    }
  }

  Color _getStatusTextColor(String status) {
    switch (status.toLowerCase()) {
      case 'closed':
        return AppColors.green500;
      default:
        return AppColors.blue500;
    }
  }
}
