import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../data/models/admin_ticket_detail_model.dart';
import '../../bloc/admin_dashboard_cubit.dart';
import '../admin_audit_timeline.dart';
import '../admin_complaint_stepper.dart';
import '../assign_dealer_dialog.dart';

class AdminTicketDetailView extends StatelessWidget {
  final AdminTicketDetailData ticket;

  const AdminTicketDetailView({super.key, required this.ticket});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.line),
      ),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  '#${ticket.ticketNumber}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.navy900,
                  ),
                ),
                const SizedBox(width: 12),
                _buildStatusBadge(ticket.status),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              ticket.title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.navy900,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              ticket.description ?? '',
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.ink600,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (dialogContext) => BlocProvider.value(
                          value: context.read<AdminDashboardCubit>(),
                          child: AssignDealerDialog(ticket: ticket),
                        ),
                      );
                    },
                    icon: const Icon(Icons.storefront_outlined, size: 18),
                    label: const Text('Assign Dealer(s)'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.purple500,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.report_problem_outlined, size: 18),
                    label: const Text('Escalate to HQ'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.red500,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            _buildAssignedDealersSection(),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Vertical Stepper Status',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.navy900,
                  ),
                ),
                const Text(
                  'Customer synced',
                  style: TextStyle(fontSize: 12, color: AppColors.ink400),
                ),
              ],
            ),
            const SizedBox(height: 12),
            AdminComplaintStepper(milestones: ticket.stepperMilestones),
            const SizedBox(height: 24),
            const Text(
              'Timeline Log',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: AppColors.navy900,
              ),
            ),
            const SizedBox(height: 12),
            AdminAuditTimeline(events: ticket.timelineEvents),
          ],
        ),
      ),
    );
  }

  Widget _buildAssignedDealersSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Assigned Dealer Handlers:',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: AppColors.ink600,
              ),
            ),
            Text(
              '${ticket.assignedDealer.length} assigned',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppColors.purple500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        if (ticket.assignedDealer.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.orange.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.orange.shade100),
            ),
            child: Row(
              children: [
                Icon(Icons.warning_amber_rounded, color: Colors.orange.shade800, size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'No dealer assigned yet. Click "Assign Dealer(s)" above.',
                    style: TextStyle(
                      color: Colors.orange.shade900,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          )
        else
          ...ticket.assignedDealer.map((dealer) => _buildDealerMiniCard(dealer)),
      ],
    );
  }

  Widget _buildDealerMiniCard(AdminAssignedDealerDetail dealer) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.bg.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.line),
      ),
      child: Row(
        children: [
          const Icon(Icons.storefront, color: AppColors.purple500, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              dealer.name,
              style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.navy900),
            ),
          ),
          const Icon(Icons.chevron_right, color: AppColors.ink400, size: 20),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color color;
    Color bgColor;
    switch (status) {
      case 'In Progress':
        color = Colors.blue.shade700;
        bgColor = Colors.blue.shade50;
        break;
      case 'Pending Assignment':
        color = AppColors.purple500;
        bgColor = AppColors.purple100;
        break;
      case 'Closed':
        color = Colors.green.shade700;
        bgColor = Colors.green.shade50;
        break;
      case 'Escalated':
        color = Colors.red.shade700;
        bgColor = Colors.red.shade50;
        break;
      default:
        color = AppColors.ink600;
        bgColor = AppColors.bg;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        status,
        style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.bold),
      ),
    );
  }
}
