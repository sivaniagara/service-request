import 'package:flutter/material.dart';
import '../widgets/complaints/raise_complaint_dialog.dart';

class RaiseComplaintPage extends StatelessWidget {
  final List<String> categories;
  final String? initialName;
  final String? initialPhone;
  final VoidCallback? onSuccess;

  const RaiseComplaintPage({
    super.key,
    required this.categories,
    this.initialName,
    this.initialPhone,
    this.onSuccess,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Raise a Complaint',
          style: TextStyle(fontWeight: FontWeight.w900, color: Color(0xFF14274E)),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Color(0xFF14274E)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: RaiseComplaintDialog(
              categories: categories,
              initialName: initialName,
              initialPhone: initialPhone,
              onSuccess: onSuccess,
              isFullScreen: true,
            ),
          ),
        ),
      ),
    );
  }
}
