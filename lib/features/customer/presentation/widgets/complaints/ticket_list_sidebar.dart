import 'package:flutter/material.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../data/models/dashboard_models.dart';

class TicketListSidebar extends StatelessWidget {
  final List<ServiceTicket> tickets;
  final String selectedTicketId;
  final Function(String) onTicketSelected;

  const TicketListSidebar({
    super.key,
    required this.tickets,
    required this.selectedTicketId,
    required this.onTicketSelected,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      width: 340,
      height: 700,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(20), // More rounded
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
              Text('Your Complaint Tickets', style: textTheme.titleMedium?.copyWith(fontSize: 14)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.blue500.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${tickets.length} tickets',
                  style: const TextStyle(
                    color: AppColors.blue500,
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Select a ticket to inspect live stepper',
            style: textTheme.bodyMedium?.copyWith(color: AppColors.ink400, fontSize: 11),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 44,
            child: TextField(
              style: textTheme.bodyMedium?.copyWith(fontSize: 12),
              decoration: InputDecoration(
                hintText: 'Search ticket...',
                hintStyle: textTheme.bodyMedium?.copyWith(color: AppColors.ink400, fontSize: 12),
                prefixIcon: const Icon(Icons.search, size: 18, color: AppColors.ink400),
                fillColor: AppColors.bg.withOpacity(0.5),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.line),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.blue500),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
              ),
            ),
          ),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _FilterChip(label: 'All', isActive: true),
                const SizedBox(width: 6),
                _FilterChip(label: 'Open', isActive: false),
                const SizedBox(width: 6),
                _FilterChip(label: 'In Progress', isActive: false),
                const SizedBox(width: 6),
                _FilterChip(label: 'Closed', isActive: false),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.separated(
              itemCount: tickets.length,
              separatorBuilder: (context, index) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final ticket = tickets[index];
                return _TicketCard(
                  ticket: ticket,
                  isSelected: ticket.ticketId == selectedTicketId,
                  onTap: () => onTicketSelected(ticket.ticketId),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isActive;

  const _FilterChip({required this.label, required this.isActive});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? AppColors.navy900 : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isActive ? AppColors.navy900 : AppColors.line,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isActive ? Colors.white : AppColors.ink600,
            fontWeight: FontWeight.bold,
            fontSize: 10,
          ),
        ),
      ),
    );
  }
}

class _TicketCard extends StatelessWidget {
  final ServiceTicket ticket;
  final bool isSelected;
  final VoidCallback onTap;

  const _TicketCard({
    required this.ticket,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : AppColors.bg.withOpacity(0.3),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? AppColors.blue500 : AppColors.line,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.blue500.withOpacity(0.08),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  )
                ]
              : [],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text('#${ticket.ticketNumber}',
                      style: textTheme.titleMedium?.copyWith(
                        fontSize: 12,
                        color: isSelected ? AppColors.navy900 : AppColors.ink900,
                      )
                    ),
                    const SizedBox(width: 8),
                    _StatusBadge(status: ticket.status),
                  ],
                ),
                Text(
                  'Aug 20',
                  style: textTheme.labelLarge?.copyWith(color: AppColors.ink400, fontSize: 9),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              ticket.issueCategory.join(', '),
              style: textTheme.titleMedium?.copyWith(
                fontSize: 13,
                color: isSelected ? AppColors.navy900 : AppColors.ink900,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              ticket.description ?? '',
              style: textTheme.bodyMedium?.copyWith(color: AppColors.ink600, fontSize: 11),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                const Icon(Icons.location_on_outlined, size: 12, color: AppColors.ink400),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    ticket.siteLocation ?? '',
                    style: textTheme.labelLarge?.copyWith(color: AppColors.ink400, fontSize: 9),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 6),
                if (ticket.issueCategory.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.blue100.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      ticket.issueCategory.first,
                      style: textTheme.labelLarge?.copyWith(
                        fontSize: 8,
                        color: AppColors.blue500,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;

  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    Color bgColor;
    Color textColor;

    switch (status.toLowerCase()) {
      case 'in progress':
        bgColor = AppColors.blue100;
        textColor = AppColors.blue500;
        break;
      case 'pending assignment':
        bgColor = AppColors.orange100;
        textColor = AppColors.orange500;
        break;
      case 'assigned to handler':
        bgColor = AppColors.purple100;
        textColor = AppColors.purple500;
        break;
      case 'closed':
        bgColor = AppColors.green100;
        textColor = AppColors.green500;
        break;
      default:
        bgColor = AppColors.bg;
        textColor = AppColors.ink600;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
          color: textColor,
          fontSize: 7.5,
          fontWeight: FontWeight.w900,
          letterSpacing: 0.2,
        ),
      ),
    );
  }
}
