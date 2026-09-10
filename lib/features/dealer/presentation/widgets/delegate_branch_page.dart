import 'package:flutter/material.dart';
import '../../data/models/dealer_ticket_model.dart';
import 'delegate_branch_dialog.dart';

/// Full-screen "Delegate to Sub-Dealer Branch" flow for phones — the
/// desktop dialog is a fixed 540px card.
class DelegateBranchPage extends StatelessWidget {
  final DealerTicketDetail ticket;

  const DelegateBranchPage({super.key, required this.ticket});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFF14274E),
        elevation: 0,
        centerTitle: false,
        title: const Text(
          'Delegate to Sub-Dealer',
          style: TextStyle(fontWeight: FontWeight.w900, color: Colors.white, fontSize: 16),
        ),
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
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
            child: DelegateBranchDialog(ticket: ticket, isFullScreen: true),
          ),
        ),
      ),
    );
  }
}