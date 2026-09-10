import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../data/models/dashboard_models.dart';
import '../widgets/complaints/ticket_detail_view.dart';

class TicketDetailPage extends StatelessWidget {
  final ServiceTicketDetail ticket;

  const TicketDetailPage({super.key, required this.ticket});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        title: Text(
          'Ticket #${ticket.ticketNumber}',
          style: const TextStyle(fontWeight: FontWeight.w900, color: Color(0xFF14274E), fontSize: 18),
        ),
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF14274E)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: TicketDetailView(ticket: ticket),
        ),
      ),
    );
  }
}
