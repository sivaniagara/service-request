import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import '../../../../../core/network/token_manager.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../core/router/route_names.dart';
import '../../../../../core/utils/responsive_utils.dart';
import '../../../../../injection_container.dart';
import '../../bloc/dashboard_cubit.dart';
import '../../bloc/dashboard_state.dart';
import '../complaints/ticket_detail_view.dart';
import '../complaints/ticket_list_sidebar.dart';
import '../reports/reports_view.dart';
import 'mobile_summary_card.dart';
import 'mobile_active_tickets_section.dart';
import '../../pages/ticket_detail_page.dart';

class CustomerMobileDashboard extends StatelessWidget {
  const CustomerMobileDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<DashboardCubit, DashboardState>(
      listenWhen: (previous, current) => previous.error != current.error && current.error != null,
      listener: (context, state) {
        AwesomeDialog(
          context: context,
          dialogType: DialogType.error,
          animType: AnimType.bottomSlide,
          title: 'Error',
          desc: state.error,
          btnOkOnPress: () {},
        ).show();
      },
      child: BlocBuilder<DashboardCubit, DashboardState>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: AppColors.bg,
            appBar: _buildAppBar(context, state),
            body: _buildBody(context, state),
            bottomNavigationBar: _buildBottomNav(context, state),
            floatingActionButton: state.activeTab != DashboardTab.reports
                ? FloatingActionButton.extended(
              onPressed: () => _handleRaiseComplaint(context, state),
              backgroundColor: AppColors.navy900,
              elevation: 4,
              icon: const Icon(Icons.add, color: Colors.white, size: 20),
              label: const Text(
                'Raise Complaint',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 13),
              ),
            )
                : null,
          );
        },
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, DashboardState state) {
    final profileName = state.dashboardData?.profile.name ?? 'Customer';
    final initials = profileName.trim().isNotEmpty
        ? profileName.trim().split(' ').map((e) => e.isNotEmpty ? e[0] : '').take(2).join().toUpperCase()
        : 'C';

    return AppBar(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      elevation: 0,
      scrolledUnderElevation: 1,
      titleSpacing: 16,
      title: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            alignment: Alignment.center,
            decoration: const BoxDecoration(color: AppColors.navy900, shape: BoxShape.circle),
            child: Text(
              initials,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 13),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Hi, $profileName',
                  style: const TextStyle(
                    color: AppColors.navy900,
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const Text(
                  'Green Sprout · Customer Portal',
                  style: TextStyle(
                    color: AppColors.ink400,
                    fontSize: 11.5,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.account_circle_outlined, color: AppColors.navy900),
          tooltip: 'Profile',
          onPressed: () => context.push(RouteNames.profileSetup),
        ),
        IconButton(
          icon: const Icon(Icons.logout, color: AppColors.red500),
          tooltip: 'Log out',
          onPressed: () async {
            await sl<TokenManager>().deleteToken();
            if (context.mounted) context.go(RouteNames.login);
          },
        ),
        const SizedBox(width: 4),
      ],
    );
  }

  Widget _buildBody(BuildContext context, DashboardState state) {
    if (state.isLoading &&
        state.dashboardData == null &&
        state.tickets == null &&
        state.report == null) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.error != null) {
      return Center(child: Text(state.error!, style: const TextStyle(color: AppColors.red500)));
    }

    switch (state.activeTab) {
      case DashboardTab.overview:
        return _buildOverview(context, state);
      case DashboardTab.complaints:
        return _buildComplaints(context, state);
      case DashboardTab.reports:
        return _buildReports(context, state);
    }
  }

  Widget _buildOverview(BuildContext context, DashboardState state) {
    if (state.dashboardData == null) return const SizedBox.shrink();
    final data = state.dashboardData!;

    return RefreshIndicator(
      onRefresh: () => context.read<DashboardCubit>().loadDashboard(),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            MobileSummaryCard(metrics: data.metrics),
            const SizedBox(height: 24),
            if (data.activeTickets.isNotEmpty)
              MobileActiveTicketsSection(tickets: data.activeTickets)
            else
              _buildNoTickets(context, state),
            const SizedBox(height: 80), // Space for FAB
          ],
        ),
      ),
    );
  }

  Widget _buildComplaints(BuildContext context, DashboardState state) {
    if (state.isLoading && state.tickets == null) return const Center(child: CircularProgressIndicator());
    if (state.tickets == null) return const SizedBox.shrink();

    return RefreshIndicator(
      onRefresh: () => context.read<DashboardCubit>().loadTickets(),
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: state.tickets!.length,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final ticket = state.tickets![index];
          // We can reuse the _TicketCard from TicketListSidebar but it's private there.
          // For now, I'll use a simplified version or I could refactor it.
          // Let's create a mobile-friendly ticket card.
          return _MobileTicketCard(
            ticket: ticket,
            onTap: () async {
              final cubit = context.read<DashboardCubit>();
              await cubit.selectTicket(ticket.ticketId);
              if (context.mounted && cubit.state.selectedTicket != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => TicketDetailPage(
                      ticket: cubit.state.selectedTicket!,
                    ),
                  ),
                );
              }
            },
          );
        },
      ),
    );
  }

  Widget _buildReports(BuildContext context, DashboardState state) {
    if (state.isLoading && state.report == null) return const Center(child: CircularProgressIndicator());
    if (state.report == null) return const SizedBox.shrink();
    return RefreshIndicator(
      onRefresh: () => context.read<DashboardCubit>().loadReport(),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: ReportsView(report: state.report!),
      ),
    );
  }

  Widget _buildBottomNav(BuildContext context, DashboardState state) {
    return BottomNavigationBar(
      currentIndex: state.activeTab.index,
      selectedItemColor: AppColors.navy900,
      unselectedItemColor: AppColors.ink400,
      onTap: (index) => context.read<DashboardCubit>().changeTab(DashboardTab.values[index]),
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.dashboard_outlined),
          activeIcon: Icon(Icons.dashboard),
          label: 'Overview',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.confirmation_number_outlined),
          activeIcon: Icon(Icons.confirmation_number),
          label: 'Complaints',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.analytics_outlined),
          activeIcon: Icon(Icons.analytics),
          label: 'Reports',
        ),
      ],
    );
  }

  Widget _buildNoTickets(BuildContext context, DashboardState state) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.line.withOpacity(0.5)),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 16, offset: const Offset(0, 8)),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(color: AppColors.blue500.withOpacity(0.06), shape: BoxShape.circle),
            child: const Icon(Icons.check_circle_outline_rounded, size: 44, color: AppColors.blue500),
          ),
          const SizedBox(height: 18),
          const Text(
            'All systems operational',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w900, color: AppColors.navy900),
          ),
          const SizedBox(height: 6),
          const Text(
            'You have no active service requests right now.',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.ink400, fontSize: 13, height: 1.4),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => _handleRaiseComplaint(context, state),
              icon: const Icon(Icons.add, size: 18, color: AppColors.navy900),
              label: const Text('Raise a New Complaint', style: TextStyle(fontWeight: FontWeight.w800, color: AppColors.navy900)),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                side: const BorderSide(color: AppColors.line, width: 1.5),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handleRaiseComplaint(BuildContext context, DashboardState state) {
    final cubit = context.read<DashboardCubit>();
    ResponsiveUtils.showRaiseComplaint(
      context,
      categories: state.dashboardData?.issueCategories ?? [],
      initialName: state.dashboardData?.profile.name,
      initialPhone: state.dashboardData?.profile.phone,
      onSuccess: () => cubit.loadDashboard(),
    );
  }
}

