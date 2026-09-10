import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

/// A phone-width stat grid for the admin overview tab.
///
/// The desktop overview lays four [AdminStatCard]s out in a Row. Stacked
/// vertically on a phone (as the mobile dashboard currently does) they
/// read as a plain list rather than a dashboard. This packs the same
/// four metrics into a 2x2 grid of compact tiles instead.
class AdminMobileStatGrid extends StatelessWidget {
  final List<AdminMobileStat> stats;

  const AdminMobileStatGrid({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: stats.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 1.35,
      ),
      itemBuilder: (context, index) => _StatTile(stat: stats[index]),
    );
  }
}

class AdminMobileStat {
  final String title;
  final String value;
  final String trend;
  final Color trendColor;
  final IconData icon;
  final Color iconColor;
  final Color iconBgColor;

  const AdminMobileStat({
    required this.title,
    required this.value,
    required this.trend,
    required this.trendColor,
    required this.icon,
    required this.iconColor,
    required this.iconBgColor,
  });
}

class _StatTile extends StatelessWidget {
  final AdminMobileStat stat;
  const _StatTile({required this.stat});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 12, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(color: stat.iconBgColor, borderRadius: BorderRadius.circular(9)),
            child: Icon(stat.icon, color: stat.iconColor, size: 17),
          ),
          const Spacer(),
          Text(
            stat.value,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: AppColors.navy900),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Text(
            stat.title,
            style: const TextStyle(color: AppColors.ink600, fontSize: 11, fontWeight: FontWeight.w600),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 5),
          Text(
            stat.trend,
            style: TextStyle(color: stat.trendColor, fontSize: 9.5, fontWeight: FontWeight.w700),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}