import 'package:flutter/material.dart';
import '../../../../../core/theme/app_theme.dart';

class TeamWorkloadCard extends StatelessWidget {
  const TeamWorkloadCard({super.key});

  @override
  Widget build(BuildContext context) {
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
          _WorkloadItem(name: 'Ramesh K.', phone: '+91 98765 43210', count: 58, progress: 0.95),
          const SizedBox(height: 12),
          _WorkloadItem(name: 'Divya S.', phone: '+91 98765 22110', count: 44, progress: 0.72),
          const SizedBox(height: 12),
          _WorkloadItem(name: 'Suresh M.', phone: '+91 98765 99001', count: 31, progress: 0.51),
          const SizedBox(height: 12),
          _WorkloadItem(name: 'Anitha R.', phone: '+91 98765 55678', count: 19, progress: 0.31),
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
