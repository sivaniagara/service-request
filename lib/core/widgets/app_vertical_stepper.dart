import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class StepperStepData {
  final int stepOrder;
  final String title;
  final String description;
  final String status;
  final String? updatedAt;
  final String? updatedBy;

  const StepperStepData({
    required this.stepOrder,
    required this.title,
    required this.description,
    required this.status,
    this.updatedAt,
    this.updatedBy,
  });

  bool get isDone => status == 'done' || status == 'completed';
  bool get isCurrent => status == 'current' || status == 'in_progress';
}

class AppVerticalStepper extends StatelessWidget {
  final List<StepperStepData> steps;

  const AppVerticalStepper({super.key, required this.steps});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: steps.length,
          itemBuilder: (context, index) {
            final step = steps[index];
            final isLast = index == steps.length - 1;
            final isDone = step.isDone;
            final isCurrent = step.isCurrent;

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
                                  '${step.stepOrder}',
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
                      padding: const EdgeInsets.only(bottom: 24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            step.title,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: isDone || isCurrent ? AppColors.navy900 : AppColors.ink400,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            step.description,
                            style: const TextStyle(
                              fontSize: 11,
                              color: AppColors.ink600,
                              height: 1.3,
                            ),
                          ),
                          if (step.updatedAt != null) ...[
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                const Icon(Icons.access_time, size: 10, color: AppColors.ink400),
                                const SizedBox(width: 4),
                                Text(
                                  step.updatedAt!,
                                  style: const TextStyle(fontSize: 9, color: AppColors.ink400),
                                ),
                                if (step.updatedBy != null) ...[
                                  const SizedBox(width: 10),
                                  const Icon(Icons.person_outline, size: 10, color: AppColors.ink400),
                                  const SizedBox(width: 4),
                                  Text(
                                    step.updatedBy!,
                                    style: const TextStyle(fontSize: 9, color: AppColors.ink400),
                                  ),
                                ],
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
    );
  }
}
