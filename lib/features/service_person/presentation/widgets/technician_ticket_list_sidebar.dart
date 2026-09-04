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
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Assigned Tasks',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    color: AppColors.navy900,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.bg,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    tickets.length.toString(),
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w900,
                      color: AppColors.navy900,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: AppColors.line),
          Expanded(
            child: ListView.builder(
              itemCount: tickets.length,
              itemBuilder: (context, index) {
                final ticket = tickets[index];
                final isSelected = ticket.ticketId == selectedTicketId;
                return InkWell(
                  onTap: () => onTicketSelected(ticket.ticketId),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.blue500.withOpacity(0.03) : null,
                      border: isSelected
                          ? const Border(left: BorderSide(color: AppColors.blue500, width: 4))
                          : const Border(bottom: BorderSide(color: AppColors.line, width: 0.5)),
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
                                fontWeight: FontWeight.w900,
                                color: isSelected ? AppColors.blue500 : AppColors.navy900,
                                fontSize: 13,
                              ),
                            ),
                            StatusPill.priority(ticket.priority),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          ticket.description,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: isSelected ? AppColors.navy900 : AppColors.ink600,
                            fontSize: 13,
                            height: 1.4,
                            fontWeight: isSelected ? FontWeight.w900 : FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            const Icon(Icons.person_outline, size: 14, color: AppColors.ink400),
                            const SizedBox(width: 8),
                            Text(
                              ticket.customer.name,
                              style: const TextStyle(
                                color: AppColors.ink400,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            const Icon(Icons.location_on_outlined, size: 14, color: AppColors.ink400),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                ticket.customer.siteLocation,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: AppColors.ink400,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
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
