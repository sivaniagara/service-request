import 'package:flutter/material.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../data/models/dealer_ticket_model.dart';
import '../assign_technician_dialog.dart';
import '../../bloc/dealer_dashboard_cubit.dart';
import '../../bloc/dealer_dashboard_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DealerTicketListSidebar extends StatelessWidget {
  final List<DealerTicket> tickets;
  final String selectedTicketId;
  final Function(String) onTicketSelected;
  final Function(DealerTicket) onAssign;

  const DealerTicketListSidebar({
    super.key,
    required this.tickets,
    required this.selectedTicketId,
    required this.onTicketSelected,
    required this.onAssign,
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
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Assigned Tickets (${tickets.length})',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: AppColors.navy900,
                  ),
                ),
                const Text(
                  'Routed to Green Sprout Agro',
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
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      color: AppColors.bg.withValues(alpha: 0.3),
      child: Row(
        children: const [
          Expanded(flex: 3, child: _HeaderCell('TICKET')),
          Expanded(flex: 3, child: _HeaderCell('CUSTOMER & SITE')),
          Expanded(flex: 3, child: _HeaderCell('ASSIGNED TECH')),
          Expanded(flex: 3, child: _HeaderCell('STATUS')),
          Expanded(flex: 2, child: _HeaderCell('ACTION')),
        ],
      ),
    );
  }

  Widget _buildTicketRow(DealerTicket ticket) {
    final isSelected = ticket.ticketId == selectedTicketId;
    return InkWell(
      onTap: () => onTicketSelected(ticket.ticketId),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
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
                    ticket.productName ?? (ticket.issueCategory.isNotEmpty ? ticket.issueCategory.first : 'Service Request'),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: isSelected ? AppColors.navy900 : AppColors.ink600,
                      fontSize: 12,
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
                    ticket.customer.siteLocation,
                    style: const TextStyle(color: AppColors.ink400, fontSize: 12),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 3,
              child: ticket.firstTechName != null
                  ? Text(
                      ticket.firstTechName!,
                      style: const TextStyle(color: AppColors.blue500, fontWeight: FontWeight.bold, fontSize: 13),
                    )
                  : Row(
                      children: const [
                        Icon(Icons.access_time, size: 14, color: Color(0xFF6366F1)),
                        SizedBox(width: 6),
                        Text(
                          'Needs Tech',
                          style: TextStyle(color: Color(0xFF6366F1), fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
            ),
            Expanded(
              flex: 3,
              child: _buildStatusPill(ticket.status),
            ),
            Expanded(
              flex: 2,
              child: GestureDetector(
                onTap: () => onAssign(ticket),
                child: const Text(
                  'Assign Tech',
                  style: TextStyle(
                    color: Color(0xFF6366F1),
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusPill(String status) {
    Color color;
    Color bgColor;
    switch (status) {
      case 'In Progress':
        color = AppColors.blue500;
        bgColor = AppColors.blue100;
        break;
      case 'Assigned to Handler':
        color = const Color(0xFF6366F1);
        bgColor = const Color(0xFFEEF2FF);
        break;
      case 'Closed':
        color = AppColors.green500;
        bgColor = AppColors.green100;
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
