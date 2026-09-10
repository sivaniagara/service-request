import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/responsive_utils.dart';
import '../../../customer/presentation/widgets/complaints/location_picker_dialog.dart';
import '../bloc/admin_dashboard_cubit.dart';

class AddDealerDialog extends StatefulWidget {
  /// When true, renders as plain scrollable content sized to whatever
  /// parent it's given (a full-screen page on phones) instead of a
  /// fixed 680px-wide [Dialog] — the desktop dialog shape simply
  /// doesn't fit a phone viewport.
  final bool isFullScreen;

  const AddDealerDialog({super.key, this.isFullScreen = false});

  @override
  State<AddDealerDialog> createState() => _AddDealerDialogState();
}

class _AddDealerDialogState extends State<AddDealerDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();

  String _countryCode = '+91';
  String _selectedRegion = 'Tamil Nadu (Coimbatore)';
  String _selectedStatus = 'Active';

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final phoneField = _buildTextField(
      'Phone Number*',
      '1234567890',
      _phoneController,
      keyboardType: TextInputType.phone,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(10),
      ],
      validator: (v) => v!.isEmpty ? 'Required' : null,
      prefixIcon: CountryCodePicker(
        onChanged: (code) {
          setState(() {
            _countryCode = code.dialCode!;
          });
        },
        initialSelection: 'IN',
        favorite: const ['+91', 'IN'],
        showCountryOnly: false,
        showOnlyCountryWhenClosed: false,
        alignLeft: false,
        padding: EdgeInsets.zero,
        textStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Color(0xFF14274E),
        ),
      ),
    );
    final emailField = _buildTextField('Email Address', 'dealer@example.com', _emailController, keyboardType: TextInputType.emailAddress);
    final regionField = _buildDropdownField('Region / State*', ['Tamil Nadu (Coimbatore)', 'Kerala (Kochi)', 'Karnataka (Bengaluru)'], _selectedRegion, (val) => setState(() => _selectedRegion = val!));
    final statusField = _buildDropdownField('Account Status', ['Active', 'Under Review', 'Inactive'], _selectedStatus, (val) => setState(() => _selectedStatus = val!));

    final formBody = Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!widget.isFullScreen) ...[
            _buildHeader(context),
            const SizedBox(height: 32),
          ],
          _buildTextField('Dealer Name*', 'e.g. Royal Agri Services', _nameController, validator: (v) => v!.isEmpty ? 'Required' : null),
          SizedBox(height: widget.isFullScreen ? 20 : 24),
          if (widget.isFullScreen) ...[
            phoneField,
            const SizedBox(height: 20),
            emailField,
          ] else
            Row(
              children: [
                Expanded(child: phoneField),
                const SizedBox(width: 24),
                Expanded(child: emailField),
              ],
            ),
          SizedBox(height: widget.isFullScreen ? 20 : 24),
          _buildTextField(
            'Office Address*',
            'Select from map',
            _addressController,
            readOnly: true,
            onTap: () async {
              final result = await ResponsiveUtils.showLocationPicker(context, _addressController.text);
              if (result != null) {
                setState(() => _addressController.text = result);
              }
            },
            validator: (v) => v!.isEmpty ? 'Required' : null,
          ),
          SizedBox(height: widget.isFullScreen ? 20 : 24),
          if (widget.isFullScreen) ...[
            regionField,
            const SizedBox(height: 20),
            statusField,
          ] else
            Row(
              children: [
                Expanded(child: regionField),
                const SizedBox(width: 24),
                Expanded(child: statusField),
              ],
            ),
          SizedBox(height: widget.isFullScreen ? 28 : 48),
          _buildFooter(context),
        ],
      ),
    );

    if (widget.isFullScreen) {
      return formBody;
    }

    return Dialog(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      child: Container(
        width: 680,
        padding: const EdgeInsets.all(32),
        child: formBody,
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

  Widget _buildTextField(String label, String hint, TextEditingController controller, {TextInputType? keyboardType, List<TextInputFormatter>? inputFormatters, Widget? prefixIcon, bool readOnly = false, VoidCallback? onTap, String? Function(String?)? validator}) {
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
          inputFormatters: inputFormatters,
          readOnly: readOnly,
          onTap: onTap,
          validator: validator,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Color(0xFF95A0B4)),
            prefixIcon: prefixIcon,
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
    final cancelButton = TextButton(
      onPressed: () => Navigator.pop(context),
      style: widget.isFullScreen
          ? TextButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16))
          : null,
      child: const Text(
        'Cancel',
        style: TextStyle(color: Color(0xFF5B6478), fontWeight: FontWeight.w900, fontSize: 15),
      ),
    );

    final submitButton = ElevatedButton(
      onPressed: () async {
        if (_formKey.currentState!.validate()) {
          final fullPhone = '$_countryCode${_phoneController.text}';

          // Generate Dealer Code programmatically
          final timestamp = DateTime.now().millisecondsSinceEpoch.toString().substring(7);
          final generatedCode = 'DLR-$timestamp';

          final requestBody = {
            "name": _nameController.text,
            "phone": fullPhone,
            "email": _emailController.text,
            "region": _selectedRegion,
            "dealerCode": generatedCode,
            "territoryZones": [_selectedRegion], // Using region as a default zone
            "officeAddress": _addressController.text,
            "maxConcurrentTickets": 10,
            "rating": 5.0,
          };

          // Show Loading
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => const Center(child: CircularProgressIndicator()),
          );

          try {
            await context.read<AdminDashboardCubit>().addDealer(requestBody);

            // Close loading
            if (mounted) Navigator.pop(context);

            // Show Success
            if (mounted) {
              AwesomeDialog(
                context: context,
                dialogType: DialogType.success,
                animType: AnimType.bottomSlide,
                title: 'Success',
                desc: 'Dealer account created successfully.',
                btnOkOnPress: () {
                  Navigator.pop(context);
                },
                width: 400,
              ).show();
            }
          } catch (e) {
            // Close loading
            if (mounted) Navigator.pop(context);

            // Show Error
            if (mounted) {
              AwesomeDialog(
                context: context,
                dialogType: DialogType.error,
                animType: AnimType.bottomSlide,
                title: 'Error',
                desc: e.toString(),
                btnOkOnPress: () {},
                width: 400,
              ).show();
            }
          }
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF14274E),
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: widget.isFullScreen ? 0 : 32, vertical: widget.isFullScreen ? 18 : 20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 0,
      ),
      child: const Text(
        'Create Dealer Account',
        style: TextStyle(fontWeight: FontWeight.w900, fontSize: 15),
      ),
    );

    if (widget.isFullScreen) {
      return Column(
        children: [
          SizedBox(width: double.infinity, child: submitButton),
          const SizedBox(height: 8),
          cancelButton,
        ],
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        cancelButton,
        const SizedBox(width: 24),
        submitButton,
      ],
    );
  }
}