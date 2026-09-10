import 'package:flutter/material.dart';
import '../widgets/complaints/location_picker_dialog.dart';

class LocationPickerPage extends StatelessWidget {
  final String initialLocation;

  const LocationPickerPage({
    super.key,
    required this.initialLocation,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LocationPickerDialog(
          initialLocation: initialLocation,
          isFullScreen: true,
        ),
      ),
    );
  }
}
