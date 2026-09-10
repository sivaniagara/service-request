import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../admin/data/models/admin_ticket_detail_model.dart';
import '../bloc/admin_dashboard_cubit.dart';
import '../bloc/admin_dashboard_state.dart';
import '../widgets/tickets/admin_ticket_detail_view.dart';
import '../../../../injection_container.dart';

class AdminTicketDetailPage extends StatelessWidget {
  final AdminTicketDetailData ticket;
  final AdminDashboardCubit? cubit;

  const AdminTicketDetailPage({super.key, required this.ticket, this.cubit});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: cubit ?? sl<AdminDashboardCubit>(),
      child: Scaffold(
        backgroundColor: AppColors.bg,
        appBar: AppBar(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          title: BlocBuilder<AdminDashboardCubit, AdminDashboardState>(
            builder: (context, state) {
              final currentTicket = state.selectedTicketDetail ?? ticket;
              return Text(
                'Ticket #${currentTicket.ticketNumber}',
                style: const TextStyle(
                  color: AppColors.navy900,
                  fontWeight: FontWeight.w900,
                  fontSize: 18,
                ),
              );
            },
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.navy900),
            onPressed: () => Navigator.pop(context),
          ),
          elevation: 0,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: BlocBuilder<AdminDashboardCubit, AdminDashboardState>(
            builder: (context, state) {
              return AdminTicketDetailView(ticket: state.selectedTicketDetail ?? ticket);
            },
          ),
        ),
      ),
    );
  }
}
