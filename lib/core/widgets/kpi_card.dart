import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class KPICard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final Color? subtitleColor;
  final bool showStar;
  final IconData? icon;
  final Color? iconColor;
  final Color? iconBgColor;

  const KPICard({
    super.key,
    required this.title,
    required this.value,
    this.subtitle = '',
    this.subtitleColor,
    this.showStar = false,
    this.icon,
    this.iconColor,
    this.iconBgColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (icon != null && iconBgColor != null)
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: iconBgColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: iconColor ?? AppColors.ink400, size: 16),
                )
              else if (icon != null)
                Icon(icon, color: iconColor ?? AppColors.ink400, size: 20),
              if (icon != null && iconBgColor != null) const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.ink600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.navy900,
                ),
              ),
              if (showStar) ...[
                const SizedBox(width: 6),
                const Icon(Icons.star, color: Colors.orange, size: 20),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
