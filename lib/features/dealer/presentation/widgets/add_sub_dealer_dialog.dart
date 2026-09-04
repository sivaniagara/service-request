import 'package:flutter/material.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
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
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _locationController = TextEditingController();
  final _managerController = TextEditingController();
  
  String _countryCode = '+91';
  String _selectedRegion = 'Tamil Nadu (Coimbatore)';
  String _selectedStatus = 'Active';

  @override
  void dispose() {
    _branchNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _locationController.dispose();
    _managerController.dispose();
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
                  Expanded(
                    child: _buildTextField(
                      'Sub-Dealer Name*',
                      'e.g. Coimbatore South Hub',
                      _branchNameController,
                      validator: (v) => v!.isEmpty ? 'Required' : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      'Contact Number*',
                      '9876543210',
                      _phoneController,
                      keyboardType: TextInputType.phone,
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
                    ),
                  ),
                  const SizedBox(width: 24),
                  Expanded(
                    child: _buildTextField(
                      'Email Address',
                      'branch@example.com',
                      _emailController,
                      keyboardType: TextInputType.emailAddress,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              _buildTextField(
                'Office Address / Location*',
                'e.g. 123, Main Road, Pollachi, TN',
                _locationController,
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: _buildDropdownField(
                      'Region / State*',
                      ['Tamil Nadu (Coimbatore)', 'Kerala (Kochi)', 'Karnataka (Bengaluru)'],
                      _selectedRegion,
                      (val) => setState(() => _selectedRegion = val!),
                    ),
                  ),
                  const SizedBox(width: 24),
                  Expanded(
                    child: _buildDropdownField(
                      'Account Status',
                      ['Active', 'Under Review', 'Inactive'],
                      _selectedStatus,
                      (val) => setState(() => _selectedStatus = val!),
                    ),
                  ),
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
                  'Add New Service Branch',
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
              'Create a sub-dealer account to delegate service requests and field teams.',
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

  Widget _buildTextField(
    String label,
    String hint,
    TextEditingController controller, {
    TextInputType? keyboardType,
    Widget? prefixIcon,
    String? Function(String?)? validator,
  }) {
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
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              final fullPhone = '$_countryCode${_phoneController.text}';
              
              final requestData = {
                "name": _branchNameController.text,
                "phone": fullPhone,
                "email": _emailController.text,
                "region": _selectedRegion,
                "dealerCode": 'DC-${DateTime.now().millisecond}',
                "territoryZones": [_selectedRegion],
                "officeAddress": _locationController.text,
                "maxConcurrentTickets": 5,
                "rating": 0,
              };

              // Show Loading
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) => const Center(child: CircularProgressIndicator()),
              );

              try {
                await context.read<DealerDashboardCubit>().addSubDealer(requestData);
                
                // Close loading
                if (mounted) Navigator.pop(context);
                
                // Show Success
                if (mounted) {
                  AwesomeDialog(
                    context: context,
                    dialogType: DialogType.success,
                    animType: AnimType.bottomSlide,
                    title: 'Success',
                    desc: 'Branch account created successfully.',
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
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 0,
          ),
          child: const Text(
            'Create Branch Account',
            style: TextStyle(fontWeight: FontWeight.w900, fontSize: 15),
          ),
        ),
      ],
    );
  }
}
