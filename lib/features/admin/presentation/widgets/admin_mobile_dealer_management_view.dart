import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../data/models/admin_dealer_model.dart';
import 'admin_mobile_dealer_card.dart';

class AdminMobileDealerManagementView extends StatelessWidget {
  final AdminDealerModel dealers;

  const AdminMobileDealerManagementView({super.key, required this.dealers});

  @override
  Widget build(BuildContext context) {
    final totalDealers = dealers.summary?.totalDealers ?? dealers.data.length;
    final totalTechnicians = dealers.summary?.totalTechnicians ?? 0;
    final avgRating = dealers.summary?.avgDealerRating ??
        (dealers.data.isEmpty
            ? 0.0
            : dealers.data.map((d) => d.performance.rating).reduce((a, b) => a + b) / dealers.data.length);

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 6),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.line),
            ),
            child: Row(
              children: [
                Expanded(
                  child: _SummaryCell(
                    icon: Icons.storefront_outlined,
                    value: totalDealers.toString(),
                    label: 'Dealers',
                    color: const Color(0xFF7C6CF0),
                  ),
                ),
                _divider(),
                Expanded(
                  child: _SummaryCell(
                    icon: Icons.people_outline,
                    value: totalTechnicians > 0 ? totalTechnicians.toString() : 'N/A',
                    label: 'Technicians',
                    color: Colors.orange.shade700,
                  ),
                ),
                _divider(),
                Expanded(
                  child: _SummaryCell(
                    icon: Icons.sentiment_satisfied_alt,
                    value: avgRating.toStringAsFixed(1),
                    label: 'Avg. Rating',
                    color: Colors.teal.shade700,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'All Registered Dealers',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w900, color: AppColors.navy900),
              ),
              Text(
                '${dealers.data.length} total',
                style: const TextStyle(fontSize: 11.5, color: AppColors.ink400, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: dealers.data.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) => AdminMobileDealerCard(dealer: dealers.data[index]),
          ),
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _divider() => Container(width: 1, height: 36, color: AppColors.line);
}

class _SummaryCell extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;

  const _SummaryCell({required this.icon, required this.value, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(height: 6),
        Text(value, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w900, color: AppColors.navy900)),
        const SizedBox(height: 2),
        Text(label, style: const TextStyle(fontSize: 9.5, color: AppColors.ink400, fontWeight: FontWeight.w700)),
      ],
    );
  }
}