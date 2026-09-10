import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
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

// ---------------------------------------------------------------------------
// PRIORITY COLOR
// ---------------------------------------------------------------------------

  Color _priorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'critical':
        return const Color(0xFFE5484D);

      case 'high':
        return const Color(0xFFF5A524);

      case 'medium':
        return const Color(0xFF3B82F6);

      case 'low':
        return const Color(0xFF64748B);

      default:
        return AppColors.ink400;
    }
  }

// ---------------------------------------------------------------------------
// STATUS COLOR
// ---------------------------------------------------------------------------

  Color _statusColor(String status) {
    switch (status.toLowerCase().trim()) {
      case 'in progress':
        return const Color(0xFF2563EB);

      case 'assigned':
      case 'assigned to technician':
      case 'assigned to dealer':
        return const Color(0xFF7C3AED);

      case 'pending assignment':
      case 'pending':
        return const Color(0xFFF59E0B);

      case 'submitted':
        return const Color(0xFF0891B2);

      case 'resolved':
      case 'completed':
        return const Color(0xFF16A34A);

      case 'customer raised complaint':
      case 'open':
        return const Color(0xFFDC2626);

      case 'cancelled':
      case 'closed':
        return const Color(0xFF64748B);

      default:
        return AppColors.ink400;
    }
  }

// ---------------------------------------------------------------------------
// STATUS ICON
// ---------------------------------------------------------------------------

  IconData _statusIcon(String status) {
    switch (status.toLowerCase().trim()) {
      case 'in progress':
        return Icons.autorenew_rounded;

      case 'assigned':
      case 'assigned to technician':
      case 'assigned to dealer':
        return Icons.person_add_alt_1_rounded;

      case 'pending assignment':
      case 'pending':
        return Icons.schedule_rounded;

      case 'submitted':
        return Icons.upload_rounded;

      case 'resolved':
      case 'completed':
        return Icons.check_circle_outline_rounded;

      case 'customer raised complaint':
      case 'open':
        return Icons.error_outline_rounded;

      case 'cancelled':
      case 'closed':
        return Icons.close_rounded;

      default:
        return Icons.circle_outlined;
    }
  }

// ---------------------------------------------------------------------------
// STATUS PILL
// ---------------------------------------------------------------------------

  Widget _statusPill(String status) {
    final color = _statusColor(status);
    final icon = _statusIcon(status);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.11),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: color.withOpacity(0.30),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 11,
            color: color,
          ),
          const SizedBox(width: 4),
          Text(
            status.toUpperCase(),
            style: TextStyle(
              fontSize: 8.5,
              fontWeight: FontWeight.w900,
              letterSpacing: 0.25,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

// ---------------------------------------------------------------------------
// PRIORITY BADGE
// ---------------------------------------------------------------------------

  Widget _priorityBadge(String priority) {
    final color = _priorityColor(priority);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 7,
        vertical: 3,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.10),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        priority.toUpperCase(),
        style: TextStyle(
          fontSize: 8.5,
          fontWeight: FontWeight.w900,
          letterSpacing: 0.3,
          color: color,
        ),
      ),
    );
  }

// ---------------------------------------------------------------------------
// TICKET CARD
// ---------------------------------------------------------------------------

  Widget _buildTicketCard(
      BuildContext context,
      TechnicianTicket ticket,
      ) {
    final isSelected = ticket.ticketId == selectedTicketId;
    final accent = _priorityColor(ticket.priority);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => onTicketSelected(ticket.ticketId),
        child: Ink(
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.blue500.withOpacity(0.07)
                : AppColors.bg.withOpacity(0.55),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected
                  ? AppColors.blue500.withOpacity(0.40)
                  : Colors.transparent,
              width: 1.2,
            ),
          ),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
// ----------------------------------------------------------------
// PRIORITY STRIP
// ----------------------------------------------------------------

                Container(
                  width: 4,
                  decoration: BoxDecoration(
                    color: accent,
                    borderRadius: const BorderRadius.horizontal(
                      left: Radius.circular(12),
                    ),
                  ),
                ),

// ----------------------------------------------------------------
// CARD CONTENT
// ----------------------------------------------------------------

                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(
                      12,
                      10,
                      12,
                      10,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
// --------------------------------------------------------
// ROW 1
// TICKET NUMBER + STATUS
// --------------------------------------------------------

                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Text(
                                '#${ticket.ticketNumber}',
                                style: TextStyle(
                                  fontWeight: FontWeight.w900,
                                  color: isSelected
                                      ? AppColors.blue500
                                      : AppColors.navy900,
                                  fontSize: 12.5,
                                ),
                              ),
                            ),

                            const SizedBox(width: 6),

                            _statusPill(
                              ticket.status,
                            ),
                          ],
                        ),

                        const SizedBox(height: 7),

// --------------------------------------------------------
// ROW 2
// PRIORITY + DESCRIPTION
// --------------------------------------------------------

                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            _priorityBadge(
                              ticket.priority,
                            ),

                            const SizedBox(width: 7),

                            Expanded(
                              child: Text(
                                ticket.description,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: isSelected
                                      ? AppColors.navy900
                                      : AppColors.ink600,
                                  fontSize: 12,
                                  height: 1.3,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 7),

// --------------------------------------------------------
// ROW 3
// CUSTOMER + LOCATION
// --------------------------------------------------------

                        Row(
                          children: [
                            const Icon(
                              Icons.person_outline,
                              size: 12,
                              color: AppColors.ink400,
                            ),

                            const SizedBox(width: 4),

                            Flexible(
                              child: Text(
                                ticket.customer.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: AppColors.ink400,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),

                            const Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 6,
                              ),
                              child: Text(
                                '•',
                                style: TextStyle(
                                  color: AppColors.ink400,
                                  fontSize: 11,
                                ),
                              ),
                            ),

                            const Icon(
                              Icons.location_on_outlined,
                              size: 12,
                              color: AppColors.ink400,
                            ),

                            const SizedBox(width: 4),

                            Expanded(
                              child: Text(
                                ticket.customer.siteLocation,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: AppColors.ink400,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                ),
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
          ),
        ),
      ),
    );
  }

// ---------------------------------------------------------------------------
// BUILD
// ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.line,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
// -------------------------------------------------------------------
// HEADER
// -------------------------------------------------------------------

          Padding(
            padding: const EdgeInsets.fromLTRB(
              16,
              16,
              16,
              12,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Assigned Tasks',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                    color: AppColors.navy900,
                  ),
                ),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 9,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.bg,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    tickets.length.toString(),
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w900,
                      color: AppColors.navy900,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const Divider(
            height: 1,
            color: AppColors.line,
          ),

// -------------------------------------------------------------------
// TICKET LIST
// -------------------------------------------------------------------

          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(
                vertical: 6,
                horizontal: 8,
              ),
              itemCount: tickets.length,
              separatorBuilder: (_, __) => const SizedBox(
                height: 6,
              ),
              itemBuilder: (context, index) {
                final ticket = tickets[index];

                return _buildTicketCard(
                  context,
                  ticket,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

