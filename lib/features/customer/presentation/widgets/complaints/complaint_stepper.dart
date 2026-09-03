import 'package:flutter/material.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../data/models/dashboard_models.dart';

class ComplaintStepper extends StatelessWidget {
  final List<Milestone> milestones;

  const ComplaintStepper({super.key, required this.milestones});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.line, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
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
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: AppColors.green100.withOpacity(0.5),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.insights, size: 16, color: AppColors.green500),
                      ),
                      const SizedBox(width: 10),
                      Text('Complaint Progress Stepper', style: textTheme.titleMedium?.copyWith(fontSize: 14)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Real-time status updates of your request',
                    style: textTheme.labelLarge?.copyWith(color: AppColors.ink400, fontWeight: FontWeight.normal, fontSize: 10),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: AppColors.green500.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.green500.withOpacity(0.2)),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(color: AppColors.green500, shape: BoxShape.circle),
                    ),
                    const SizedBox(width: 6),
                    const Text(
                      'LIVE STATUS',
                      style: TextStyle(color: AppColors.green500, fontSize: 8, fontWeight: FontWeight.w900, letterSpacing: 0.5),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 28),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: milestones.length,
            itemBuilder: (context, index) {
              final milestone = milestones[index];
              final isLast = index == milestones.length - 1;
              return _StepItem(
                milestone: milestone,
                isLast: isLast,
              );
            },
          ),
        ],
      ),
    );
  }
}

class _StepItem extends StatelessWidget {
  final Milestone milestone;
  final bool isLast;

  const _StepItem({required this.milestone, required this.isLast});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final bool isDone = milestone.status == 'done';
    final bool isCurrent = milestone.status == 'current';
    final bool isPending = milestone.status == 'pending';

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: 26,
                height: 26,
                decoration: BoxDecoration(
                  color: isDone
                      ? AppColors.green500
                      : isCurrent
                          ? AppColors.blue500
                          : Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isDone
                        ? AppColors.green500
                        : isCurrent
                            ? AppColors.blue500
                            : AppColors.line,
                    width: 2,
                  ),
                  boxShadow: isCurrent
                      ? [BoxShadow(color: AppColors.blue500.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 3))]
                      : [],
                ),
                child: Center(
                  child: isDone
                      ? const Icon(Icons.check, size: 14, color: Colors.white)
                      : isCurrent
                          ? const Icon(Icons.sync, size: 14, color: Colors.white)
                          : Text(
                              milestone.stepOrder.toString(),
                              style: const TextStyle(color: AppColors.ink400, fontSize: 10, fontWeight: FontWeight.bold),
                            ),
                ),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    decoration: BoxDecoration(
                      color: isDone ? AppColors.green500 : AppColors.line,
                      borderRadius: BorderRadius.circular(1),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      milestone.title,
                      style: textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w900,
                        fontSize: 12.5,
                        color: isPending ? AppColors.ink400 : AppColors.ink900,
                      ),
                    ),
                    const SizedBox(width: 8),
                    if (isDone)
                      _StatusTag(label: 'COMPLETED', color: AppColors.green500)
                    else if (isCurrent)
                      _StatusTag(label: 'ACTIVE', color: AppColors.blue500),
                    const Spacer(),
                    if (milestone.updatedAt != null)
                      Text(
                        milestone.updatedAt!,
                        style: textTheme.labelLarge?.copyWith(color: AppColors.ink400, fontSize: 9.5),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  milestone.description ?? '',
                  style: textTheme.bodyMedium?.copyWith(
                    color: isPending ? AppColors.ink400 : AppColors.ink600,
                    fontSize: 11.5,
                    height: 1.4,
                  ),
                ),
                if (milestone.updatedBy != null) ...[
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(
                        milestone.updatedBy!.contains('Customer') ? Icons.person_pin_outlined : Icons.verified_user_outlined,
                        size: 14,
                        color: AppColors.blue500,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Verified by: ${milestone.updatedBy}',
                        style: textTheme.labelLarge?.copyWith(
                          color: AppColors.ink400,
                          fontSize: 9.5,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
                if (isCurrent) ...[
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.blue500.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.blue500.withOpacity(0.1)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.sticky_note_2_outlined, size: 12, color: AppColors.blue500),
                            const SizedBox(width: 6),
                            Text(
                              'SERVICE LOG NOTE:',
                              style: textTheme.labelLarge?.copyWith(fontSize: 8.5, color: AppColors.blue500, fontWeight: FontWeight.w900),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Technician on-site. Testing flow pressure and aligning bearings. Expected completion in 45 mins.',
                          style: textTheme.bodyMedium?.copyWith(fontSize: 11, color: AppColors.ink900, height: 1.4),
                        ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusTag extends StatelessWidget {
  final String label;
  final Color color;

  const _StatusTag({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 8,
          fontWeight: FontWeight.w900,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
