import 'package:flutter/material.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../data/models/dashboard_models.dart';
import 'mobile_active_ticket_card.dart';

class MobileActiveTicketsSection extends StatelessWidget {
  final List<ActiveTicket> tickets;

  const MobileActiveTicketsSection({super.key, required this.tickets});

  @override
  Widget build(BuildContext context) {
    if (tickets.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: 10,
                  height: 10,
                  decoration: const BoxDecoration(color: AppColors.blue500, shape: BoxShape.circle),
                ),
                const SizedBox(width: 10),
                const Text(
                  'Live Service Requests',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w900, color: AppColors.navy900),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: AppColors.blue500.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '${tickets.length} ACTIVE',
                style: const TextStyle(color: AppColors.blue500, fontSize: 9.5, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        const Text(
          'Tap a ticket to see live progress',
          style: TextStyle(color: AppColors.ink400, fontSize: 12),
        ),
        const SizedBox(height: 16),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: tickets.length,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) => MobileActiveTicketCard(
            ticket: tickets[index],
            initiallyExpanded: index == 0 && tickets.length == 1,
          ),
        ),
      ],
    );
  }
}