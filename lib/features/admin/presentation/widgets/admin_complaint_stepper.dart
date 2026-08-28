import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../data/models/admin_ticket_detail_model.dart';

class AdminComplaintStepper extends StatelessWidget {
  final List<StepperMilestone> milestones;

  const AdminComplaintStepper({super.key, required this.milestones});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.line, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Complaint Progress',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w900,
              color: AppColors.navy900,
            ),
          ),
          const SizedBox(height: 32),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: milestones.length,
            itemBuilder: (context, index) {
              final milestone = milestones[index];
              final isLast = index == milestones.length - 1;
              final isDone = milestone.status == 'done';
              final isCurrent = milestone.status == 'current';

              return IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: isDone
                                ? Colors.green
                                : isCurrent
                                    ? AppColors.blue500
                                    : Colors.white,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isDone || isCurrent
                                  ? Colors.transparent
                                  : AppColors.line,
                              width: 2,
                            ),
                          ),
                          child: isDone
                              ? const Icon(Icons.check, size: 14, color: Colors.white)
                              : Center(
                                  child: Text(
                                    '${milestone.stepOrder}',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: isCurrent ? Colors.white : AppColors.ink400,
                                    ),
                                  ),
                                ),
                        ),
                        if (!isLast)
                          Expanded(
                            child: Container(
                              width: 2,
                              color: isDone ? Colors.green : AppColors.line,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 32.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              milestone.title,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: isDone || isCurrent ? AppColors.navy900 : AppColors.ink400,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              milestone.description,
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppColors.ink600,
                                height: 1.4,
                              ),
                            ),
                            if (milestone.updatedAt != null) ...[
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  const Icon(Icons.access_time, size: 12, color: AppColors.ink400),
                                  const SizedBox(width: 4),
                                  Text(
                                    milestone.updatedAt!,
                                    style: const TextStyle(fontSize: 10, color: AppColors.ink400),
                                  ),
                                  const SizedBox(width: 12),
                                  const Icon(Icons.person_outline, size: 12, color: AppColors.ink400),
                                  const SizedBox(width: 4),
                                  Text(
                                    milestone.updatedBy ?? '',
                                    style: const TextStyle(fontSize: 10, color: AppColors.ink400),
                                  ),
                                ],
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
