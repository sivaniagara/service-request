import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../data/models/admin_ticket_detail_model.dart';
import '../../bloc/admin_dashboard_cubit.dart';
import '../../bloc/admin_dashboard_state.dart';
import '../admin_audit_timeline.dart';
import '../admin_complaint_stepper.dart';
import '../assign_dealer_dialog.dart';

class AdminTicketDetailView extends StatelessWidget {
  final AdminTicketDetailData ticket;

  const AdminTicketDetailView({super.key, required this.ticket});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AdminDashboardCubit, AdminDashboardState>(
      listenWhen: (previous, current) =>
          previous.verifyCompletionSuccess != current.verifyCompletionSuccess ||
          previous.isVerifyingCompletion != current.isVerifyingCompletion ||
          previous.otpSentSuccess != current.otpSentSuccess ||
          previous.closeTicketSuccess != current.closeTicketSuccess,
      listener: (context, state) {
        if (state.verifyCompletionSuccess == true) {
          AwesomeDialog(
            width: 500,
            context: context,
            dialogType: DialogType.success,
            animType: AnimType.bottomSlide,
            title: 'Verified!',
            desc: 'Ticket completion verified and moved to pending closure.',
            btnOkOnPress: () {},
          ).show();
        } else if (state.otpSentSuccess == true) {
          _showOtpVerificationDialog(context);
        } else if (state.closeTicketSuccess == true) {
          AwesomeDialog(
            width: 500,
            context: context,
            dialogType: DialogType.success,
            animType: AnimType.bottomSlide,
            title: 'Ticket Closed',
            desc: 'The ticket has been successfully resolved and closed.',
            btnOkOnPress: () {},
          ).show();
        } else if (state.error != null) {
          AwesomeDialog(
            width: 500,
            context: context,
            dialogType: DialogType.error,
            animType: AnimType.bottomSlide,
            title: 'Action Failed',
            desc: state.error,
            btnOkOnPress: () {},
          ).show();
        }
      },
      child: Container(
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
              LayoutBuilder(
                builder: (context, constraints) {
                  final assignButton = ElevatedButton.icon(
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
                  );

                  final verifyButton = BlocBuilder<AdminDashboardCubit, AdminDashboardState>(
                    builder: (context, state) {
                      return ElevatedButton.icon(
                        onPressed: state.isVerifyingCompletion
                            ? null
                            : () => _showVerifyCompletionDialog(context),
                        icon: state.isVerifyingCompletion
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Icon(Icons.verified_outlined, size: 18),
                        label: Text(state.isVerifyingCompletion
                            ? 'Verifying...'
                            : 'Verify Completion'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.green500,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                      );
                    },
                  );

                  if (constraints.maxWidth < 450) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        assignButton,
                        const SizedBox(height: 12),
                        verifyButton,
                      ],
                    );
                  }

                  return Row(
                    children: [
                      Expanded(child: assignButton),
                      const SizedBox(width: 12),
                      Expanded(child: verifyButton),
                    ],
                  );
                },
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
            const SizedBox(height: 16),
            _buildCloseTicketButton(context),
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
      ),
    );
  }

  void _showVerifyCompletionDialog(BuildContext context) {
    final TextEditingController notesController = TextEditingController();

    AwesomeDialog(
      width: 500,
      context: context,
      dialogType: DialogType.warning,
      animType: AnimType.bottomSlide,
      title: 'Verify Completion',
      desc: 'Please provide notes on the verified work and preventive action taken.',
      body: Column(
        children: [
          const Text(
            'Verify Completion',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Provide notes on the verified work and preventive action.',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          TextField(
            controller: notesController,
            maxLines: 3,
            decoration: const InputDecoration(
              hintText: 'Enter preventive action/notes here...',
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.all(12),
            ),
          ),
        ],
      ),
      btnCancelOnPress: () {},
      btnOkOnPress: () {
        context.read<AdminDashboardCubit>().verifyCompletion(
              ticket.ticketId,
              notesController.text,
            );
      },
      btnOkText: 'Verify Now',
      btnOkColor: AppColors.green500,
    ).show();
  }

  Widget _buildCloseTicketButton(BuildContext context) {
    final isStep5Completed = ticket.stepperMilestones.any(
      (m) => m.stepOrder == 5 && (m.status.toLowerCase() == 'done' || m.status.toLowerCase() == 'completed'),
    );

    return BlocBuilder<AdminDashboardCubit, AdminDashboardState>(
      builder: (context, state) {
        return SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: state.isSendingOtp || state.isClosingTicket || ticket.status == 'Closed'
                ? null
                : () {
                    if (!isStep5Completed) {
                      AwesomeDialog(
                        width: 500,
                        context: context,
                        dialogType: DialogType.warning,
                        animType: AnimType.bottomSlide,
                        title: 'Verification Required',
                        desc:
                            'Step 5 (Company Verification) must be completed before you can close this ticket.',
                        btnOkText: 'Complete Verification',
                        btnOkOnPress: () => _showVerifyCompletionDialog(context),
                        btnCancelOnPress: () {},
                      ).show();
                    } else {
                      context.read<AdminDashboardCubit>().sendCloseOtp(ticket.ticketId);
                    }
                  },
            icon: state.isSendingOtp || state.isClosingTicket
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                  )
                : const Icon(Icons.check_circle_outline, size: 20),
            label: Text(ticket.status == 'Closed'
                ? 'Ticket Closed'
                : state.isSendingOtp
                    ? 'Sending OTP...'
                    : state.isClosingTicket
                        ? 'Closing...'
                        : 'Close Ticket (OTP Verified)'),
            style: ElevatedButton.styleFrom(
              backgroundColor: ticket.status == 'Closed' ? AppColors.ink400 : AppColors.navy900,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              elevation: 0,
            ),
          ),
        );
      },
    );
  }

  void _showOtpVerificationDialog(BuildContext context) {
    final TextEditingController otpController = TextEditingController();

    AwesomeDialog(
      width: 500,
      context: context,
      dialogType: DialogType.info,
      animType: AnimType.bottomSlide,
      title: 'Verify Customer OTP',
      desc: 'An OTP has been sent to the customer. Please enter it below to close the ticket.',
      body: Column(
        children: [
          const Text(
            'Enter Close Ticket OTP',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Ask the customer for the 6-digit OTP sent to their phone.',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          TextField(
            controller: otpController,
            keyboardType: TextInputType.number,
            maxLength: 6,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, letterSpacing: 8),
            decoration: const InputDecoration(
              hintText: '000000',
              counterText: '',
              border: OutlineInputBorder(),
            ),
          ),
        ],
      ),
      btnCancelOnPress: () {},
      btnOkOnPress: () {
        if (otpController.text.length == 6) {
          context.read<AdminDashboardCubit>().verifyCloseOtp(
                ticket.ticketId,
                otpController.text,
              );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please enter a valid 6-digit OTP')),
          );
        }
      },
      btnOkText: 'Verify & Close',
      btnOkColor: AppColors.navy900,
    ).show();
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
