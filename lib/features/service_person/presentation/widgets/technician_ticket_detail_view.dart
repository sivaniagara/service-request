import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/status_pill.dart';
import '../../data/models/technician_ticket_model.dart';
import 'technician_complaint_stepper.dart';

class TechnicianTicketDetailView extends StatefulWidget {
  final TechnicianTicket ticket;
  final Function(String status) onStatusUpdate;
  final Function(String mode) onSupportModeChange;

  const TechnicianTicketDetailView({
    super.key,
    required this.ticket,
    required this.onStatusUpdate,
    required this.onSupportModeChange,
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
      child: Column(
        children: [
          _buildHeader(),
          const Divider(height: 1),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTicketInfo(),
                  const SizedBox(height: 24),
                  _buildSupportModeSelection(),
                  const SizedBox(height: 24),
                  _buildCustomerContact(),
                  const SizedBox(height: 24),
                  _buildEquipmentDetails(),
                  const SizedBox(height: 32),
                  const Text(
                    'Vertical Stepper Status',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.navy900),
                  ),
                  const SizedBox(height: 16),
                  TechnicianComplaintStepper(steps: widget.ticket.stepperSteps),
                  const SizedBox(height: 32),
                  const Text(
                    'Timeline Log',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.navy900),
                  ),
                  const SizedBox(height: 16),
                  _buildTimeline(widget.ticket.timelineEvents),
                  const SizedBox(height: 32),
                  _buildClosureSection(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '#${widget.ticket.ticketNumber}',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.navy900),
              ),
              Text(
                'Assigned on ${widget.ticket.scheduledTime ?? "N/A"}',
                style: const TextStyle(fontSize: 12, color: AppColors.ink400),
              ),
            ],
          ),
          Row(
            children: [
              if (widget.ticket.status != 'Closed' && widget.ticket.status != 'In Progress')
                ElevatedButton(
                  onPressed: () => widget.onStatusUpdate('In Progress'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.navy900,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text('Start Work'),
                ),
              const SizedBox(width: 12),
              StatusPill.ticketStatus(widget.ticket.status),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTicketInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.ticket.title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.navy900),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.bg,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            widget.ticket.category,
            style: const TextStyle(color: AppColors.ink600, fontSize: 11, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  Widget _buildSupportModeSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'SUPPORT MODE',
          style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.ink400, letterSpacing: 0.5),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            _buildModeOption('Site Visit', Icons.location_on_outlined),
            const SizedBox(width: 12),
            _buildModeOption('Remote Support', Icons.videocam_outlined),
          ],
        ),
      ],
    );
  }

  Widget _buildModeOption(String mode, IconData icon) {
    final isSelected = widget.ticket.supportMode == mode;
    return Expanded(
      child: InkWell(
        onTap: () => widget.onSupportModeChange(mode),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.blue500.withOpacity(0.05) : Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: isSelected ? AppColors.blue500 : AppColors.line),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 18, color: isSelected ? AppColors.blue500 : AppColors.ink400),
              const SizedBox(width: 8),
              Text(
                mode,
                style: TextStyle(
                  color: isSelected ? AppColors.blue500 : AppColors.ink600,
                  fontSize: 13,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCustomerContact() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.bg.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: AppColors.blue100,
            child: Text(widget.ticket.customer.name[0], style: const TextStyle(color: AppColors.blue500, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.ticket.customer.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                Text(widget.ticket.customer.phone, style: const TextStyle(color: AppColors.ink400, fontSize: 12)),
              ],
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.phone, color: AppColors.green500),
            style: IconButton.styleFrom(backgroundColor: Colors.white),
          ),
          const SizedBox(width: 8),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.chat_bubble_outline, color: AppColors.blue500),
            style: IconButton.styleFrom(backgroundColor: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildEquipmentDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'EQUIPMENT DETAILS',
          style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.ink400, letterSpacing: 0.5),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            _buildDetailItem('Model', widget.ticket.equipmentModel),
            const SizedBox(width: 24),
            _buildDetailItem('Serial No', widget.ticket.equipmentSerialNo),
          ],
        ),
      ],
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: AppColors.ink400, fontSize: 11)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.navy900)),
      ],
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
          padding: const EdgeInsets.only(bottom: 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: AppColors.blue500,
                      shape: BoxShape.circle,
                    ),
                  ),
                  if (index != events.length - 1)
                    Container(
                      width: 2,
                      height: 40,
                      color: AppColors.line,
                    ),
                ],
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      event.title,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.navy900),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      event.description,
                      style: const TextStyle(fontSize: 12, color: AppColors.ink600),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      event.timestamp,
                      style: const TextStyle(fontSize: 10, color: AppColors.ink400),
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
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Close Out This Job',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.navy900),
          ),
          const SizedBox(height: 16),
          const Text(
            'Diagnosis Notes & Root Cause Work Performed',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.ink600),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _notesController,
            maxLines: 4,
            style: const TextStyle(fontSize: 13),
            decoration: InputDecoration(
              hintText: 'Describe the diagnosis, root cause found, parts replaced, and verification test result...',
              hintStyle: const TextStyle(fontSize: 12, color: AppColors.ink400),
              fillColor: Colors.white,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: AppColors.line),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: AppColors.blue500),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Work Proof & Verification Photos (2)',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.ink600),
              ),
              TextButton(
                onPressed: () {},
                child: const Row(
                  children: [
                    Icon(Icons.add, size: 14),
                    SizedBox(width: 4),
                    Text('Attach Photo', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                  ],
                ),
                style: TextButton.styleFrom(foregroundColor: const Color(0xFF006D77)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              _buildPhotoThumbnail('Shot #1'),
              const SizedBox(width: 12),
              _buildPhotoThumbnail('Shot #2'),
              const SizedBox(width: 12),
              _buildAddPhotoPlaceholder(),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.save_outlined, size: 18),
                  label: const Text('Save Draft'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.navy900,
                    side: const BorderSide(color: AppColors.line),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => widget.onStatusUpdate('Closed'),
                  icon: const Icon(Icons.check_circle_outline, size: 18),
                  label: const Text('Mark Resolved'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF006D77),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    elevation: 0,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPhotoThumbnail(String label) {
    return Column(
      children: [
        Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            color: AppColors.bg,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.line),
          ),
          alignment: Alignment.center,
          child: const Icon(Icons.image, color: AppColors.ink400, size: 24),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(color: AppColors.ink600, fontSize: 9, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildAddPhotoPlaceholder() {
    return Container(
      width: 70,
      height: 70,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.line, style: BorderStyle.solid),
      ),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.camera_alt_outlined, color: AppColors.ink400, size: 20),
          SizedBox(height: 4),
          Text('+ Add', style: TextStyle(fontSize: 10, color: AppColors.ink400, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
