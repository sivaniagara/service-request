import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'dart:io' show File;
import '../../../../../core/theme/app_theme.dart';
import '../../../../../core/utils/responsive_utils.dart';
import '../../../../../injection_container.dart';
import '../../../data/models/complaint_models.dart';
import '../../bloc/complaint_cubit.dart';
import 'location_picker_dialog.dart';

class RaiseComplaintDialog extends StatefulWidget {
  final List<String> categories;
  final String? initialName;
  final String? initialPhone;
  final VoidCallback? onSuccess;
  final bool isFullScreen;
  const RaiseComplaintDialog({
    super.key,
    required this.categories,
    this.initialName,
    this.initialPhone,
    this.onSuccess,
    this.isFullScreen = false,
  });

  @override
  State<RaiseComplaintDialog> createState() => _RaiseComplaintDialogState();
}

class _RaiseComplaintDialogState extends State<RaiseComplaintDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;
  final _equipmentController = TextEditingController(text: '');
  final _locationController = TextEditingController(text: '');
  final _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialName ?? '');
    _phoneController = TextEditingController(text: widget.initialPhone ?? '');
  }
  
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  String _selectedPriority = 'High';
  List<String> _selectedCategories = [];
  List<PlatformFile> _pickedImages = [];

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

    final content = Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (!widget.isFullScreen) _buildHeader(context),
          if (!widget.isFullScreen) const SizedBox(height: 32),
          if (widget.isFullScreen)
            _buildTextField('Your Name (Optional)', _nameController)
          else
            Row(
              children: [
                Expanded(child: _buildTextField('Your Name (Optional)', _nameController)),
                const SizedBox(width: 20),
                Expanded(
                  child: _buildTextField(
                    'Phone Number (Optional)',
                    _phoneController,
                    keyboardType: TextInputType.phone,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(10),
                    ],
                  ),
                ),
              ],
            ),
          if (widget.isFullScreen) ...[
            const SizedBox(height: 20),
            _buildTextField(
              'Phone Number (Optional)',
              _phoneController,
              keyboardType: TextInputType.phone,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(10),
              ],
            ),
          ],
          const SizedBox(height: 20),
          _buildTextField(
            'Site Location*',
            _locationController,
            prefixIcon: Icons.location_on_outlined,
            validator: (value) => value == null || value.isEmpty ? 'Location is required' : null,
            onTap: () async {
              final result = await ResponsiveUtils.showLocationPicker(context, _locationController.text);
              if (result != null) {
                setState(() => _locationController.text = result);
              }
            },
          ),
          const SizedBox(height: 28),
          _buildCategorySelection(textTheme),
          const SizedBox(height: 28),
          _buildPriorityLevel(textTheme),
          const SizedBox(height: 28),
          _buildPreferredSlot(textTheme),
          const SizedBox(height: 28),
          _buildTextField(
            'What went wrong? (Detailed description) (Optional)',
            _descriptionController,
            maxLines: 4,
            hintText: 'Describe the issue...',
          ),
          const SizedBox(height: 28),
          _buildAttachmentArea(textTheme),
          const SizedBox(height: 32),
          Builder(builder: (context) => _buildFooter(context)),
        ],
      ),
    );

    if (widget.isFullScreen) {
      return BlocProvider(
        create: (context) => sl<ComplaintCubit>(),
        child: BlocListener<ComplaintCubit, ComplaintState>(
          listener: _onStateChange,
          child: content,
        ),
      );
    }

    return BlocProvider(
      create: (context) => sl<ComplaintCubit>(),
      child: BlocListener<ComplaintCubit, ComplaintState>(
        listener: _onStateChange,
        child: Dialog(
          backgroundColor: Colors.white,
          elevation: 24,
          shadowColor: AppColors.navy900.withOpacity(0.5),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          child: Container(
            width: 800,
            padding: const EdgeInsets.all(32),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: content,
            ),
          ),
        ),
      ),
    );
  }

  void _onStateChange(BuildContext context, ComplaintState state) {
    if (state is ComplaintLoading) {
      AwesomeDialog(
        width: MediaQuery.of(context).size.width > 600 ? 400 : null,
        context: context,
        dialogType: DialogType.noHeader,
        animType: AnimType.scale,
        body: const Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 20),
              Text('Submitting Ticket...', style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
        ),
        dismissOnTouchOutside: false,
        dismissOnBackKeyPress: false,
      ).show();
    } else if (state is ComplaintSuccess) {
      Navigator.pop(context); // Close loading dialog
      AwesomeDialog(
        width: MediaQuery.of(context).size.width > 600 ? 400 : null,
        context: context,
        dialogType: DialogType.success,
        animType: AnimType.bottomSlide,
        title: 'Success',
        desc: 'Ticket #${state.response.ticketNumber} raised successfully!',
        btnOkOnPress: () {
          widget.onSuccess?.call();
          Navigator.pop(context); // Close main dialog/page
        },
      ).show();
    } else if (state is ComplaintFailure) {
      Navigator.pop(context); // Close loading dialog
      AwesomeDialog(
        width: MediaQuery.of(context).size.width > 600 ? 400 : null,
        context: context,
        dialogType: DialogType.error,
        animType: AnimType.bottomSlide,
        title: 'Submission Failed',
        desc: state.message,
        btnOkOnPress: () {},
      ).show();
    }
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
      {int maxLines = 1,
      String? hintText,
      IconData? prefixIcon,
      VoidCallback? onTap,
      TextInputType? keyboardType,
      List<TextInputFormatter>? inputFormatters,
      String? Function(String?)? validator}) {
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
          validator: validator,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
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
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.red500, width: 1.5),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.red500, width: 2),
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
          children: widget.categories.map((cat) {
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
              final request = RaiseComplaintRequest(
                name: _nameController.text,
                phone: _phoneController.text,
                location: _locationController.text,
                issueCategory: _selectedCategories,
                priority: _selectedPriority,
                description: _descriptionController.text,
                preferredDate: _selectedDate != null ? DateFormat('yyyy-MM-dd').format(_selectedDate!) : null,
                preferredTime: _selectedTime != null ? _selectedTime!.format(context) : null,
                attachments: _pickedImages.map((e) => e.name).toList(), // Simplified for now
              );
              context.read<ComplaintCubit>().raiseTicket(request);
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
