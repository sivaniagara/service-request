import 'package:flutter/material.dart';
import '../../data/models/technician_ticket_model.dart';
import 'technician_ticket_list_sidebar.dart';
import 'technician_ticket_detail_view.dart';

class TechnicianServiceRequestsView extends StatefulWidget {
  final List<TechnicianTicket> tickets;
  final String initialTicketId;
  final Function(String ticketId, String status) onStatusUpdate;
  final Function(String ticketId, String mode) onSupportModeChange;

  const TechnicianServiceRequestsView({
    super.key,
    required this.tickets,
    this.initialTicketId = '',
    required this.onStatusUpdate,
    required this.onSupportModeChange,
  });

  @override
  State<TechnicianServiceRequestsView> createState() => _TechnicianServiceRequestsViewState();
}

class _TechnicianServiceRequestsViewState extends State<TechnicianServiceRequestsView> {
  late String _selectedTicketId;

  @override
  void initState() {
    super.initState();
    _selectedTicketId = widget.initialTicketId.isNotEmpty 
        ? widget.initialTicketId 
        : (widget.tickets.isNotEmpty ? widget.tickets.first.ticketId : '');
  }

  @override
  void didUpdateWidget(TechnicianServiceRequestsView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialTicketId.isNotEmpty && widget.initialTicketId != oldWidget.initialTicketId) {
      _selectedTicketId = widget.initialTicketId;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.tickets.isEmpty) {
      return const Center(child: Text('No assigned tickets found.'));
    }

    final selectedTicket = widget.tickets.firstWhere(
      (t) => t.ticketId == _selectedTicketId,
      orElse: () => widget.tickets.first,
    );

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: TechnicianTicketListSidebar(
              tickets: widget.tickets,
              selectedTicketId: _selectedTicketId,
              onTicketSelected: (id) => setState(() => _selectedTicketId = id),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            flex: 3,
            child: TechnicianTicketDetailView(
              ticket: selectedTicket,
              onStatusUpdate: (status) => widget.onStatusUpdate(_selectedTicketId, status),
              onSupportModeChange: (mode) => widget.onSupportModeChange(_selectedTicketId, mode),
            ),
          ),
        ],
      ),
    );
  }
}
