import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../data/models/admin_ticket_model.dart';

class AdminTicketListSidebar extends StatelessWidget {
  final List<AdminTicketItem> tickets;
  final String selectedTicketId;
  final Function(String) onTicketSelected;

  const AdminTicketListSidebar({
    super.key,
    required this.tickets,
    required this.selectedTicketId,
    required this.onTicketSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'All Service Requests (${tickets.length})',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.navy900,
                  ),
                ),
                const Text(
                  'Click any row to manage stepper & handlers',
                  style: TextStyle(fontSize: 11, color: AppColors.ink400),
                ),
              ],
            ),
          ),
          _buildTableHeader(),
          const Divider(height: 1),
          Expanded(
            child: ListView.separated(
              itemCount: tickets.length,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final ticket = tickets[index];
                return _buildTicketRow(ticket);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTableHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      color: AppColors.bg.withValues(alpha: 0.3),
      child: Row(
        children: const [
          Expanded(flex: 3, child: _HeaderCell('TICKET')),
          Expanded(flex: 3, child: _HeaderCell('CUSTOMER & SITE')),
          Expanded(flex: 2, child: _HeaderCell('STATUS')),
        ],
      ),
    );
  }

  Widget _buildTicketRow(AdminTicketItem ticket) {
    final isSelected = ticket.ticketId == selectedTicketId;
    return InkWell(
      onTap: () => onTicketSelected(ticket.ticketId),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.blue500.withValues(alpha: 0.06) : null,
          border: isSelected
              ? const Border(
                  left: BorderSide(color: AppColors.blue500, width: 4),
                )
              : null,
        ),
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '#${ticket.ticketNumber}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isSelected ? AppColors.blue500 : AppColors.navy900,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    ticket.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: isSelected ? AppColors.navy900 : AppColors.ink600,
                      fontSize: 12,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    ticket.customer.name,
                    style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.navy900, fontSize: 13),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    ticket.customer.siteLocation.split(',').first,
                    style: const TextStyle(color: AppColors.ink400, fontSize: 12),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: _buildStatusPill(ticket.status),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHandlersCell(AdminTicketItem ticket) {
    if (ticket.assignedDealers.isEmpty) {
      return Row(
        children: const [
          Icon(Icons.access_time, size: 14, color: Colors.orange),
          SizedBox(width: 6),
          Text(
            'Unassigned',
            style: TextStyle(color: Colors.orange, fontSize: 12, fontWeight: FontWeight.bold),
          ),
        ],
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: ticket.assignedDealers
          .map((dealer) => Text(
                dealer.name,
                style: const TextStyle(
                  color: AppColors.purple500,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ))
          .toList(),
    );
  }

  Widget _buildStatusPill(String status) {
    Color color;
    Color bgColor;
    switch (status) {
      case 'In Progress':
        color = Colors.blue.shade700;
        bgColor = Colors.blue.shade50;
        break;
      case 'Pending Assignment':
        color = Colors.orange.shade700;
        bgColor = Colors.orange.shade50;
        break;
      case 'Closed':
        color = Colors.green.shade700;
        bgColor = Colors.green.shade50;
        break;
      case 'Escalated':
      case 'Escalated to Company':
        color = Colors.red.shade700;
        bgColor = Colors.red.shade50;
        break;
      case 'Assigned to Handler':
        color = Colors.orange.shade700;
        bgColor = Colors.orange.shade100;
        break;
      default:
        color = AppColors.ink600;
        bgColor = AppColors.bg;
    }

    return UnconstrainedBox(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          status,
          style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

class _HeaderCell extends StatelessWidget {
  final String label;
  const _HeaderCell(this.label);

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w900,
        color: AppColors.ink400,
        letterSpacing: 0.5,
      ),
    );
  }
}
