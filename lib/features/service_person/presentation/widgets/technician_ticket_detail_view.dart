import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/status_pill.dart';
import '../../data/models/technician_ticket_model.dart';

class TechnicianTicketDetailView extends StatefulWidget {
  final TechnicianTicketDetail ticket;
  final Function(String status, {String? notes, List<String>? photos}) onStatusUpdate;
  final Function(String mode) onSupportModeChange;
  final VoidCallback onTaskComplete;

  const TechnicianTicketDetailView({
    super.key,
    required this.ticket,
    required this.onStatusUpdate,
    required this.onSupportModeChange,
    required this.onTaskComplete,
  });

  @override
  State<TechnicianTicketDetailView> createState() => _TechnicianTicketDetailViewState();
}

class _TechnicianTicketDetailViewState extends State<TechnicianTicketDetailView> {
  final TextEditingController _notesController = TextEditingController();

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: EdgeInsets.zero,
      borderRadius: 12,
      child: Column(
        children: [
          _buildHeader(),
          const Divider(height: 1, color: AppColors.line),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Issues',
                    style: TextStyle(
                      color: AppColors.navy900,
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  _buildTicketInfo(),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      _buildSectionHeader('SUPPORT MODE'),
                      if (widget.ticket.supportMode == null || widget.ticket.supportMode!.isEmpty)
                        const Padding(
                          padding: EdgeInsets.only(left: 8),
                          child: Text(
                            '(Required)',
                            style: TextStyle(
                              color: AppColors.red500,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      _buildModeOption('visit', 'Site Visit', Icons.location_on_outlined),
                      const SizedBox(width: 16),
                      _buildModeOption('remote', 'Remote Support', Icons.videocam_outlined),
                    ],
                  ),
                  const SizedBox(height: 40),
                  const Text(
                    'Service Progress',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      color: AppColors.navy900,
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildStepper(widget.ticket.stepperMilestones),
                  const SizedBox(height: 48),
                  if (widget.ticket.customer != null) ...[
                    _buildSectionHeader('CUSTOMER CONTACT'),
                    const SizedBox(height: 16),
                    _buildCustomerContact(),
                    const SizedBox(height: 20),
                  ],
                  const SizedBox(height: 16),
                  _buildClosureSection(),
                  const SizedBox(height: 16),
                  _buildSectionHeader('TIMELINE LOG'),
                  const SizedBox(height: 16),
                  _buildTimeline(widget.ticket.timelineEvents),

                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w900,
        color: AppColors.ink400,
        letterSpacing: 0.8,
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '#${widget.ticket.ticketNumber}',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  color: AppColors.navy900,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Assigned on ${widget.ticket.createdAt}',
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.ink400,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          StatusPill.ticketStatus(widget.ticket.status),
        ],
      ),
    );
  }

  Widget _buildTicketInfo() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: widget.ticket.issueCategory.map((cat) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.bg,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          cat,
          style: const TextStyle(
            color: AppColors.navy900,
            fontSize: 13,
            fontWeight: FontWeight.w900,
          ),
        ),
      )).toList(),
    );
  }

  Widget _buildModeOption(String value, String label, IconData icon) {
    final currentMode = widget.ticket.supportMode?.toLowerCase();
    final isSelected = currentMode == value.toLowerCase();

    return Expanded(
      child: InkWell(
        onTap: isSelected ? null : () => widget.onSupportModeChange(value),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.blue100.withOpacity(0.3) : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? AppColors.blue500 : AppColors.line,
              width: isSelected ? 2 : 1.5,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 20,
                color: isSelected ? AppColors.blue500 : AppColors.ink400,
              ),
              const SizedBox(width: 12),
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? AppColors.blue500 : AppColors.ink600,
                  fontSize: 14,
                  fontWeight: isSelected ? FontWeight.w900 : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppColors.ink400,
            fontSize: 12,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.w900,
            fontSize: 15,
            color: AppColors.navy900,
          ),
        ),
      ],
    );
  }

  Widget _buildStepper(List<TicketMilestone> milestones) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: milestones.length,
      itemBuilder: (context, index) {
        final m = milestones[index];
        final isCompleted = m.status == 'done' || m.status == 'completed';
        final isCurrent = m.status == 'current';
        
        return IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: isCompleted ? AppColors.green500 : Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isCompleted ? AppColors.green500 : AppColors.line,
                        width: 2,
                      ),
                    ),
                    child: isCompleted
                        ? const Icon(Icons.check, color: Colors.white, size: 16)
                        : (isCurrent ? const Center(child: Icon(Icons.radio_button_checked, size: 16, color: AppColors.blue500)) : null),
                  ),
                  if (index != milestones.length - 1)
                    Expanded(
                      child: Container(
                        width: 2.5,
                        color: isCompleted ? AppColors.green500 : AppColors.line,
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        m.title,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w900,
                          color: isCompleted || isCurrent ? AppColors.navy900 : AppColors.ink400,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        m.description,
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.ink600,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      if (m.updatedAt != null) ...[
                        const SizedBox(height: 6),
                        Text(
                          m.updatedAt!,
                          style: const TextStyle(
                            fontSize: 11,
                            color: AppColors.ink400,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCustomerContact() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.line),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: AppColors.blue100,
            child: Text(
              widget.ticket.customer!.name[0],
              style: const TextStyle(
                color: AppColors.blue500,
                fontWeight: FontWeight.w900,
                fontSize: 18,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.ticket.customer!.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 15,
                    color: AppColors.navy900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.ticket.customer!.phone,
                  style: const TextStyle(
                    color: AppColors.ink600,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.phone, color: AppColors.green500),
            style: IconButton.styleFrom(
              backgroundColor: AppColors.bg,
              padding: const EdgeInsets.all(10),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.chat_bubble_outline, color: AppColors.blue500),
            style: IconButton.styleFrom(
              backgroundColor: AppColors.bg,
              padding: const EdgeInsets.all(10),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeline(List<TicketTimelineEvent> events) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: events.length,
      itemBuilder: (context, index) {
        final event = events[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 24),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 4),
                width: 10,
                height: 10,
                decoration: const BoxDecoration(
                  color: AppColors.blue500,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      event.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 14,
                        color: AppColors.navy900,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      event.description,
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.ink600,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '${event.timestamp} • ${event.actor}',
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.ink400,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildClosureSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // const Text(
        //   'Close Out Job',
        //   style: TextStyle(
        //     fontSize: 18,
        //     fontWeight: FontWeight.w900,
        //     color: AppColors.navy900,
        //   ),
        // ),
        // const SizedBox(height: 24),
        // _buildSectionHeader('DIAGNOSIS NOTES'),
        // const SizedBox(height: 12),
        // TextField(
        //   controller: _notesController,
        //   maxLines: 4,
        //   style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        //   decoration: InputDecoration(
        //     hintText: 'Describe root cause and resolution...',
        //     hintStyle: const TextStyle(color: AppColors.ink400, fontWeight: FontWeight.w400),
        //     fillColor: Colors.white,
        //     border: OutlineInputBorder(
        //       borderRadius: BorderRadius.circular(12),
        //       borderSide: const BorderSide(color: AppColors.line),
        //     ),
        //   ),
        // ),
        // const SizedBox(height: 24),
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //   children: [
        //     _buildSectionHeader('WORK PROOF'),
        //     TextButton.icon(
        //       onPressed: () {},
        //       icon: const Icon(Icons.add_a_photo, size: 16),
        //       label: const Text('Add Photo', style: TextStyle(fontWeight: FontWeight.w900)),
        //     ),
        //   ],
        // ),
        // const SizedBox(height: 12),
        // Wrap(
        //   spacing: 12,
        //   children: [
        //     ...widget.ticket.attachedPhotos.map((url) => _buildPhotoPlaceholder()),
        //     _buildAddPhotoPlaceholder(),
        //   ],
        // ),
        // const SizedBox(height: 40),
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: (widget.ticket.supportMode == null || widget.ticket.supportMode!.isEmpty)
                    ? null
                    : widget.onTaskComplete,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.blue500,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: AppColors.line,
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
                child: const Text(
                  'Complete Technician Task',
                  style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
                ),
              ),
            ),
            const SizedBox(width: 12),
          ],
        ),
      ],
    );
  }

  Widget _buildPhotoPlaceholder() {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: AppColors.bg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.line),
      ),
      child: const Icon(Icons.image, color: AppColors.ink400),
    );
  }

  Widget _buildAddPhotoPlaceholder() {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.line, style: BorderStyle.solid),
      ),
      child: const Icon(Icons.add, color: AppColors.ink400),
    );
  }
}
