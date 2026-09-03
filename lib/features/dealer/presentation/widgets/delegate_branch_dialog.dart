import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../data/models/dealer_ticket_model.dart';

class DelegateBranchDialog extends StatefulWidget {
  final DealerTicketDetail ticket;

  const DelegateBranchDialog({super.key, required this.ticket});

  @override
  State<DelegateBranchDialog> createState() => _DelegateBranchDialogState();
}

class _DelegateBranchDialogState extends State<DelegateBranchDialog> {
  final _notesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _notesController.text =
        'Delegated for on-site inspection and localized maintenance in Field Site — Coimbatore.';
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        width: 540,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildCustomerLocationInfo(),
                  const SizedBox(height: 20),
                  const Text(
                    'SELECT REGIONAL SUB-DEALER BRANCH',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                      color: AppColors.ink600,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 10),
                  _buildBranchSelector(),
                  const SizedBox(height: 20),
                  const Text(
                    'DELEGATION INSTRUCTIONS / SERVICE NOTES',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                      color: AppColors.ink600,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 10),
                  _buildNotesField(),
                  const SizedBox(height: 6),
                  const Text(
                    'Instruction displayed on Sub-Dealer dashboard and audit log.',
                    style: TextStyle(fontSize: 10, color: AppColors.ink400),
                  ),
                  const SizedBox(height: 20),
                  _buildSyncInfo(),
                  const SizedBox(height: 24),
                  _buildFooter(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      color: AppColors.navy900,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.account_tree_outlined, color: Colors.white, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Delegate to Sub-Dealer Branch',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'Ticket #${widget.ticket.ticketNumber} • ${widget.ticket.title}',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.white.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.close, color: Colors.white, size: 18),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomerLocationInfo() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.bg.withOpacity(0.3),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.line),
      ),
      child: Row(
        children: [
          const Icon(Icons.location_on_outlined, color: AppColors.purple500, size: 20),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Customer Location:',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.navy900),
              ),
              Text(
                'Field Site — Coimbatore',
                style: TextStyle(fontSize: 12, color: AppColors.ink600),
              ),
              RichText(
                text: TextSpan(
                  style: TextStyle(fontSize: 11, color: AppColors.ink600),
                  children: const [
                    TextSpan(text: 'Customer: '),
                    TextSpan(
                      text: 'S. Priya (+91 98421 78900)',
                      style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.navy900),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBranchSelector() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.purple500, width: 1.5),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: AppColors.green500,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Center(
                  child: Text(
                    'A',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text(
                          'arun',
                          style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.navy900, fontSize: 13),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                          decoration: BoxDecoration(
                            color: AppColors.green100,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            'SUB-DEALER',
                            style: TextStyle(color: AppColors.green500, fontSize: 8, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: const [
                        Icon(Icons.location_on, size: 10, color: AppColors.ink400),
                        SizedBox(width: 2),
                        Text(
                          'TAMIL NADU',
                          style: TextStyle(fontSize: 9, color: AppColors.ink400, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Icon(Icons.check_circle, color: AppColors.purple500, size: 18),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildBranchMetric(Icons.people_outline, '0 Field Techs'),
              const SizedBox(width: 12),
              _buildBranchMetric(Icons.inventory_2_outlined, '15 Spares Stock', color: AppColors.orange500),
              const Spacer(),
              const Text(
                '0 Active Load',
                style: TextStyle(fontSize: 10, color: AppColors.ink400, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.bg,
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Text(
                '641006',
                style: TextStyle(fontSize: 9, color: AppColors.ink400, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBranchMetric(IconData icon, String label, {Color color = AppColors.purple500}) {
    return Row(
      children: [
        Icon(icon, size: 12, color: color),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(fontSize: 10, color: AppColors.navy900, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  Widget _buildNotesField() {
    return TextField(
      controller: _notesController,
      maxLines: 3,
      style: const TextStyle(fontSize: 12, color: AppColors.navy900),
      decoration: InputDecoration(
        fillColor: Colors.white,
        filled: true,
        contentPadding: const EdgeInsets.all(12),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.line),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.purple500, width: 1.5),
        ),
      ),
    );
  }

  Widget _buildSyncInfo() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.blue100.withOpacity(0.15),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.verified_user_outlined, color: AppColors.purple500, size: 16),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Automated Multi-Tier Synchronization',
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.navy900),
                ),
                SizedBox(height: 2),
                Text(
                  'Delegating will update the vertical stepper with a "Delegated to Sub-Dealer" milestone.',
                  style: TextStyle(fontSize: 10, color: AppColors.purple500, height: 1.3),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text(
            'Cancel',
            style: TextStyle(color: AppColors.ink600, fontWeight: FontWeight.bold, fontSize: 13),
          ),
        ),
        const SizedBox(width: 12),
        ElevatedButton(
          onPressed: () => Navigator.pop(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.purple500,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            elevation: 0,
          ),
          child: const Text(
            'Confirm Delegation',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          ),
        ),
      ],
    );
  }
}
