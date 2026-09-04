import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/widgets/app_card.dart';
import '../../data/models/technician_ticket_model.dart';
import '../bloc/technician_dashboard_cubit.dart';
import '../bloc/technician_dashboard_state.dart';
import 'technician_ticket_list_sidebar.dart';
import 'technician_ticket_detail_view.dart';

class TechnicianServiceRequestsView extends StatefulWidget {
  final List<TechnicianTicket> tickets;
  final String initialTicketId;
  final Function(String ticketId, String status, {String? notes, List<String>? photos}) onStatusUpdate;
  final Function(String ticketId, String mode) onSupportModeChange;
  final Function(String ticketId) onTaskComplete;

  const TechnicianServiceRequestsView({
    super.key,
    required this.tickets,
    this.initialTicketId = '',
    required this.onStatusUpdate,
    required this.onSupportModeChange,
    required this.onTaskComplete,
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
        
    if (_selectedTicketId.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<TechnicianDashboardCubit>().loadTicketDetail(_selectedTicketId);
      });
    }
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

    return BlocBuilder<TechnicianDashboardCubit, TechnicianDashboardState>(
      builder: (context, state) {
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
                  onTicketSelected: (id) {
                    setState(() => _selectedTicketId = id);
                    context.read<TechnicianDashboardCubit>().loadTicketDetail(id);
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 3,
                child: _buildDetailContent(state),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDetailContent(TechnicianDashboardState state) {
    if (state.isDetailLoading) {
      return const AppCard(child: Center(child: CircularProgressIndicator()));
    }

    if (state.selectedTicketDetail == null) {
      return const AppCard(child: Center(child: Text('Select a ticket to view details')));
    }

    // Ensure we are showing details for the selected ticket
    if (state.selectedTicketDetail!.ticketId != _selectedTicketId) {
      return const AppCard(child: Center(child: CircularProgressIndicator()));
    }

    return TechnicianTicketDetailView(
      ticket: state.selectedTicketDetail!,
      onStatusUpdate: (status, {notes, photos}) => widget.onStatusUpdate(_selectedTicketId, status, notes: notes, photos: photos),
      onSupportModeChange: (mode) => widget.onSupportModeChange(_selectedTicketId, mode),
      onTaskComplete: () => widget.onTaskComplete(_selectedTicketId),
    );
  }
}
