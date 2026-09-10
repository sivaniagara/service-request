import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_theme.dart';
import '../../data/models/technician_ticket_model.dart';
import '../bloc/technician_dashboard_cubit.dart';
import '../bloc/technician_dashboard_state.dart';
import '../widgets/technician_ticket_detail_view.dart';
import '../../../../injection_container.dart';

class TechnicianTicketDetailPage extends StatelessWidget {
  final String ticketId;
  final Function(String mode) onSupportModeChange;
  final Function() onTaskComplete;

  const TechnicianTicketDetailPage({
    super.key,
    required this.ticketId,
    required this.onSupportModeChange,
    required this.onTaskComplete,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TechnicianDashboardCubit, TechnicianDashboardState>(
      builder: (context, state) {
        final ticket = state.selectedTicketDetail;

        if (state.error != null && ticket == null) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0.5,
              title: const Text('Error', style: TextStyle(color: AppColors.navy900, fontWeight: FontWeight.w900, fontSize: 18)),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: AppColors.navy900),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, color: AppColors.red500, size: 48),
                  const SizedBox(height: 16),
                  Text('Error: ${state.error}', textAlign: TextAlign.center),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => context.read<TechnicianDashboardCubit>().loadTicketDetail(ticketId),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          );
        }

        // Only show full-screen loader if we have NO ticket or the WRONG ticket
        if (ticket == null || (state.isDetailLoading && ticket.ticketId != ticketId)) {
          return const Scaffold(
            backgroundColor: AppColors.bg,
            body: Center(child: CircularProgressIndicator()),
          );
        }

        return Scaffold(
          backgroundColor: AppColors.bg,
          appBar: AppBar(
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.white,
            elevation: 0.5,
            title: Text(
              'Ticket #${ticket.ticketNumber}',
              style: const TextStyle(
                color: AppColors.navy900,
                fontWeight: FontWeight.w900,
                fontSize: 18,
              ),
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: AppColors.navy900),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: TechnicianTicketDetailView(
              ticket: ticket,
              onSupportModeChange: onSupportModeChange,
              onTaskComplete: onTaskComplete,
            ),
          ),
        );
      },
    );
  }
}