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

  Color _statusColor(String status) {
    switch (status.toLowerCase().trim()) {
      case 'in progress':
        return const Color(0xFF2563EB);
      case 'assigned':
      case 'assigned to technician':
      case 'assigned to dealer':
      case 'assigned to handler':
        return const Color(0xFF7C3AED);
      case 'pending assignment':
      case 'pending':
        return const Color(0xFFF59E0B);
      case 'submitted':
        return const Color(0xFF0891B2);
      case 'resolved':
      case 'completed':
      case 'closed':
        return const Color(0xFF16A34A);
      case 'customer raised complaint':
      case 'open':
        return const Color(0xFFDC2626);
      case 'cancelled':
        return const Color(0xFF64748B);
      case 'escalated':
      case 'escalated to company':
        return const Color(0xFFE11D48);
      default:
        return AppColors.ink400;
    }
  }

  IconData _statusIcon(String status) {
    switch (status.toLowerCase().trim()) {
      case 'in progress':
        return Icons.autorenew_rounded;
      case 'assigned':
      case 'assigned to technician':
      case 'assigned to dealer':
      case 'assigned to handler':
        return Icons.person_add_alt_1_rounded;
      case 'pending assignment':
      case 'pending':
        return Icons.schedule_rounded;
      case 'submitted':
        return Icons.upload_rounded;
      case 'resolved':
      case 'completed':
      case 'closed':
        return Icons.check_circle_outline_rounded;
      case 'customer raised complaint':
      case 'open':
        return Icons.error_outline_rounded;
      case 'cancelled':
        return Icons.close_rounded;
      case 'escalated':
      case 'escalated to company':
        return Icons.warning_amber_rounded;
      default:
        return Icons.circle_outlined;
    }
  }

  Widget _statusPill(String status) {
    final color = _statusColor(status);
    final icon = _statusIcon(status);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.11),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.30), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 11, color: color),
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

  Widget _priorityBadge(String priority) {
    final color = _priorityColor(priority);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
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

  @override
  Widget build(BuildContext context) {
    final accent = _priorityColor(ticket.priority);
    final unassigned = ticket.assignedDealers.isEmpty;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Ink(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.line, width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.02),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  width: 4,
                  decoration: BoxDecoration(
                    color: accent,
                    borderRadius: const BorderRadius.horizontal(left: Radius.circular(12)),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                '#${ticket.ticketNumber}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w900,
                                  color: AppColors.navy900,
                                  fontSize: 12.5,
                                ),
                              ),
                            ),
                            _statusPill(ticket.status),
                          ],
                        ),
                        const SizedBox(height: 7),
                        Row(
                          children: [
                            _priorityBadge(ticket.priority),
                            const SizedBox(width: 7),
                            Expanded(
                              child: Text(
                                ticket.title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.navy900,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            const Icon(Icons.person_outline, size: 12, color: AppColors.ink400),
                            const SizedBox(width: 4),
                            Flexible(
                              child: Text(
                                ticket.customer.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: AppColors.ink600,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 6),
                              child: Text('•', style: TextStyle(color: AppColors.ink400, fontSize: 11)),
                            ),
                            const Icon(Icons.location_on_outlined, size: 12, color: AppColors.ink400),
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
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
                          decoration: BoxDecoration(
                            color: unassigned ? Colors.orange.shade50 : const Color(0xFFF1F0FF),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                unassigned ? Icons.access_time_rounded : Icons.storefront_outlined,
                                size: 12,
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
                                    fontSize: 10.5,
                                    fontWeight: FontWeight.w800,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const Icon(Icons.chevron_right, size: 14, color: AppColors.ink400),
                            ],
                          ),
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
}

// Removing the old private _StatusPill as it's now integrated or replaced by _statusPill method
