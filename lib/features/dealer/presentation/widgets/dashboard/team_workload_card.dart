import 'package:flutter/material.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../data/models/dealer_technician_model.dart';
import 'dart:math';

class TeamWorkloadCard extends StatelessWidget {
  final List<DealerTechnician> technicians;

  const TeamWorkloadCard({super.key, required this.technicians});

  @override
  Widget build(BuildContext context) {
    // Sort technicians by resolved count descending
    final sortedTechs = List<DealerTechnician>.from(technicians)
      ..sort((a, b) => b.totalResolved.compareTo(a.totalResolved));
    
    // Take top 4 for the dashboard card
    final displayTechs = sortedTechs.take(4).toList();
    
    // Find max resolved for progress calculation
    final maxResolved = displayTechs.isEmpty 
        ? 1 
        : displayTechs.map((t) => t.totalResolved).reduce(max);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Team Workload Distribution',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.navy900,
                    ),
                  ),
                  const SizedBox(height: 2),
                  const Text(
                    'Requests handled per service person',
                    style: TextStyle(
                      fontSize: 11,
                      color: AppColors.ink400,
                    ),
                  ),
                ],
              ),
              TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: Size.zero, tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                child: const Text(
                  'Manage Team ›',
                  style: TextStyle(
                    color: AppColors.blue500,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (displayTechs.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Text('No technician data available', style: TextStyle(color: AppColors.ink400, fontSize: 12)),
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: displayTechs.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final tech = displayTechs[index];
                return _WorkloadItem(
                  name: tech.name,
                  phone: tech.phone,
                  count: tech.totalResolved,
                  progress: maxResolved > 0 ? tech.totalResolved / maxResolved : 0.0,
                );
              },
            ),
        ],
      ),
    );
  }
}

class _WorkloadItem extends StatelessWidget {
  final String name;
  final String phone;
  final int count;
  final double progress;

  const _WorkloadItem({
    required this.name,
    required this.phone,
    required this.count,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 100,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: AppColors.navy900,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                phone,
                style: const TextStyle(
                  fontSize: 11,
                  color: AppColors.ink400,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Stack(
            children: [
              Container(
                height: 8,
                decoration: BoxDecoration(
                  color: AppColors.line,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              FractionallySizedBox(
                widthFactor: progress,
                child: Container(
                  height: 8,
                  decoration: BoxDecoration(
                    color: AppColors.purple500,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        SizedBox(
          width: 30,
          child: Text(
            count.toString(),
            textAlign: TextAlign.right,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: AppColors.navy900,
            ),
          ),
        ),
      ],
    );
  }
}
