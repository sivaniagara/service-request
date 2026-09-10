import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_theme.dart';
import '../../data/models/technician_ticket_model.dart';
import '../bloc/technician_dashboard_cubit.dart';
import '../widgets/technician_ticket_detail_view.dart';
import '../../../../injection_container.dart';

class TechnicianTicketDetailPage extends StatelessWidget {
  final TechnicianTicketDetail ticket;
  final Function(String status, {String? notes, List<String>? photos}) onStatusUpdate;
  final Function(String mode) onSupportModeChange;
  final Function() onTaskComplete;

  const TechnicianTicketDetailPage({
    super.key,
    required this.ticket,
    required this.onStatusUpdate,
    required this.onSupportModeChange,
    required this.onTaskComplete,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: sl<TechnicianDashboardCubit>(),
      child: Scaffold(
        backgroundColor: AppColors.bg,
        appBar: AppBar(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
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
          elevation: 0,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: TechnicianTicketDetailView(
            ticket: ticket,
            onStatusUpdate: onStatusUpdate,
            onSupportModeChange: onSupportModeChange,
            onTaskComplete: onTaskComplete,
          ),
        ),
      ),
    );
  }
}
