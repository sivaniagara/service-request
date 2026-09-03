import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../data/models/dashboard_models.dart';
import '../../bloc/dashboard_cubit.dart';
import '../../../../../core/widgets/app_vertical_stepper.dart';

class ActiveTicketsSection extends StatelessWidget {
  final List<ActiveTicket> tickets;
  final String? selectedTicketId;

  const ActiveTicketsSection({
    super.key,
    required this.tickets,
    this.selectedTicketId,
  });

  @override
  Widget build(BuildContext context) {
    if (tickets.isEmpty) return const SizedBox.shrink();

    final selectedTicket = tickets.firstWhere(
      (t) => t.ticketId == selectedTicketId,
      orElse: () => tickets.first,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration: const BoxDecoration(
                        color: AppColors.blue500,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'Live Service Requests',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        color: AppColors.navy900,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                const Text(
                  'Real-time tracking of your active service tickets',
                  style: TextStyle(color: AppColors.ink400, fontSize: 13),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.blue500.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '${tickets.length} ACTIVE',
                style: const TextStyle(
                  color: AppColors.blue500,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 4,
              child: _buildTicketsTable(context),
            ),
            const SizedBox(width: 24),
            Expanded(
              flex: 6,
              child: _buildTicketDetail(context, selectedTicket),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTicketsTable(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.line),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildTableHeader(),
          const Divider(height: 1),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: tickets.length,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final ticket = tickets[index];
              return _buildTicketRow(context, ticket);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTableHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      color: AppColors.bg.withOpacity(0.3),
      child: Row(
        children: const [
          Expanded(flex: 2, child: _HeaderCell('TICKET ID')),
          Expanded(flex: 4, child: _HeaderCell('ISSUE CATEGORY')),
          Expanded(flex: 2, child: _HeaderCell('PRIORITY')),
          Expanded(flex: 3, child: _HeaderCell('CURRENT STATUS')),
        ],
      ),
    );
  }

  Widget _buildTicketRow(BuildContext context, ActiveTicket ticket) {
    final isSelected = ticket.ticketId == selectedTicketId;
    return InkWell(
      onTap: () => context.read<DashboardCubit>().selectActiveTicket(ticket.ticketId),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.blue500.withOpacity(0.04) : null,
          border: isSelected
              ? const Border(left: BorderSide(color: AppColors.blue500, width: 4))
              : null,
        ),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Text(
                '#${ticket.ticketNumber}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isSelected ? AppColors.blue500 : AppColors.navy900,
                  fontSize: 14,
                ),
              ),
            ),
            Expanded(
              flex: 4,
              child: Text(
                ticket.issueCategory.join(', '),
                style: const TextStyle(
                  color: AppColors.ink600,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: _buildPriorityBadge(ticket.priority),
            ),
            Expanded(
              flex: 3,
              child: _buildStatusPill(ticket.status),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTicketDetail(BuildContext context, ActiveTicket ticket) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.line),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '#${ticket.ticketNumber}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        color: AppColors.navy900,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Raised on ${ticket.createdAt.day} ${_getMonth(ticket.createdAt.month)}',
                      style: const TextStyle(color: AppColors.ink400, fontSize: 11),
                    ),
                  ],
                ),
                _buildPriorityBadge(ticket.priority),
              ],
            ),
            const SizedBox(height: 24),
            const Text(
              'LIVE PROGRESS STEPPER',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w900,
                color: AppColors.ink400,
                letterSpacing: 1.0,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: AppVerticalStepper(
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
                ),
                const SizedBox(width: 24),
                Expanded(
                  flex: 3,
                  child: _buildDetailTable(ticket),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailTable(ActiveTicket ticket) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.bg.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.line),
      ),
      child: Table(
        columnWidths: const {
          0: FlexColumnWidth(1),
          1: FlexColumnWidth(2),
        },
        children: [
          _buildDetailRow('Site Location', ticket.siteLocation),
          _buildDetailRow('Support Mode', ticket.supportMode.toUpperCase()),
          _buildDetailRow('Dealer', ticket.assignedDealer.isNotEmpty ? ticket.assignedDealer.first.name : 'Awaiting Assignment'),
          if (ticket.assignedDealer.isNotEmpty && ticket.assignedDealer.first.assignedTechnician.isNotEmpty)
            _buildDetailRow('Technician', ticket.assignedDealer.first.assignedTechnician.first.name),
        ],
      ),
    );
  }

  TableRow _buildDetailRow(String label, String value) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(
            label.toUpperCase(),
            style: const TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.bold,
              color: AppColors.ink400,
              letterSpacing: 0.5,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w900,
              color: AppColors.navy900,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPriorityBadge(String priority) {
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
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          priority.toUpperCase(),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(color: color, fontSize: 9, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildStatusPill(String status) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: AppColors.blue100,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          status.toUpperCase(),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: AppColors.blue500,
            fontSize: 9,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  String _getMonth(int month) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return months[month - 1];
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
        fontSize: 10,
        fontWeight: FontWeight.w900,
        color: AppColors.ink400,
        letterSpacing: 0.5,
      ),
    );
  }
}
