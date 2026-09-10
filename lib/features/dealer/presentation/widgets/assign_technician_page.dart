import 'package:flutter/material.dart';
import '../../data/models/dealer_ticket_model.dart';
import 'assign_technician_dialog.dart';

/// Full-screen "Assign Technician" flow for phones — the desktop
/// dialog is a fixed 600px card, cramped for a phone-width technician
/// list with skill chips and photos.
class AssignTechnicianPage extends StatelessWidget {
  final DealerTicketDetail ticket;

  const AssignTechnicianPage({super.key, required this.ticket});

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
            child: AssignTechnicianDialog(ticket: ticket, isFullScreen: true),
          ),
        ),
      ),
    );
  }
}