import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../data/models/admin_dealer_model.dart';

/// A dealer card for the admin mobile "Dealers" tab.
///
/// The desktop table packs DEALER NAME / REGION / CAPACITY / REQUESTS /
/// SATISFACTION / STATUS / ADDRESS into seven flex-columns — there's no
/// way to make that legible under ~400px. This surfaces the same data
/// as a scannable card with a real capacity bar instead of a cramped pill.
class AdminMobileDealerCard extends StatelessWidget {
  final DealerData dealer;

  const AdminMobileDealerCard({super.key, required this.dealer});

  @override
  Widget build(BuildContext context) {
    final capacityColor = _capacityColor(dealer.capacity.capacityStatus);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.line),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: _avatarColor(dealer.name),
                child: Text(
                  dealer.name.split(' ').map((e) => e.isNotEmpty ? e[0] : '').take(2).join(),
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 12),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      dealer.name,
                      style: const TextStyle(fontWeight: FontWeight.w900, color: AppColors.navy900, fontSize: 14),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${dealer.phone} · ${dealer.region}',
                      style: const TextStyle(color: AppColors.ink400, fontSize: 11),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              _StatusPill(isActive: dealer.isActive),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _MiniStat(
                  icon: Icons.build_circle_outlined,
                  value: dealer.performance.totalTicketsResolved.toString(),
                  label: 'Resolved',
                  color: const Color(0xFF7C6CF0),
                ),
              ),
              Expanded(
                child: _MiniStat(
                  icon: Icons.star_rounded,
                  value: dealer.performance.rating.toStringAsFixed(1),
                  label: 'Rating',
                  color: Colors.orange.shade700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'CAPACITY',
                style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.w900, color: AppColors.ink400, letterSpacing: 0.6),
              ),
              Text(
                '${dealer.capacity.activeAssignedTickets}/${dealer.capacity.maxConcurrentTickets} · ${dealer.capacity.utilizationPercentage.toInt()}%',
                style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w800, color: capacityColor),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: (dealer.capacity.utilizationPercentage / 100).clamp(0.0, 1.0),
              minHeight: 6,
              backgroundColor: AppColors.bg,
              color: capacityColor,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.location_on_outlined, size: 13, color: AppColors.ink400),
              const SizedBox(width: 5),
              Expanded(
                child: Text(
                  dealer.officeAddress,
                  style: const TextStyle(color: AppColors.ink400, fontSize: 11),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _capacityColor(String status) {
    switch (status.toLowerCase()) {
      case 'available':
        return Colors.green.shade600;
      case 'near capacity':
        return Colors.orange.shade700;
      case 'full':
        return Colors.red.shade600;
      default:
        return AppColors.ink600;
    }
  }

  Color _avatarColor(String name) {
    if (name.contains('Agri')) return AppColors.navy900;
    if (name.contains('Sunrise')) return Colors.blue.shade700;
    if (name.contains('AgroCare')) return Colors.orange.shade700;
    return const Color(0xFF7C6CF0);
  }
}

class _MiniStat extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;

  const _MiniStat({required this.icon, required this.value, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle),
          child: Icon(icon, size: 13, color: color),
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w900, color: AppColors.navy900)),
            Text(label, style: const TextStyle(fontSize: 9.5, color: AppColors.ink400, fontWeight: FontWeight.w600)),
          ],
        ),
      ],
    );
  }
}

class _StatusPill extends StatelessWidget {
  final bool isActive;
  const _StatusPill({required this.isActive});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isActive ? Colors.green.shade50 : Colors.orange.shade50,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        isActive ? 'Active' : 'Review',
        style: TextStyle(
          color: isActive ? Colors.green.shade700 : Colors.orange.shade700,
          fontSize: 9.5,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}