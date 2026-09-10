import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_theme.dart';
import '../../data/models/dealer_ticket_model.dart';
import '../bloc/dealer_dashboard_cubit.dart';
import '../widgets/tickets/dealer_ticket_detail_view.dart';
import '../../../../injection_container.dart';

class DealerTicketDetailPage extends StatelessWidget {
  final DealerTicketDetail ticket;

  const DealerTicketDetailPage({super.key, required this.ticket});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: sl<DealerDashboardCubit>(),
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
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: DealerTicketDetailView(ticket: ticket),
        ),
      ),
    );
  }
}
