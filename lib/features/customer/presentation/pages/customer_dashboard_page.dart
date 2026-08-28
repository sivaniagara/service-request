import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../injection_container.dart';
import '../bloc/dashboard_cubit.dart';
import '../bloc/dashboard_state.dart';
import '../widgets/dashboard/active_ticket_card.dart';
import '../widgets/dashboard/category_chart_card.dart';
import '../widgets/dashboard/recent_history_card.dart';
import '../widgets/dashboard/summary_card.dart';
import '../widgets/complaints/ticket_list_sidebar.dart';
import '../widgets/complaints/ticket_detail_view.dart';
import '../widgets/reports/reports_view.dart';
import '../widgets/complaints/raise_complaint_dialog.dart';

class CustomerDashboardPage extends StatelessWidget {
  const CustomerDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<DashboardCubit>()..loadDashboard(),
      child: Scaffold(
        backgroundColor: AppColors.bg,
        body: BlocBuilder<DashboardCubit, DashboardState>(
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(context, state),
                  const SizedBox(height: 24),
                  _buildTabs(context, state),
                  const SizedBox(height: 24),
                  if (state.isLoading && 
                      state.dashboardData == null && 
                      state.tickets == null && 
                      state.report == null)
                    const Expanded(child: Center(child: CircularProgressIndicator()))
                  else if (state.error != null)
                    Expanded(child: Center(child: Text(state.error!, style: const TextStyle(color: AppColors.red500))))
                  else if (state.activeTab == DashboardTab.overview)
                    _buildOverview(state)
                  else if (state.activeTab == DashboardTab.complaints)
                    _buildComplaints(context, state)
                  else if (state.activeTab == DashboardTab.reports)
                    _buildReports(state),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildOverview(DashboardState state) {
    if (state.dashboardData == null) return const SizedBox.shrink();
    final data = state.dashboardData!;
    return Expanded(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            SummaryCard(metrics: data.metrics),
            const SizedBox(height: 24),
            if (data.activeTickets.isNotEmpty) ...[
              ActiveTicketCard(ticket: data.activeTickets.first),
              const SizedBox(height: 24),
            ],
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 1,
                  child: CategoryChartCard(categories: data.requestByCategory),
                ),
                const SizedBox(width: 20),
                Expanded(
                  flex: 1,
                  child: RecentHistoryCard(tickets: data.recentTickets),
                ),
              ],
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildComplaints(BuildContext context, DashboardState state) {
    if (state.isLoading && state.tickets == null) return const Expanded(child: Center(child: CircularProgressIndicator()));
    if (state.tickets == null) return const SizedBox.shrink();

    return Expanded(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TicketListSidebar(
            tickets: state.tickets!,
            selectedTicketId: state.selectedTicket?.ticketId ?? '',
            onTicketSelected: (id) => context.read<DashboardCubit>().selectTicket(id),
          ),
          const SizedBox(width: 24),
          Expanded(
            child: state.selectedTicket != null
                ? TicketDetailView(ticket: state.selectedTicket!)
                : Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.confirmation_number_outlined, size: 64, color: AppColors.ink400.withOpacity(0.3)),
                        const SizedBox(height: 16),
                        Text(
                          'Select a ticket to view detailed progress',
                          style: TextStyle(color: AppColors.ink400, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildReports(DashboardState state) {
    if (state.isLoading && state.report == null) return const Expanded(child: Center(child: CircularProgressIndicator()));
    if (state.report == null) return const SizedBox.shrink();
    return Expanded(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: ReportsView(report: state.report!),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, DashboardState state) {
    final textTheme = Theme.of(context).textTheme;
    final profileName = state.dashboardData?.profile.name ?? 'S. Siva';
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.blue500.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: AppColors.blue500.withOpacity(0.2)),
                  ),
                  child: const Text(
                    'Customer Portal',
                    style: TextStyle(
                      color: AppColors.blue500,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'Customer Dashboard',
                  style: textTheme.headlineMedium?.copyWith(fontSize: 22, color: AppColors.navy900, fontWeight: FontWeight.w900),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              'Welcome back, $profileName · Account #CUST-1',
              style: textTheme.bodyMedium?.copyWith(color: AppColors.ink400, fontWeight: FontWeight.w500),
            ),
          ],
        ),
        ElevatedButton.icon(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => const RaiseComplaintDialog(),
            );
          },
          icon: const Icon(Icons.add, size: 18),
          label: const Text('Raise Complaint'),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.navy900,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            elevation: 8,
            shadowColor: AppColors.navy900.withOpacity(0.3),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          ),
        ),
      ],
    );
  }

  Widget _buildTabs(BuildContext context, DashboardState state) {
    final activeCount = state.dashboardData?.metrics.inProgressCount ?? 0;
    
    return Row(
      children: [
        _TabItem(
          icon: Icons.dashboard_outlined,
          label: 'Dashboard',
          isActive: state.activeTab == DashboardTab.overview,
          onTap: () => context.read<DashboardCubit>().changeTab(DashboardTab.overview),
        ),
        const SizedBox(width: 12),
        _TabItem(
          icon: Icons.build_outlined,
          label: 'Complaints',
          badge: '$activeCount active',
          isActive: state.activeTab == DashboardTab.complaints,
          onTap: () => context.read<DashboardCubit>().changeTab(DashboardTab.complaints),
        ),
        const SizedBox(width: 12),
        _TabItem(
          icon: Icons.analytics_outlined,
          label: 'Reports',
          isActive: state.activeTab == DashboardTab.reports,
          onTap: () => context.read<DashboardCubit>().changeTab(DashboardTab.reports),
        ),
      ],
    );
  }
}

class _TabItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? badge;
  final bool isActive;
  final VoidCallback onTap;

  const _TabItem({
    required this.icon,
    required this.label,
    this.badge,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isActive ? AppColors.navy900 : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: isActive ? AppColors.navy900 : Colors.grey.shade300),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 18,
              color: isActive ? Colors.white : AppColors.ink600,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: isActive ? Colors.white : AppColors.ink600,
                fontSize: 14,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.bold,
              ),
            ),
            if (badge != null) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: isActive ? Colors.white.withOpacity(0.2) : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  badge!,
                  style: TextStyle(
                    color: isActive ? Colors.white : AppColors.ink400,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
