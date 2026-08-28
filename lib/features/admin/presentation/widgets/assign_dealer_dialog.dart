import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_theme.dart';
import '../../data/models/admin_ticket_detail_model.dart';
import '../../data/models/admin_ticket_model.dart';
import '../bloc/admin_dashboard_cubit.dart';
import '../bloc/admin_dashboard_state.dart';

class AssignDealerDialog extends StatefulWidget {
  final AdminTicketDetailData ticket;

  const AssignDealerDialog({super.key, required this.ticket});

  @override
  State<AssignDealerDialog> createState() => _AssignDealerDialogState();
}

class _AssignDealerDialogState extends State<AssignDealerDialog> {
  final Set<String> _selectedDealerIds = {};
  final _instructionsController = TextEditingController();

  @override
  void dispose() {
    _instructionsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdminDashboardCubit, AdminDashboardState>(
      builder: (context, state) {
        final dealers = state.dealerList ?? [];

        return Dialog(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          insetPadding: const EdgeInsets.symmetric(horizontal: 40, vertical: 24),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          child: Container(
            width: 700,
            constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.9),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Fixed Header
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
                  child: _buildHeader(context),
                ),
                const Divider(height: 1, color: Color(0xFFEDF0F6)),
                
                // Scrollable Content
                Flexible(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildTicketInfoCard(),
                        const SizedBox(height: 24),
                        _buildDealerSelectionHeader(),
                        const SizedBox(height: 12),
                        ...dealers.map((dealer) => Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: _buildDealerItem(dealer),
                        )),
                        const SizedBox(height: 24),
                        _buildInstructionsField(),
                        const SizedBox(height: 20),
                        _buildSyncInfoBox(),
                      ],
                    ),
                  ),
                ),
                
                const Divider(height: 1, color: Color(0xFFEDF0F6)),
                // Fixed Footer
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: _buildFooter(context),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Color(0xFF7C6CF0),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 10),
                const Text(
                  'Assign Service Handler',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF14274E),
                    letterSpacing: -0.5,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              'Ticket #${widget.ticket.ticketNumber}',
              style: const TextStyle(
                color: Color(0xFF5B6478),
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.close, size: 18),
          style: IconButton.styleFrom(
            backgroundColor: const Color(0xFFF4F6FB),
            padding: const EdgeInsets.all(10),
          ),
        ),
      ],
    );
  }

  Widget _buildTicketInfoCard() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFF4F6FB).withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFEDF0F6)),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: _buildInfoItem('ISSUE TITLE', widget.ticket.title),
          ),
          const SizedBox(width: 24),
          Expanded(
            flex: 2,
            child: _buildInfoItem('LOCATION', widget.ticket.customer.siteLocation),
          ),
          const SizedBox(width: 24),
          _buildInfoItem(
            'PRIORITY',
            widget.ticket.priority,
            valueColor: _getPriorityColor(widget.ticket.priority),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(String label, String value, {Color? valueColor}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 9,
            fontWeight: FontWeight.w900,
            color: Color(0xFF95A0B4),
            letterSpacing: 0.8,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w900,
            color: valueColor ?? const Color(0xFF14274E),
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildDealerSelectionHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        RichText(
          text: const TextSpan(
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: Color(0xFF14274E)),
            children: [
              TextSpan(text: 'Select Dealers '),
              TextSpan(
                text: '(Multiple allowed)',
                style: TextStyle(color: Color(0xFF7C6CF0), fontWeight: FontWeight.w600, fontSize: 12),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0xFFE7E3FD),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            '${_selectedDealerIds.length} selected',
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w900,
              color: Color(0xFF7C6CF0),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDealerItem(DealerListItem dealer) {
    final isSelected = _selectedDealerIds.contains(dealer.dealerId);
    return InkWell(
      onTap: () {
        setState(() {
          if (isSelected) {
            _selectedDealerIds.remove(dealer.dealerId);
          } else {
            _selectedDealerIds.add(dealer.dealerId);
          }
        });
      },
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFE7E3FD).withValues(alpha: 0.15) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? const Color(0xFF7C6CF0) : const Color(0xFFEDF0F6),
            width: isSelected ? 1.5 : 1.2,
          ),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: _getAvatarColor(dealer.name),
              child: Text(
                dealer.name.split(' ').map((e) => e[0]).take(2).join(),
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 11),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        dealer.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF14274E),
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '${dealer.rating}',
                        style: const TextStyle(
                          color: Color(0xFFF0A72A),
                          fontWeight: FontWeight.w900,
                          fontSize: 12,
                        ),
                      ),
                      const Icon(Icons.star, color: Color(0xFFF0A72A), size: 12),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      const Icon(Icons.location_on_outlined, size: 12, color: Color(0xFF95A0B4)),
                      const SizedBox(width: 4),
                      Text(
                        dealer.region,
                        style: const TextStyle(color: Color(0xFF5B6478), fontSize: 11, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(width: 12),
                      const Icon(Icons.people_outline, size: 12, color: Color(0xFF7C6CF0)),
                      const SizedBox(width: 4),
                      Text(
                        '${dealer.techniciansCount} Field Team',
                        style: const TextStyle(
                          color: Color(0xFF7C6CF0),
                          fontSize: 11,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFF7C6CF0) : Colors.white,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                  color: isSelected ? const Color(0xFF7C6CF0) : const Color(0xFF95A0B4),
                  width: 1.2,
                ),
              ),
              child: isSelected
                  ? const Icon(Icons.check, color: Colors.white, size: 14)
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInstructionsField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Assignment Instructions (Optional)',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w900,
            color: Color(0xFF14274E),
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _instructionsController,
          maxLines: 2,
          style: const TextStyle(fontSize: 13, color: Color(0xFF14274E), fontWeight: FontWeight.w500),
          decoration: InputDecoration(
            hintText: 'e.g. Priority SLA for on-site diagnostic within 24 hours.',
            hintStyle: const TextStyle(color: Color(0xFF95A0B4), fontSize: 12),
            fillColor: Colors.white,
            filled: true,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFEDF0F6), width: 1.5),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF7C6CF0), width: 2),
            ),
            contentPadding: const EdgeInsets.all(16),
          ),
        ),
      ],
    );
  }

  Widget _buildSyncInfoBox() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFE7E3FD).withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE7E3FD), width: 1.2),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.auto_awesome, color: Color(0xFF7C6CF0), size: 18),
          const SizedBox(width: 12),
          Expanded(
            child: RichText(
              text: const TextSpan(
                style: TextStyle(color: Color(0xFF7C6CF0), fontSize: 12, height: 1.5, fontWeight: FontWeight.w500),
                children: [
                  TextSpan(text: 'Real-time sync: ', style: TextStyle(fontWeight: FontWeight.w900)),
                  TextSpan(
                    text: 'Once assigned, the status will automatically update for both Customer and Dealer apps.',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () => Navigator.pop(context),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              side: const BorderSide(color: Color(0xFFEDF0F6), width: 1.5),
            ),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Color(0xFF5B6478), fontWeight: FontWeight.w900, fontSize: 14),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton(
            onPressed: _selectedDealerIds.isEmpty
                ? null
                : () {
                    Navigator.pop(context);
                  },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF7C6CF0),
              foregroundColor: Colors.white,
              disabledBackgroundColor: const Color(0xFFEDF0F6),
              disabledForegroundColor: const Color(0xFF95A0B4),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 0,
            ),
            child: const Text(
              'Confirm →',
              style: TextStyle(fontWeight: FontWeight.w900, fontSize: 14),
            ),
          ),
        ),
      ],
    );
  }

  Color _getAvatarColor(String name) {
    if (name.contains('Green')) return const Color(0xFF14274E);
    if (name.contains('Sunrise')) return const Color(0xFF3B82F6);
    if (name.contains('Agro')) return const Color(0xFFF59E0B);
    return const Color(0xFF7C6CF0);
  }

  Color _getPriorityColor(String priority) {
    if (priority.toLowerCase() == 'critical') return const Color(0xFFEF4444);
    if (priority.toLowerCase() == 'high') return const Color(0xFFF59E0B);
    return const Color(0xFF3B82F6);
  }
}
