import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:io' show Platform;
import '../../features/customer/presentation/pages/location_picker_page.dart';
import '../../features/customer/presentation/widgets/complaints/location_picker_dialog.dart';
import '../../features/customer/presentation/pages/raise_complaint_page.dart';
import '../../features/customer/presentation/widgets/complaints/raise_complaint_dialog.dart';

class ResponsiveUtils {
  static bool isMobile(BuildContext context) {
    if (kIsWeb) return false;
    return Platform.isAndroid || Platform.isIOS;
  }

  static bool isDesktop(BuildContext context) {
    if (kIsWeb) return true;
    return Platform.isWindows || Platform.isMacOS || Platform.isLinux;
  }

  static bool isWeb() => kIsWeb;

  static Future<String?> showLocationPicker(BuildContext context, String initialLocation) async {
    if (isMobile(context)) {
      return await Navigator.push<String>(
        context,
        MaterialPageRoute(
          builder: (context) => LocationPickerPage(initialLocation: initialLocation),
        ),
      );
    } else {
      return await showDialog<String>(
        context: context,
        builder: (context) => LocationPickerDialog(initialLocation: initialLocation),
      );
    }
  }

  static void showRaiseComplaint(BuildContext context, {
    required List<String> categories,
    String? initialName,
    String? initialPhone,
    VoidCallback? onSuccess,
  }) {
    if (isMobile(context)) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => RaiseComplaintPage(
            categories: categories,
            initialName: initialName,
            initialPhone: initialPhone,
            onSuccess: onSuccess,
          ),
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (context) => RaiseComplaintDialog(
          categories: categories,
          initialName: initialName,
          initialPhone: initialPhone,
          onSuccess: onSuccess,
        ),
      );
    }
  }
}
