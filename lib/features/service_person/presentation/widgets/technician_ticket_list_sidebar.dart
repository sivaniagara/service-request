import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/status_pill.dart';
import '../../data/models/technician_ticket_model.dart';

class TechnicianTicketListSidebar extends StatelessWidget {
  final List<TechnicianTicket> tickets;
  final String selectedTicketId;
  final Function(String) onTicketSelected;

  const TechnicianTicketListSidebar({
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
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'Assigned Tasks (${tickets.length})',
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: AppColors.navy900,
              ),
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: ListView.separated(
              itemCount: tickets.length,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final ticket = tickets[index];
                final isSelected = ticket.ticketId == selectedTicketId;
                return InkWell(
                  onTap: () => onTicketSelected(ticket.ticketId),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.blue500.withOpacity(0.05) : null,
                      border: isSelected
                          ? const Border(left: BorderSide(color: AppColors.blue500, width: 4))
                          : null,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '#${ticket.ticketNumber}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: isSelected ? AppColors.blue500 : AppColors.navy900,
                                fontSize: 13,
                              ),
                            ),
                            StatusPill.priority(ticket.priority),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          ticket.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: isSelected ? AppColors.navy900 : AppColors.ink600,
                            fontSize: 12,
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.person_outline, size: 12, color: AppColors.ink400),
                            const SizedBox(width: 4),
                            Text(ticket.customer.name, style: const TextStyle(color: AppColors.ink400, fontSize: 11)),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.location_on_outlined, size: 12, color: AppColors.ink400),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                ticket.customer.siteLocation,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(color: AppColors.ink400, fontSize: 11),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
