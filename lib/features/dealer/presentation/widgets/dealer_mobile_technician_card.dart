import 'package:flutter/material.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../data/models/dealer_technician_model.dart';

/// A technician card for the dealer mobile "Team" tab, replacing the
/// 6-column desktop table (SERVICE PERSON / SKILLS / HANDLED /
/// ASSIGNED / RATING / STATUS) which has no room to breathe on a phone.
class DealerMobileTechnicianCard extends StatelessWidget {
  final DealerTechnician tech;

  const DealerMobileTechnicianCard({super.key, required this.tech});

  @override
  Widget build(BuildContext context) {
    final isAvailable = tech.availabilityStatus.toLowerCase() == 'available';
    final isOnJob = tech.availabilityStatus.toLowerCase() == 'on job';

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
                backgroundColor: AppColors.navy900,
                child: Text(
                  _getInitials(tech.name),
                  style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tech.name,
                      style: const TextStyle(fontWeight: FontWeight.w900, color: AppColors.navy900, fontSize: 14),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        const Icon(Icons.phone_android_outlined, size: 11, color: AppColors.ink400),
                        const SizedBox(width: 4),
                        Text(
                          tech.phone,
                          style: const TextStyle(color: AppColors.ink400, fontSize: 11),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isAvailable ? AppColors.green100 : (isOnJob ? AppColors.blue100 : AppColors.bg),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  tech.availabilityStatus,
                  style: TextStyle(
                    color: isAvailable ? AppColors.green500 : (isOnJob ? AppColors.blue500 : AppColors.ink600),
                    fontSize: 9.5,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
          if (tech.travelDistance != null) ...[
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(Icons.social_distance_outlined, size: 13, color: AppColors.blue500),
                const SizedBox(width: 5),
                Text(
                  '${tech.travelDistance} · ${tech.estimatedEta ?? "N/A"}',
                  style: const TextStyle(color: AppColors.blue500, fontSize: 11, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _MiniStat(
                  icon: Icons.build_circle_outlined,
                  value: tech.totalResolved.toString(),
                  label: 'Resolved',
                  color: const Color(0xFF6366F1),
                ),
              ),
              Expanded(
                child: _MiniStat(
                  icon: Icons.folder_open_outlined,
                  value: tech.currentlyAssignedCount.toString(),
                  label: 'Active',
                  color: AppColors.orange500,
                ),
              ),
              Expanded(
                child: _MiniStat(
                  icon: Icons.star_rounded,
                  value: tech.rating.toString(),
                  label: 'Rating',
                  color: AppColors.amber500,
                ),
              ),
            ],
          ),
          if (tech.skills.isNotEmpty) ...[
            const SizedBox(height: 12),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: tech.skills.map((s) => _SkillChip(label: s)).toList(),
            ),
          ],
        ],
      ),
    );
  }

  String _getInitials(String name) {
    final parts = name.split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return parts[0][0].toUpperCase();
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
    return Column(
      children: [
        Icon(icon, size: 14, color: color),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w900, color: AppColors.navy900)),
        Text(label, style: const TextStyle(fontSize: 9, color: AppColors.ink400, fontWeight: FontWeight.w600)),
      ],
    );
  }
}

class _SkillChip extends StatelessWidget {
  final String label;
  const _SkillChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.blue100.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.blue100),
      ),
      child: Text(
        label,
        style: const TextStyle(fontSize: 10, color: AppColors.blue500, fontWeight: FontWeight.w600),
      ),
    );
  }
}