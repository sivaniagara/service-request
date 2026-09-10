import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../data/models/dealer_technician_model.dart';
import 'dealer_mobile_technician_card.dart';

class DealerMobileTeamView extends StatelessWidget {
  final DealerServiceTeamModel? data;

  const DealerMobileTeamView({super.key, this.data});

  @override
  Widget build(BuildContext context) {
    if (data == null) return const SizedBox.shrink();
    final summary = data!.summary;

    return Column(
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
                  icon: Icons.person_outline,
                  value: summary.totalServicePersons.toString(),
                  label: 'Team',
                  color: AppColors.purple500,
                ),
              ),
              _divider(),
              Expanded(
                child: _SummaryCell(
                  icon: Icons.build_circle_outlined,
                  value: summary.requestsHandled.toString(),
                  label: 'Handled',
                  color: AppColors.blue500,
                ),
              ),
              _divider(),
              Expanded(
                child: _SummaryCell(
                  icon: Icons.folder_open_outlined,
                  value: summary.currentlyAssigned.toString(),
                  label: 'Assigned',
                  color: AppColors.orange500,
                ),
              ),
              _divider(),
              Expanded(
                child: _SummaryCell(
                  icon: Icons.sentiment_satisfied_alt,
                  value: '${summary.avgTechRating}★',
                  label: 'Avg',
                  color: AppColors.green500,
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
              'Your Service Team',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w900, color: AppColors.navy900),
            ),
            Text(
              '${data!.technicians.length} total',
              style: const TextStyle(fontSize: 11.5, color: AppColors.ink400, fontWeight: FontWeight.w600),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: data!.technicians.length,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) => DealerMobileTechnicianCard(tech: data!.technicians[index]),
        ),
        const SizedBox(height: 80),
      ],
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
        Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: AppColors.navy900)),
        const SizedBox(height: 2),
        Text(label, style: const TextStyle(fontSize: 9, color: AppColors.ink400, fontWeight: FontWeight.w700)),
      ],
    );
  }
}