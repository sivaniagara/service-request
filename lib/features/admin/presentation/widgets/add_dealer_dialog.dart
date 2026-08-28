import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class AddDealerDialog extends StatefulWidget {
  const AddDealerDialog({super.key});

  @override
  State<AddDealerDialog> createState() => _AddDealerDialogState();
}

class _AddDealerDialogState extends State<AddDealerDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _ownerController = TextEditingController();
  final _phoneController = TextEditingController(text: '+91');
  final _emailController = TextEditingController();
  
  String _selectedRegion = 'Tamil Nadu (Coimbatore)';
  String _selectedStatus = 'Active';

  @override
  void dispose() {
    _nameController.dispose();
    _ownerController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      child: Container(
        width: 680,
        padding: const EdgeInsets.all(32),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              const SizedBox(height: 32),
              Row(
                children: [
                  Expanded(child: _buildTextField('Dealer / Business Name*', 'e.g. Royal Agri Services', _nameController)),
                  const SizedBox(width: 24),
                  Expanded(child: _buildTextField('Owner Contact Name*', 'e.g. M. Natarajan', _ownerController)),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(child: _buildTextField('Phone Number*', '+91', _phoneController, keyboardType: TextInputType.phone)),
                  const SizedBox(width: 24),
                  Expanded(child: _buildTextField('Email Address', 'dealer@example.com', _emailController, keyboardType: TextInputType.emailAddress)),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(child: _buildDropdownField('Region / State*', ['Tamil Nadu (Coimbatore)', 'Kerala (Kochi)', 'Karnataka (Bengaluru)'], _selectedRegion, (val) => setState(() => _selectedRegion = val!))),
                  const SizedBox(width: 24),
                  Expanded(child: _buildDropdownField('Account Status', ['Active', 'Under Review', 'Inactive'], _selectedStatus, (val) => setState(() => _selectedStatus = val!))),
                ],
              ),
              const SizedBox(height: 48),
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
          children: [
            Row(
              children: [
                Container(
                  width: 10,
                  height: 10,
                  decoration: const BoxDecoration(
                    color: Color(0xFF7C6CF0),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Add a New Dealer',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF14274E),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              'Create a dealer account. They will be able to onboard service persons once active.',
              style: TextStyle(color: Color(0xFF5B6478), fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ],
        ),
        IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.close, size: 20),
          style: IconButton.styleFrom(
            backgroundColor: const Color(0xFFF4F6FB),
            padding: const EdgeInsets.all(12),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField(String label, String hint, TextEditingController controller, {TextInputType? keyboardType}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: Color(0xFF14274E)),
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Color(0xFF95A0B4)),
            fillColor: const Color(0xFFF4F6FB).withValues(alpha: 0.5),
            filled: true,
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFEDF0F6), width: 1.5),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF7C6CF0), width: 2),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField(String label, List<String> items, String value, ValueChanged<String?> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: Color(0xFF14274E)),
        ),
        const SizedBox(height: 10),
        DropdownButtonFormField<String>(
          value: value,
          onChanged: onChanged,
          icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Color(0xFF14274E)),
          decoration: InputDecoration(
            fillColor: const Color(0xFFF4F6FB).withValues(alpha: 0.5),
            filled: true,
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFEDF0F6), width: 1.5),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF7C6CF0), width: 2),
            ),
          ),
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
            );
          }).toList(),
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
            style: TextStyle(color: Color(0xFF5B6478), fontWeight: FontWeight.w900, fontSize: 15),
          ),
        ),
        const SizedBox(width: 24),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              // Call API: POST /api/v1/admin/createDealer
              Navigator.pop(context);
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF14274E),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 0,
          ),
          child: const Text(
            'Create Dealer Account',
            style: TextStyle(fontWeight: FontWeight.w900, fontSize: 15),
          ),
        ),
      ],
    );
  }
}
