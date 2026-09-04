import 'package:flutter/material.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_theme.dart';
import '../../data/models/dealer_technician_model.dart';
import '../../data/models/dealer_ticket_model.dart';
import '../bloc/dealer_dashboard_cubit.dart';
import '../bloc/dealer_dashboard_state.dart';

class AssignTechnicianDialog extends StatefulWidget {
  final DealerTicketDetail ticket;

  const AssignTechnicianDialog({super.key, required this.ticket});

  @override
  State<AssignTechnicianDialog> createState() => _AssignTechnicianDialogState();
}

class _AssignTechnicianDialogState extends State<AssignTechnicianDialog> {
  final Set<String> _selectedTechIds = {};
  final _notesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<DealerDashboardCubit>().loadTechnicians();
    
    // Auto-select technicians if any are already assigned
    if (widget.ticket.assignedTechnicians.isNotEmpty) {
      _selectedTechIds.addAll(
        widget.ticket.assignedTechnicians.map((t) => t.technicianId),
      );
    }
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Container(
        width: 600,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHeader(context),
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTargetTicketInfo(),
                    const SizedBox(height: 24),
                    const Text(
                      'Select Field Technician',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.navy900,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildTechnicianList(),
                    const SizedBox(height: 24),
                    _buildNotesField(),
                    const SizedBox(height: 24),
                    _buildNotificationBanner(),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
            _buildFooter(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: const BoxDecoration(
              color: Color(0xFF6366F1),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Assign Service Technician',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.navy900,
                  ),
                ),
                const SizedBox(height: 4),
                RichText(
                  text: const TextSpan(
                    style: TextStyle(fontSize: 13, color: AppColors.ink400),
                    children: [
                      TextSpan(text: 'Select a certified technician from '),
                      TextSpan(
                        text: 'Green Sprout Agro',
                        style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.navy900),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.close, color: AppColors.ink400),
            padding: EdgeInsets.zero,
          ),
        ],
      ),
    );
  }

  Widget _buildTargetTicketInfo() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.blue500.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.blue100),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'TARGET TICKET',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: AppColors.blue500,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '#${widget.ticket.ticketNumber} — ${widget.ticket.displayTitle}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.navy900,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text(
                'REQUIRED SKILLS',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: AppColors.blue500,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 6),
              Row(
                children: widget.ticket.requiredSkills.map((skill) => Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: _buildSkillBadge(skill),
                )).toList(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSkillBadge(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: AppColors.line),
      ),
      child: Text(
        label,
        style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.ink600),
      ),
    );
  }

  Widget _buildTechnicianList() {
    return BlocBuilder<DealerDashboardCubit, DealerDashboardState>(
      builder: (context, state) {
        if (state.isTechniciansLoading) {
          return const Center(child: Padding(
            padding: EdgeInsets.all(32.0),
            child: CircularProgressIndicator(),
          ));
        }

        final technicians = state.technicians ?? [];
        if (technicians.isEmpty) {
          return const Center(child: Text('No technicians available'));
        }

        return Column(
          children: technicians.map((tech) => _buildTechnicianItem(tech)).toList(),
        );
      },
    );
  }

  Widget _buildTechnicianItem(DealerTechnician tech) {
    final isSelected = _selectedTechIds.contains(tech.technicianId);
    return GestureDetector(
      onTap: () {
        setState(() {
          if (isSelected) {
            _selectedTechIds.remove(tech.technicianId);
          } else {
            _selectedTechIds.add(tech.technicianId);
          }
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? const Color(0xFF6366F1) : AppColors.line,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected ? [
            BoxShadow(
              color: const Color(0xFF6366F1).withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            )
          ] : null,
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: AppColors.navy900,
              child: Text(
                _getInitials(tech.name),
                style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        tech.name,
                        style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.navy900, fontSize: 14),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${tech.rating}★',
                        style: const TextStyle(color: Color(0xFF6366F1), fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                      if (tech.travelDistance != null) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.blue100.withValues(alpha: 0.5),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            tech.travelDistance!,
                            style: const TextStyle(color: AppColors.blue500, fontSize: 9, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                      if (tech.totalResolved > 20) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.green.shade50,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            'Expert',
                            style: TextStyle(color: Colors.green, fontSize: 9, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ]
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${tech.phone}  ·  ${tech.currentlyAssignedCount} active tickets',
                    style: const TextStyle(color: AppColors.ink400, fontSize: 12),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: tech.skills.map((s) => Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.bg,
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: AppColors.line),
                      ),
                      child: Text(
                        s,
                        style: const TextStyle(color: AppColors.ink600, fontSize: 10, fontWeight: FontWeight.w500),
                      ),
                    )).toList(),
                  ),
                ],
              ),
            ),
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFF6366F1) : Colors.white,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: isSelected ? const Color(0xFF6366F1) : AppColors.line, width: 2),
              ),
              child: isSelected ? const Icon(Icons.check, size: 16, color: Colors.white) : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotesField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Dispatch Instructions / Field Notes (Optional)',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: AppColors.navy900,
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _notesController,
          maxLines: 3,
          decoration: InputDecoration(
            hintText: 'Add instructions for the technician...',
            hintStyle: const TextStyle(color: AppColors.ink400, fontSize: 13),
            filled: true,
            fillColor: Colors.grey.shade50,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.line),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.line),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNotificationBanner() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.blue500.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.blue100),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.auto_awesome_outlined, color: AppColors.blue500, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: const TextStyle(fontSize: 12, color: AppColors.ink600, height: 1.4),
                children: [
                  const TextSpan(
                    text: 'Instant Customer Notification: ',
                    style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.blue500),
                  ),
                  const TextSpan(text: 'Once dispatched, the customer will see '),
                  TextSpan(
                    text: _selectedTechIds.isEmpty
                        ? 'the technicians'
                        : _selectedTechIds.length == 1
                            ? context.read<DealerDashboardCubit>().state.technicians?.firstWhere((t) => t.technicianId == _selectedTechIds.first).name ?? 'the technician'
                            : '${_selectedTechIds.length} technicians',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const TextSpan(text: ' listed on their ticket page with direct contact details and live stepper progression.'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: AppColors.line)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            ),
            child: const Text(
              'Cancel',
              style: TextStyle(color: AppColors.ink600, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 16),
          ElevatedButton(
            onPressed: _selectedTechIds.isEmpty
                ? null 
                : () async {
                    // Show Loading
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) => const Center(child: CircularProgressIndicator()),
                    );

                    try {
                      await context.read<DealerDashboardCubit>().assignTechnicians(
                        widget.ticket.ticketId,
                        _selectedTechIds.toList(),
                        _notesController.text,
                      );

                      // Close loading
                      if (context.mounted) Navigator.pop(context);

                      // Show Success
                      if (context.mounted) {
                        AwesomeDialog(
                          context: context,
                          dialogType: DialogType.success,
                          animType: AnimType.bottomSlide,
                          title: 'Dispatch Successful',
                          desc: 'The technician has been assigned and notified.',
                          btnOkOnPress: () {
                            Navigator.pop(context); // Close AssignTechnicianDialog
                          },
                          width: 400,
                        ).show();
                      }
                    } catch (e) {
                      // Close loading
                      if (context.mounted) Navigator.pop(context);

                      // Show Error
                      if (context.mounted) {
                        AwesomeDialog(
                          context: context,
                          dialogType: DialogType.error,
                          animType: AnimType.bottomSlide,
                          title: 'Dispatch Failed',
                          desc: e.toString(),
                          btnOkOnPress: () {},
                          width: 400,
                        ).show();
                      }
                    }
                  },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4F46E5),
              foregroundColor: Colors.white,
              disabledBackgroundColor: const Color(0xFFEDF0F6),
              disabledForegroundColor: const Color(0xFF95A0B4),
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 0,
            ),
            child: const Text(
              'Dispatch Technician →',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  String _getInitials(String name) {
    final parts = name.split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return parts[0][0].toUpperCase();
  }
}
