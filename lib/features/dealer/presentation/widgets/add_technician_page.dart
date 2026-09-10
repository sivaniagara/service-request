import 'package:flutter/material.dart';
import 'add_technician_dialog.dart';

/// Full-screen "Add Technician" flow for phones — the desktop dialog
/// is fixed at 640px, which doesn't fit a phone viewport.
class AddTechnicianPage extends StatelessWidget {
  const AddTechnicianPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 1,
        centerTitle: false,
        title: const Text(
          'Add Field Technician',
          style: TextStyle(fontWeight: FontWeight.w900, color: Color(0xFF14274E), fontSize: 17),
        ),
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
                BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 20, offset: const Offset(0, 8)),
              ],
            ),
            child: const AddTechnicianDialog(isFullScreen: true),
          ),
        ),
      ),
    );
  }
}