import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:io' show File;
import '../../../../../core/theme/app_theme.dart';
import 'location_picker_dialog.dart';

class RaiseComplaintDialog extends StatefulWidget {
  const RaiseComplaintDialog({super.key});

  @override
  State<RaiseComplaintDialog> createState() => _RaiseComplaintDialogState();
}

class _RaiseComplaintDialogState extends State<RaiseComplaintDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController(text: 'S. Priya');
  final _phoneController = TextEditingController(text: '+919842178900');
  final _equipmentController = TextEditingController(text: 'X200 Agri Controller #C-902');
  final _locationController = TextEditingController(text: 'Field Site — Coimbatore');
  final _descriptionController = TextEditingController();
  
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  String _selectedPriority = 'High';
  List<String> _selectedCategories = ['Hardware', 'Repair'];
  List<PlatformFile> _pickedImages = [];

  final List<String> _categories = [
    'Application', 'Hardware', 'Valve', 'Filter', 'Fertilizer', 'Sensors',
    'Repair', 'Installation', 'Maintenance', 'Others'
  ];

  final List<String> _priorities = ['Low', 'Medium', 'High', 'Critical'];

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _equipmentController.dispose();
    _locationController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );
    if (date != null) setState(() => _selectedDate = date);
  }

  Future<void> _pickTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (time != null) setState(() => _selectedTime = time);
  }

  Future<void> _pickImages() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: true,
      withData: kIsWeb,
    );

    if (result != null) {
      setState(() {
        _pickedImages.addAll(result.files);
      });
    }
  }

  void _removeImage(int index) {
    setState(() {
      _pickedImages.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Dialog(
      backgroundColor: Colors.white,
      elevation: 24,
      shadowColor: AppColors.navy900.withOpacity(0.5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Container(
        width: 800,
        padding: const EdgeInsets.all(32),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildHeader(context),
                const SizedBox(height: 32),
                Row(
                  children: [
                    Expanded(child: _buildTextField('Your Name*', _nameController)),
                    const SizedBox(width: 20),
                    Expanded(child: _buildTextField('Phone Number*', _phoneController)),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(child: _buildTextField('Equipment / Product*', _equipmentController)),
                    const SizedBox(width: 20),
                    Expanded(
                      child: _buildTextField(
                        'Site Location*',
                        _locationController,
                        prefixIcon: Icons.location_on_outlined,
                        onTap: () async {
                          final result = await showDialog<String>(
                            context: context,
                            builder: (context) => LocationPickerDialog(initialLocation: _locationController.text),
                          );
                          if (result != null) {
                            setState(() => _locationController.text = result);
                          }
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 28),
                _buildCategorySelection(textTheme),
                const SizedBox(height: 28),
                _buildPriorityLevel(textTheme),
                const SizedBox(height: 28),
                _buildPreferredSlot(textTheme),
                const SizedBox(height: 28),
                _buildTextField(
                  'What went wrong? (Detailed description)',
                  _descriptionController,
                  maxLines: 4,
                  hintText: 'Describe the issue...',
                ),
                const SizedBox(height: 28),
                _buildAttachmentArea(textTheme),
                const SizedBox(height: 32),
                _buildFooter(context),
              ],
            ),
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
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(color: AppColors.blue500, shape: BoxShape.circle),
                ),
                const SizedBox(width: 8),
                Text(
                  'Raise a Complaint',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontSize: 22, 
                    fontWeight: FontWeight.w900,
                    color: AppColors.navy900,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              'Provide incident details. Ticket will be instantly dispatched to regional dealers.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.ink400, fontWeight: FontWeight.w500),
            ),
          ],
        ),
        IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.close, color: AppColors.ink400, size: 20),
          style: IconButton.styleFrom(
            backgroundColor: AppColors.bg,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {int maxLines = 1, String? hintText, IconData? prefixIcon, VoidCallback? onTap}) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: textTheme.titleSmall?.copyWith(fontSize: 13, color: AppColors.ink900, fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          readOnly: onTap != null,
          onTap: onTap,
          style: textTheme.bodyMedium?.copyWith(color: AppColors.ink900, fontWeight: FontWeight.bold),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: textTheme.bodyMedium?.copyWith(color: AppColors.ink400),
            prefixIcon: prefixIcon != null ? Icon(prefixIcon, size: 20, color: AppColors.blue500) : null,
            fillColor: AppColors.bg.withOpacity(0.3),
            filled: true,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.line, width: 1.5),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.blue500, width: 2),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCategorySelection(TextTheme textTheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Issue Category / Symptoms* (Select all that apply)',
                style: textTheme.titleSmall?.copyWith(fontSize: 13, color: AppColors.ink900, fontWeight: FontWeight.w900)),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.blue500.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text('${_selectedCategories.length} selected',
                  style: textTheme.labelLarge?.copyWith(color: AppColors.blue500, fontWeight: FontWeight.w900, fontSize: 10)),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: _categories.map((cat) {
            final isSelected = _selectedCategories.contains(cat);
            return FilterChip(
              label: Text(cat),
              selected: isSelected,
              onSelected: (val) {
                setState(() {
                  if (val) {
                    _selectedCategories.add(cat);
                  } else {
                    _selectedCategories.remove(cat);
                  }
                });
              },
              backgroundColor: AppColors.bg.withOpacity(0.5),
              selectedColor: AppColors.blue100,
              checkmarkColor: AppColors.blue500,
              labelStyle: TextStyle(
                color: isSelected ? AppColors.blue500 : AppColors.ink600,
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w900 : FontWeight.bold,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(
                  color: isSelected ? AppColors.blue500 : AppColors.line,
                  width: isSelected ? 1.5 : 1,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildPriorityLevel(TextTheme textTheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Priority Level', style: textTheme.titleSmall?.copyWith(fontSize: 13, color: AppColors.ink900, fontWeight: FontWeight.w900)),
        const SizedBox(height: 16),
        Row(
          children: _priorities.map((p) {
            final isSelected = _selectedPriority == p;
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: InkWell(
                  onTap: () => setState(() => _selectedPriority = p),
                  borderRadius: BorderRadius.circular(12),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    height: 44,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.orange100.withOpacity(0.3) : AppColors.bg.withOpacity(0.3),
                      border: Border.all(
                        color: isSelected ? AppColors.orange500 : AppColors.line,
                        width: isSelected ? 2 : 1.5,
                      ),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: isSelected ? [BoxShadow(color: AppColors.orange500.withOpacity(0.1), blurRadius: 8, offset: const Offset(0, 3))] : [],
                    ),
                    child: Text(
                      p.toUpperCase(),
                      style: TextStyle(
                        color: isSelected ? AppColors.orange500 : AppColors.ink600,
                        fontWeight: FontWeight.w900,
                        fontSize: 11,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildPreferredSlot(TextTheme textTheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Preferred Visit Date & Time Slot*',
            style: textTheme.titleSmall?.copyWith(fontSize: 13, color: AppColors.ink900, fontWeight: FontWeight.w900)),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildPickerContainer(
                onTap: _pickDate,
                icon: Icons.calendar_today_outlined,
                text: _selectedDate == null ? 'Select Date' : DateFormat('MMM dd, yyyy').format(_selectedDate!),
                isSet: _selectedDate != null,
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: _buildPickerContainer(
                onTap: _pickTime,
                icon: Icons.access_time,
                text: _selectedTime == null ? 'Select Time Slot' : _selectedTime!.format(context),
                isSet: _selectedTime != null,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPickerContainer({required VoidCallback onTap, required IconData icon, required String text, required bool isSet}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.bg.withOpacity(0.3),
          border: Border.all(color: AppColors.line, width: 1.5),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, size: 18, color: isSet ? AppColors.blue500 : AppColors.ink400),
            const SizedBox(width: 12),
            Text(
              text,
              style: TextStyle(
                color: isSet ? AppColors.ink900 : AppColors.ink400,
                fontSize: 13,
                fontWeight: isSet ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAttachmentArea(TextTheme textTheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Attach Photos / Error Code Logs (Optional)',
            style: textTheme.titleSmall?.copyWith(fontSize: 13, color: AppColors.ink900, fontWeight: FontWeight.w900)),
        const SizedBox(height: 16),
        InkWell(
          onTap: _pickImages,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 32),
            decoration: BoxDecoration(
              color: AppColors.bg.withOpacity(0.2),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.line, width: 2, style: BorderStyle.solid),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
                  ),
                  child: const Icon(Icons.cloud_upload_outlined, size: 32, color: AppColors.blue500),
                ),
                const SizedBox(height: 16),
                RichText(
                  text: TextSpan(
                    style: textTheme.bodyMedium?.copyWith(fontSize: 13),
                    children: const [
                      TextSpan(text: 'Click to upload', style: TextStyle(color: AppColors.blue500, fontWeight: FontWeight.w900)),
                      TextSpan(text: ' or drag and drop', style: TextStyle(color: AppColors.ink600, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                const SizedBox(height: 6),
                Text('PNG, JPG, logs up to 10MB', style: textTheme.labelLarge?.copyWith(color: AppColors.ink400, fontWeight: FontWeight.w500, fontSize: 10)),
              ],
            ),
          ),
        ),
        if (_pickedImages.isNotEmpty) ...[
          const SizedBox(height: 20),
          SizedBox(
            height: 110,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _pickedImages.length,
              separatorBuilder: (context, index) => const SizedBox(width: 14),
              itemBuilder: (context, index) {
                final file = _pickedImages[index];
                return Stack(
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.line, width: 1.5),
                        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8)],
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: kIsWeb
                          ? Image.memory(file.bytes!, fit: BoxFit.cover)
                          : Image.file(File(file.path!), fit: BoxFit.cover),
                    ),
                    Positioned(
                      top: 6,
                      right: 6,
                      child: InkWell(
                        onTap: () => _removeImage(index),
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
                          ),
                          child: const Icon(Icons.close, size: 14, color: AppColors.red500),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Row(
      children: [
        Text(
          'Fields marked * are required',
          style: Theme.of(context).textTheme.labelLarge?.copyWith(color: AppColors.ink400, fontWeight: FontWeight.w500, fontSize: 11),
        ),
        const Spacer(),
        OutlinedButton(
          onPressed: () => Navigator.pop(context),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 18),
            side: const BorderSide(color: AppColors.line, width: 1.5),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: const Text('CANCEL', style: TextStyle(color: AppColors.ink600, fontWeight: FontWeight.w900, fontSize: 12, letterSpacing: 0.5)),
        ),
        const SizedBox(width: 16),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Ticket Submitted Successfully!')),
              );
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.navy900,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 18),
            elevation: 8,
            shadowColor: AppColors.navy900.withOpacity(0.3),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: const Text('SUBMIT TICKET \u2192', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 12, letterSpacing: 0.5)),
        ),
      ],
    );
  }
}
