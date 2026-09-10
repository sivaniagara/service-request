import 'package:flutter/material.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../data/models/dealer_ticket_model.dart';
import '../assign_technician_page.dart';
import '../dealer_complaint_stepper.dart';
import '../assign_technician_dialog.dart';
import '../delegate_branch_dialog.dart';
import '../../bloc/dealer_dashboard_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../delegate_branch_page.dart';

class DealerTicketDetailView extends StatelessWidget {
  final DealerTicketDetail ticket;

  const DealerTicketDetailView({super.key, required this.ticket});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.line),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '#${ticket.ticketNumber}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.navy900,
                  ),
                ),
                _buildStatusPill(ticket.status),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              ticket.displayTitle ?? '',
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: AppColors.navy900,
              ),
            ),
            if (ticket.customer != null) ...[
              const SizedBox(height: 6),
              Row(
                children: [
                  const Icon(Icons.phone_android_outlined, size: 14, color: AppColors.ink400),
                  const SizedBox(width: 6),
                  Text(
                    ticket.customer!.phone,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.ink600,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 6),
            Text(
              ticket.description ?? '',
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.ink600,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'MASTER DEALER DISPATCH & STEPPER ACTIONS',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: AppColors.ink400,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 12),
            LayoutBuilder(
              builder: (context, constraints) {
                final delegateBtn = ElevatedButton.icon(
                  onPressed: () {
                    // Below the app's ~900px desktop breakpoint, the
                    // fixed 540px dialog doesn't fit — use the
                    // full-screen page instead.
                    if (MediaQuery.of(context).size.width < 900) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => DelegateBranchPage(ticket: ticket)),
                      );
                    } else {
                      showDialog(
                        context: context,
                        builder: (dialogContext) => DelegateBranchDialog(ticket: ticket),
                      );
                    }
                  },
                  icon: const Icon(Icons.account_tree_outlined, size: 16),
                  label: const Text('Delegate Branch'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF006D77),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    elevation: 0,
                    textStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                  ),
                );

                final assignBtn = ElevatedButton.icon(
                  onPressed: () {
                    final cubit = context.read<DealerDashboardCubit>();
                    if (MediaQuery.of(context).size.width < 900) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => BlocProvider.value(
                            value: cubit,
                            child: AssignTechnicianPage(ticket: ticket),
                          ),
                        ),
                      );
                    } else {
                      showDialog(
                        context: context,
                        builder: (dialogContext) => BlocProvider.value(
                          value: cubit,
                          child: AssignTechnicianDialog(ticket: ticket),
                        ),
                      );
                    }
                  },
                  icon: const Icon(Icons.person_outline, size: 16),
                  label: const Text('Assign Tech'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6366F1),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    elevation: 0,
                    textStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                  ),
                );

                final completeBtn = ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.check_circle_outline, size: 16),
                  label: const Text('Complete Task'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.green500,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    elevation: 0,
                    textStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                  ),
                );

                if (constraints.maxWidth < 600) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          Expanded(child: delegateBtn),
                          const SizedBox(width: 8),
                          Expanded(child: assignBtn),
                        ],
                      ),
                      const SizedBox(height: 8),
                      completeBtn,
                    ],
                  );
                }

                return Row(
                  children: [
                    Expanded(child: delegateBtn),
                    const SizedBox(width: 8),
                    Expanded(child: assignBtn),
                    const SizedBox(width: 8),
                    Expanded(child: completeBtn),
                  ],
                );
              },
            ),
            const SizedBox(height: 32),
            _buildTechnicianInfo(),
            const SizedBox(height: 32),
            const Text(
              'Vertical Stepper Status',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppColors.navy900,
              ),
            ),
            const SizedBox(height: 16),
            DealerComplaintStepper(milestones: ticket.stepperMilestones),
            const SizedBox(height: 32),
            const Text(
              'Timeline Log',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppColors.navy900,
              ),
            ),
            const SizedBox(height: 16),
            _buildTimeline(ticket.timelineEvents),
            const SizedBox(height: 48),
            const Align(
              alignment: Alignment.centerRight,
              child: Text(
                'Customer synced',
                style: TextStyle(fontSize: 12, color: AppColors.ink400),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeline(List<DealerTimelineEvent> events) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: events.length,
      itemBuilder: (context, index) {
        final event = events[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: AppColors.blue500,
                      shape: BoxShape.circle,
                    ),
                  ),
                  if (index != events.length - 1)
                    Container(
                      width: 2,
                      height: 40,
                      color: AppColors.line,
                    ),
                ],
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      event.title,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.navy900),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      event.description,
                      style: const TextStyle(fontSize: 12, color: AppColors.ink600),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      event.timestamp,
                      style: const TextStyle(fontSize: 10, color: AppColors.ink400),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTechnicianInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Technician on Job:',
                style: TextStyle(fontSize: 13, color: AppColors.ink600),
              ),
              Text(
                ticket.firstTechName != null ? '1 assigned' : '0 assigned',
                style: const TextStyle(fontSize: 13, color: AppColors.orange500, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          if (ticket.assignedTechnicians.isNotEmpty) ...[
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ticket.assignedTechnicians.first.name,
                        style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.navy900, fontSize: 14),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        ticket.assignedTechnicians.first.phone,
                        style: const TextStyle(fontSize: 12, color: AppColors.ink400),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.green100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'On job',
                    style: TextStyle(color: AppColors.green500, fontSize: 11, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatusPill(String status) {
    Color color;
    Color bgColor;
    switch (status) {
      case 'In Progress':
        color = AppColors.orange500;
        bgColor = AppColors.orange100;
        break;
      case 'Assigned to Handler':
        color = AppColors.orange500;
        bgColor = AppColors.orange100;
        break;
      case 'Closed':
        color = AppColors.green500;
        bgColor = AppColors.green100;
        break;
      default:
        color = AppColors.ink600;
        bgColor = AppColors.bg;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status,
        style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.bold),
      ),
    );
  }
}