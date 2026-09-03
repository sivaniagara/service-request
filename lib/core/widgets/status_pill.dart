import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class StatusPill extends StatelessWidget {
  final String label;
  final Color color;
  final Color backgroundColor;
  final double fontSize;
  final EdgeInsetsGeometry padding;
  final double borderRadius;

  const StatusPill({
    super.key,
    required this.label,
    required this.color,
    required this.backgroundColor,
    this.fontSize = 9,
    this.padding = const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    this.borderRadius = 4,
  });

  factory StatusPill.priority(String priority) {
    Color color;
    Color bgColor;
    switch (priority.toLowerCase()) {
      case 'critical':
        color = AppColors.red500;
        bgColor = AppColors.red100;
        break;
      case 'high':
        color = AppColors.orange500;
        bgColor = AppColors.orange100;
        break;
      case 'medium':
        color = AppColors.blue500;
        bgColor = AppColors.blue100;
        break;
      default:
        color = AppColors.ink400;
        bgColor = AppColors.bg;
    }
    return StatusPill(
      label: priority.toUpperCase(),
      color: color,
      backgroundColor: bgColor,
      fontSize: 10,
    );
  }

  factory StatusPill.ticketStatus(String status) {
    Color color;
    Color bgColor;
    switch (status) {
      case 'In Progress':
        color = AppColors.blue500;
        bgColor = AppColors.blue100;
        break;
      case 'Closed':
      case 'Resolved':
      case 'COMPLETED':
        color = AppColors.green500;
        bgColor = AppColors.green100;
        break;
      default:
        color = AppColors.ink600;
        bgColor = AppColors.bg;
    }

    return StatusPill(
      label: status.toUpperCase(),
      color: color,
      backgroundColor: bgColor,
      fontSize: 10,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      borderRadius: 20,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
