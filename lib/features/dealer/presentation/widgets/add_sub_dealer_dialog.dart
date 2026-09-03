import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_theme.dart';
import '../../data/models/sub_dealer_model.dart';
import '../bloc/dealer_dashboard_cubit.dart';

class AddSubDealerDialog extends StatefulWidget {
  const AddSubDealerDialog({super.key});

  @override
  State<AddSubDealerDialog> createState() => _AddSubDealerDialogState();
}

class _AddSubDealerDialogState extends State<AddSubDealerDialog> {
  final _formKey = GlobalKey<FormState>();
  final _branchNameController = TextEditingController();
  final _locationController = TextEditingController();
  final _phoneController = TextEditingController(text: '+91 ');
  final _managerController = TextEditingController();

  @override
  void dispose() {
    _branchNameController.dispose();
    _locationController.dispose();
    _phoneController.dispose();
    _managerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        width: 600,
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      'Branch / Sub-Dealer Name*',
                      'e.g. Coimbatore South Hub',
                      _branchNameController,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildTextField(
                      'Location / Area*',
                      'e.g. Pollachi, TN',
                      _locationController,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      'Branch Manager Name*',
                      'e.g. R. Ananth',
                      _managerController,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildTextField(
                      'Contact Number*',
                      '+91 00000 00000',
                      _phoneController,
                      keyboardType: TextInputType.phone,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              _buildFooter(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Add New Service Branch',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w900,
                color: AppColors.navy900,
              ),
            ),
            SizedBox(height: 4),
            Text(
              'Create a sub-dealer account to delegate service requests and field teams.',
              style: TextStyle(color: AppColors.ink600, fontSize: 13),
            ),
          ],
        ),
        IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.close),
          style: IconButton.styleFrom(backgroundColor: AppColors.bg),
        ),
      ],
    );
  }

  Widget _buildTextField(
    String label,
    String hint,
    TextEditingController controller, {
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.navy900),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          validator: (value) => value == null || value.isEmpty ? 'Field required' : null,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: AppColors.ink400, fontSize: 14),
            fillColor: AppColors.bg,
            filled: true,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.line),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.navy900, width: 1.5),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
        ),
      ],
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
            style: TextStyle(color: AppColors.ink600, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(width: 16),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              final newSubDealer = SubDealer(
                id: 'SD-${DateTime.now().millisecond}',
                branchName: _branchNameController.text,
                location: _locationController.text,
                technicianCount: 0,
                rating: 0.0,
                isActive: true,
                createdAt: DateTime.now(),
                contactNumber: _phoneController.text,
                managerName: _managerController.text,
              );
              context.read<DealerDashboardCubit>().addSubDealer(newSubDealer);
              Navigator.pop(context);
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.navy900,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          child: const Text(
            'Create Branch Account',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
