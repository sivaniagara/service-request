import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../data/models/admin_ticket_model.dart';

/// A tappable ticket card for the admin mobile "Service Requests" tab.
///
/// The desktop [AdminTicketListSidebar] renders a 3-column table
/// (TICKET / CUSTOMER & SITE / STATUS) — unreadable at phone width.
/// This condenses the same fields into a single card so admins can
/// scan tickets and jump into detail with one tap.
class AdminMobileTicketCard extends StatelessWidget {
  final AdminTicketItem ticket;
  final VoidCallback onTap;

  const AdminMobileTicketCard({super.key, required this.ticket, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final unassigned = ticket.assignedDealers.isEmpty;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.line),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    '#${ticket.ticketNumber}',
                    style: const TextStyle(fontWeight: FontWeight.w900, color: AppColors.navy900, fontSize: 13),
                  ),
                ),
                _StatusPill(status: ticket.status),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              ticket.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.w800, color: AppColors.navy900),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.person_outline, size: 14, color: AppColors.ink400),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    ticket.customer.name,
                    style: const TextStyle(color: AppColors.ink600, fontSize: 12, fontWeight: FontWeight.w700),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.location_on_outlined, size: 14, color: AppColors.ink400),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    ticket.customer.siteLocation,
                    style: const TextStyle(color: AppColors.ink400, fontSize: 11.5),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
              decoration: BoxDecoration(
                color: unassigned ? Colors.orange.shade50 : const Color(0xFFE7E3FD).withOpacity(0.5),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Icon(
                    unassigned ? Icons.access_time_rounded : Icons.storefront_outlined,
                    size: 14,
                    color: unassigned ? Colors.orange.shade700 : const Color(0xFF7C6CF0),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      unassigned
                          ? 'Needs dealer assignment'
                          : ticket.assignedDealers.map((d) => d.name).join(', '),
                      style: TextStyle(
                        color: unassigned ? Colors.orange.shade800 : const Color(0xFF7C6CF0),
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const Icon(Icons.chevron_right, size: 16, color: AppColors.ink400),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  final String status;
  const _StatusPill({required this.status});

  @override
  Widget build(BuildContext context) {
    Color color;
    Color bg;
    switch (status) {
      case 'In Progress':
        color = Colors.blue.shade700;
        bg = Colors.blue.shade50;
        break;
      case 'Pending Assignment':
        color = Colors.orange.shade700;
        bg = Colors.orange.shade50;
        break;
      case 'Closed':
        color = Colors.green.shade700;
        bg = Colors.green.shade50;
        break;
      case 'Escalated':
      case 'Escalated to Company':
        color = Colors.red.shade700;
        bg = Colors.red.shade50;
        break;
      case 'Assigned to Handler':
        color = Colors.orange.shade700;
        bg = Colors.orange.shade100;
        break;
      default:
        color = AppColors.ink600;
        bg = AppColors.bg;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(6)),
      child: Text(
        status,
        style: TextStyle(color: color, fontSize: 9.5, fontWeight: FontWeight.w900),
      ),
    );
  }
}