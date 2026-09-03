import 'package:flutter/material.dart';
import '../../../../core/widgets/app_vertical_stepper.dart';
import '../../data/models/technician_ticket_model.dart';

class TechnicianComplaintStepper extends StatelessWidget {
  final List<TicketStepperStep> steps;

  const TechnicianComplaintStepper({super.key, required this.steps});

  @override
  Widget build(BuildContext context) {
    return AppVerticalStepper(
      steps: steps
          .map((s) => StepperStepData(
                stepOrder: s.stepOrder,
                title: s.title,
                description: s.description,
                status: s.status,
                updatedAt: s.updatedAt,
                updatedBy: s.updatedBy,
              ))
          .toList(),
    );
  }
}
