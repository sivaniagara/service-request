import 'package:flutter/material.dart';
import '../../../../core/widgets/app_vertical_stepper.dart';
import '../../data/models/dealer_ticket_model.dart';

class DealerComplaintStepper extends StatelessWidget {
  final List<DealerMilestone> milestones;

  const DealerComplaintStepper({super.key, required this.milestones});

  @override
  Widget build(BuildContext context) {
    return AppVerticalStepper(
      steps: milestones
          .map((m) => StepperStepData(
                stepOrder: m.stepOrder,
                title: m.title,
                description: m.description,
                status: m.status,
                updatedAt: m.updatedAt,
                updatedBy: m.updatedBy,
              ))
          .toList(),
    );
  }
}