class _MobileTicketCard extends StatelessWidget {
  final dynamic ticket;
  final VoidCallback onTap;

  const _MobileTicketCard({required this.ticket, required this.onTap});

  Color _priorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'critical':
        return const Color(0xFFE5484D);
      case 'high':
        return const Color(0xFFF5A524);
      case 'medium':
        return const Color(0xFF3B82F6);
      case 'low':
        return const Color(0xFF64748B);
      default:
        return AppColors.ink400;
    }
  }

  Color _statusColor(String status) {
    switch (status.toLowerCase().trim()) {
      case 'in progress':
        return const Color(0xFF2563EB);
      case 'assigned':
      case 'assigned to technician':
      case 'assigned to dealer':
      case 'assigned to handler':
        return const Color(0xFF7C3AED);
      case 'pending assignment':
      case 'pending':
        return const Color(0xFFF59E0B);
      case 'submitted':
        return const Color(0xFF0891B2);
      case 'resolved':
      case 'completed':
      case 'closed':
        return const Color(0xFF16A34A);
      case 'customer raised complaint':
      case 'open':
        return const Color(0xFFDC2626);
      case 'cancelled':
        return const Color(0xFF64748B);
      default:
        return AppColors.ink400;
    }
  }

  IconData _statusIcon(String status) {
    switch (status.toLowerCase().trim()) {
      case 'in progress':
        return Icons.autorenew_rounded;
      case 'assigned':
      case 'assigned to technician':
      case 'assigned to dealer':
      case 'assigned to handler':
        return Icons.person_add_alt_1_rounded;
      case 'pending assignment':
      case 'pending':
        return Icons.schedule_rounded;
      case 'submitted':
        return Icons.upload_rounded;
      case 'resolved':
      case 'completed':
      case 'closed':
        return Icons.check_circle_outline_rounded;
      case 'customer raised complaint':
      case 'open':
        return Icons.error_outline_rounded;
      case 'cancelled':
        return Icons.close_rounded;
      default:
        return Icons.circle_outlined;
    }
  }

  Widget _statusPill(String status) {
    final color = _statusColor(status);
    final icon = _statusIcon(status);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.11),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.30), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 11, color: color),
          const SizedBox(width: 4),
          Text(
            status.toUpperCase(),
            style: TextStyle(
              fontSize: 8.5,
              fontWeight: FontWeight.w900,
              letterSpacing: 0.25,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _priorityBadge(String priority) {
    final color = _priorityColor(priority);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.10),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        priority.toUpperCase(),
        style: TextStyle(
          fontSize: 8.5,
          fontWeight: FontWeight.w900,
          letterSpacing: 0.3,
          color: color,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final accent = _priorityColor(ticket.priority);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Ink(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.line, width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.02),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  width: 4,
                  decoration: BoxDecoration(
                    color: accent,
                    borderRadius: const BorderRadius.horizontal(left: Radius.circular(12)),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                '#${ticket.ticketNumber}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w900,
                                  color: AppColors.navy900,
                                  fontSize: 12.5,
                                ),
                              ),
                            ),
                            _statusPill(ticket.status),
                          ],
                        ),
                        const SizedBox(height: 7),
                        Row(
                          children: [
                            _priorityBadge(ticket.priority),
                            const SizedBox(width: 7),
                            Expanded(
                              child: Text(
                                ticket.issueCategory.join(', '),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.navy900,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          ticket.description ?? '',
                          style: const TextStyle(color: AppColors.ink600, fontSize: 11.5),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            const Icon(Icons.location_on_outlined, size: 12, color: AppColors.ink400),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                ticket.siteLocation ?? '',
                                style: const TextStyle(
                                  color: AppColors.ink400,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const Icon(Icons.chevron_right, size: 16, color: AppColors.ink400),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
