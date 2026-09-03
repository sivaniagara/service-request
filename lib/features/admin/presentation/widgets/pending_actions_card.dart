import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../data/models/admin_dashboard_model.dart';

class PendingActionsCard extends StatelessWidget {
  final List<UrgentAttentionTicket> tickets;

  const PendingActionsCard({super.key, required this.tickets});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 16,
            offset: const Offset(0, 4),
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
                  const Text(
                    'Pending Actions Alert',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.navy900,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Requires Admin handler assignment or escalation',
                    style: TextStyle(fontSize: 12, color: AppColors.ink400),
                  ),
                ],
              ),
              TextButton(
                onPressed: () {},
                child: const Text(
                  'Manage Tickets ›',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.purple),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: tickets.length,
            separatorBuilder: (context, index) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              final ticket = tickets[index];
              return _buildTicketItem(context, ticket);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTicketItem(BuildContext context, UrgentAttentionTicket ticket) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      '#${ticket.ticketNumber}',
                      style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.navy900),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: _getStatusBgColor(ticket.status),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        ticket.status,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: _getStatusTextColor(ticket.status),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  ticket.issueCategory.join(', '),
                  style: const TextStyle(fontSize: 14, color: AppColors.ink900),
                ),
              ],
            ),
          ),
          Icon(Icons.chevron_right, color: Colors.grey.shade400),
        ],
      ),
    );
  }

  Color _getStatusBgColor(String status) {
    if (status.contains('Pending')) return Colors.orange.shade50;
    if (status.contains('Escalated')) return Colors.red.shade50;
    return Colors.grey.shade50;
  }

  Color _getStatusTextColor(String status) {
    if (status.contains('Pending')) return Colors.orange.shade700;
    if (status.contains('Escalated')) return Colors.red.shade700;
    return Colors.grey.shade700;
  }
}
