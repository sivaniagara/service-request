import 'package:flutter/material.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../core/widgets/app_vertical_stepper.dart';
import '../../../data/models/dashboard_models.dart';

/// A single active-ticket card designed for phone widths.
///
/// The desktop [ActiveTicketsSection] shows a table on the left and a
/// wide detail panel on the right — there's no room for that layout on
/// a phone, so this collapses each ticket into a compact card that the
/// user can tap open to reveal the live progress stepper in place,
/// without leaving the dashboard.
class MobileActiveTicketCard extends StatefulWidget {
  final ActiveTicket ticket;
  final bool initiallyExpanded;

  const MobileActiveTicketCard({
    super.key,
    required this.ticket,
    this.initiallyExpanded = false,
  });

  @override
  State<MobileActiveTicketCard> createState() => _MobileActiveTicketCardState();
}

class _MobileActiveTicketCardState extends State<MobileActiveTicketCard> {
  late bool _expanded = widget.initiallyExpanded;

  @override
  Widget build(BuildContext context) {
    final ticket = widget.ticket;
    final dealer = ticket.assignedDealer.isNotEmpty ? ticket.assignedDealer.first : null;
    final tech = dealer != null && dealer.assignedTechnician.isNotEmpty ? dealer.assignedTechnician.first : null;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.line),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () => setState(() => _expanded = !_expanded),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        margin: const EdgeInsets.only(right: 8),
                        decoration: const BoxDecoration(color: AppColors.blue500, shape: BoxShape.circle),
                      ),
                      Expanded(
                        child: Text(
                          '#${ticket.ticketNumber}',
                          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w900, color: AppColors.navy900),
                        ),
                      ),
                      _PriorityPill(priority: ticket.priority),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    ticket.issueCategory.join(', '),
                    style: const TextStyle(color: AppColors.ink600, fontSize: 13, fontWeight: FontWeight.w600),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _StatusPill(status: ticket.status),
                      _InfoChip(
                        icon: Icons.storefront_outlined,
                        label: dealer?.name ?? 'Awaiting dealer',
                      ),
                      if (tech != null) _InfoChip(icon: Icons.engineering_outlined, label: tech.name),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Raised ${ticket.createdAt.day} ${_getMonth(ticket.createdAt.month)}',
                        style: const TextStyle(color: AppColors.ink400, fontSize: 11, fontWeight: FontWeight.w500),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            _expanded ? 'Hide progress' : 'View live progress',
                            style: const TextStyle(color: AppColors.blue500, fontSize: 12, fontWeight: FontWeight.w800),
                          ),
                          AnimatedRotation(
                            turns: _expanded ? 0.5 : 0,
                            duration: const Duration(milliseconds: 200),
                            child: const Icon(Icons.keyboard_arrow_down, size: 18, color: AppColors.blue500),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 220),
            crossFadeState: _expanded ? CrossFadeState.showFirst : CrossFadeState.showSecond,
            firstChild: Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 18),
              decoration: BoxDecoration(
                color: AppColors.bg.withOpacity(0.4),
                border: const Border(top: BorderSide(color: AppColors.line)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 14),
                  const Text(
                    'LIVE PROGRESS',
                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: AppColors.ink400, letterSpacing: 0.8),
                  ),
                  const SizedBox(height: 12),
                  AppVerticalStepper(
                    steps: ticket.stepperMilestones
                        .map((m) => StepperStepData(
                      stepOrder: m.stepOrder,
                      title: m.title,
                      description: m.description ?? '',
                      status: m.status,
                      updatedAt: m.updatedAt,
                      updatedBy: m.updatedBy,
                    ))
                        .toList(),
                  ),
                  if (ticket.siteLocation.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.line),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.location_on_outlined, size: 15, color: AppColors.ink400),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              ticket.siteLocation,
                              style: const TextStyle(fontSize: 12, color: AppColors.ink600, fontWeight: FontWeight.w600),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
            secondChild: const SizedBox(width: double.infinity),
          ),
        ],
      ),
    );
  }

  String _getMonth(int month) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return months[month - 1];
  }
}

class _PriorityPill extends StatelessWidget {
  final String priority;
  const _PriorityPill({required this.priority});

  @override
  Widget build(BuildContext context) {
    Color color;
    switch (priority.toLowerCase()) {
      case 'high':
      case 'critical':
        color = AppColors.red500;
        break;
      case 'medium':
        color = AppColors.orange500;
        break;
      default:
        color = AppColors.green500;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        priority.toUpperCase(),
        style: TextStyle(color: color, fontSize: 9, fontWeight: FontWeight.w900),
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  final String status;
  const _StatusPill({required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.blue100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        status.toUpperCase(),
        style: const TextStyle(color: AppColors.blue500, fontSize: 9, fontWeight: FontWeight.w900),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  const _InfoChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 180),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.bg,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: AppColors.ink400),
          const SizedBox(width: 5),
          Flexible(
            child: Text(
              label,
              style: const TextStyle(color: AppColors.ink600, fontSize: 10.5, fontWeight: FontWeight.w700),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}