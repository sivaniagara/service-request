import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../data/models/admin_dashboard_model.dart';

class TopDealersCard extends StatelessWidget {
  final List<RegionalDistribution> regions;

  const TopDealersCard({super.key, required this.regions});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Top Dealers by Volume',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.navy900,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Requests dispatched & completed',
                      style: TextStyle(fontSize: 11.5, color: AppColors.ink400),
                    ),
                  ],
                ),
              ),
              TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 4)),
                child: const Text(
                  'View All ›',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: regions.length,
            separatorBuilder: (context, index) => const SizedBox(height: 24),
            itemBuilder: (context, index) {
              final region = regions[index];
              return _buildDealerItem(
                context,
                region.regionName,
                region.regionCode, // Using region code as location placeholder
                region.activeTickets,
                region.capacityUtilizationPct / 100,
                _getColorForIndex(index),
              );
            },
          ),
        ],
      ),
    );
  }

  Color _getColorForIndex(int index) {
    const colors = [
      AppColors.navy900,
      Colors.purple,
      Colors.orange,
      Colors.blue,
    ];
    return colors[index % colors.length];
  }

  Widget _buildDealerItem(
      BuildContext context,
      String name,
      String location,
      int count,
      double progress,
      Color color,
      ) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.navy900),
              ),
              Text(
                location,
                style: const TextStyle(fontSize: 12, color: AppColors.ink400),
              ),
            ],
          ),
        ),
        Expanded(
          flex: 3,
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.grey.shade100,
            color: color,
            minHeight: 8,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 16),
        SizedBox(
          width: 24,
          child: Text(
            count.toString(),
            textAlign: TextAlign.end,
            style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.navy900),
          ),
        ),
      ],
    );
  }
}