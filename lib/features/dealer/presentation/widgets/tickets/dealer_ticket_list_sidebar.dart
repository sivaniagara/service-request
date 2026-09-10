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
    return LayoutBuilder(
      builder: (context, constraints) {
        final isNarrow = constraints.maxWidth < 650;

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
                    if (!isNarrow)
                      const Text(
                        'Routed to Green Sprout Agro',
                        style: TextStyle(fontSize: 11, color: AppColors.ink400),
                      ),
                  ],
                ),
              ),
              if (!isNarrow) ...[
                _buildTableHeader(),
                const Divider(height: 1),
              ],
              Expanded(
                child: ListView.separated(
                  padding: isNarrow ? const EdgeInsets.all(12) : EdgeInsets.zero,
                  itemCount: tickets.length,
                  separatorBuilder: (context, index) => isNarrow ? const SizedBox(height: 12) : const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final ticket = tickets[index];
                    if (isNarrow) {
                      return _buildMobileTicketCard(ticket);
                    }
                    return _buildTicketRow(ticket);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

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

  Widget _buildMobileTicketCard(DealerTicket ticket) {
    final isSelected = ticket.ticketId == selectedTicketId;
    final accent = _priorityColor(ticket.priority);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => onTicketSelected(ticket.ticketId),
        borderRadius: BorderRadius.circular(12),
        child: Ink(
          decoration: BoxDecoration(
            color: isSelected ? AppColors.blue500.withValues(alpha: 0.07) : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? AppColors.blue500.withValues(alpha: 0.40) : AppColors.line,
              width: isSelected ? 1.2 : 1,
            ),
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
                                style: TextStyle(
                                  fontWeight: FontWeight.w900,
                                  color: isSelected ? AppColors.blue500 : AppColors.navy900,
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
                                ticket.productName ?? (ticket.issueCategory.isNotEmpty ? ticket.issueCategory.first : 'Service Request'),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: isSelected ? AppColors.navy900 : AppColors.navy900,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w800,
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
                            color: ticket.firstTechName == null ? const Color(0xFFF1F0FF) : AppColors.blue500.withOpacity(0.06),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                ticket.firstTechName == null ? Icons.person_add_alt_1_outlined : Icons.engineering_outlined,
                                size: 12,
                                color: const Color(0xFF6366F1),
                              ),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  ticket.firstTechName ?? 'Needs Tech Assignment',
                                  style: const TextStyle(
                                    color: Color(0xFF6366F1),
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
