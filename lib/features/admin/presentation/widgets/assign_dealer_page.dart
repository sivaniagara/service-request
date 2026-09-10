import 'package:flutter/material.dart';
import '../../data/models/admin_ticket_detail_model.dart';
import 'assign_dealer_dialog.dart';

/// Full-screen "Assign Dealer" flow for phones.
///
/// The desktop [AssignDealerDialog] is a fixed-700px modal capped at
/// 90% of the viewport height — squeezed onto a phone, the dealer list
/// inside it becomes nearly unusable. This gives the same flow its own
/// screen with a real AppBar and full-height scroll.
class AssignDealerPage extends StatelessWidget {
  final AdminTicketDetailData ticket;

  const AssignDealerPage({super.key, required this.ticket});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 1,
        centerTitle: false,
        title: Text(
          'Ticket #${ticket.ticketNumber}',
          style: const TextStyle(fontWeight: FontWeight.w900, color: Color(0xFF14274E), fontSize: 15),
        ),
        leading: IconButton(
          icon: const Icon(Icons.close, color: Color(0xFF14274E)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          child: Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFE7E9EE)),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 20, offset: const Offset(0, 8)),
              ],
            ),
            child: AssignDealerDialog(ticket: ticket, isFullScreen: true),
          ),
        ),
      ),
    );
  }
}