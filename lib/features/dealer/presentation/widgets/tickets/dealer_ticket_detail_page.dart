import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/theme/app_theme.dart';
import '../../../../../injection_container.dart';
import '../../../data/models/dealer_ticket_model.dart';
import '../../bloc/dealer_dashboard_cubit.dart';
import 'dealer_ticket_detail_view.dart';

/// Dealer ticket detail screen for phones.
///
/// [DealerTicketDetailView] already has its own responsive
/// Delegate/Assign/Complete action row, so this page only adds a hero
/// header for status at a glance — it doesn't duplicate those actions.
class DealerTicketDetailPage extends StatelessWidget {
  final DealerTicketDetail ticket;

  const DealerTicketDetailPage({super.key, required this.ticket});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: sl<DealerDashboardCubit>(),
      child: Scaffold(
        backgroundColor: AppColors.bg,
        body: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverAppBar(
              pinned: true,
              elevation: 0,
              backgroundColor: AppColors.navy900,
              foregroundColor: Colors.white,
              expandedHeight: 160,
              leading: IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(color: Colors.white.withOpacity(0.15), shape: BoxShape.circle),
                  child: const Icon(Icons.arrow_back, size: 18, color: Colors.white),
                ),
                onPressed: () => Navigator.pop(context),
              ),
              title: Text(
                '#${ticket.ticketNumber}',
                style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16, color: Colors.white),
              ),
              centerTitle: false,
              flexibleSpace: FlexibleSpaceBar(background: _HeroHeader(ticket: ticket)),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: DealerTicketDetailView(ticket: ticket),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeroHeader extends StatelessWidget {
  final DealerTicketDetail ticket;
  const _HeroHeader({required this.ticket});

  @override
  Widget build(BuildContext context) {
    final total = ticket.stepperMilestones.length;
    final done = ticket.stepperMilestones.where((m) => m.status == 'done').length;
    final progress = total > 0 ? done / total : 0.0;

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.navy900, AppColors.navy800],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -40,
            right: -30,
            child: Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withOpacity(0.04)),
            ),
          ),
          Positioned(
            bottom: -20,
            left: -30,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(shape: BoxShape.circle, color: const Color(0xFF6366F1).withOpacity(0.18)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 56, 20, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                _StatusPill(status: ticket.status),
                const SizedBox(height: 10),
                Text(
                  ticket.displayTitle ?? 'Service Request',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w900, height: 1.2),
                ),
                if (total > 0) ...[
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: progress,
                            minHeight: 6,
                            backgroundColor: Colors.white.withOpacity(0.15),
                            valueColor: const AlwaysStoppedAnimation(Color(0xFF6366F1)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        '$done/$total steps',
                        style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 11, fontWeight: FontWeight.w800),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  final String status;
  const _StatusPill({required this.status});

  @override
  Widget build(BuildContext context) {
    Color color;
    switch (status) {
      case 'In Progress':
      case 'Assigned to Handler':
        color = AppColors.orange500;
        break;
      case 'Closed':
        color = AppColors.green500;
        break;
      default:
        color = Colors.white70;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(color: color == Colors.white70 ? Colors.white : color, fontSize: 10, fontWeight: FontWeight.w900),
      ),
    );
  }
}