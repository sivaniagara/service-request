import 'package:flutter/material.dart';
import '../complaints/raise_complaint_dialog.dart';

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
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: AppBar(
        title: const Text(
          'Raise a Complaint',
          style: TextStyle(fontWeight: FontWeight.w900, color: Color(0xFF14274E), fontSize: 17),
        ),
        centerTitle: false,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Color(0xFF14274E)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          child: Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFE7E9EE)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
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