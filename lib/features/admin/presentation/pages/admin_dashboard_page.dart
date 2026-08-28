import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_side_navigation.dart';
import '../../../../core/router/route_names.dart';
import '../../../../injection_container.dart';
import '../bloc/admin_dashboard_cubit.dart';
import '../bloc/admin_dashboard_state.dart';
import '../widgets/admin_stat_card.dart';
import '../widgets/top_dealers_card.dart';
import '../widgets/pending_actions_card.dart';
import '../widgets/admin_ticket_list_sidebar.dart';
import '../widgets/tickets/admin_ticket_detail_view.dart';
import '../widgets/admin_dealer_management_view.dart';
import '../widgets/admin_reports_view.dart';

class AdminDashboardPage extends StatelessWidget {
  const AdminDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<AdminDashboardCubit>()..loadDashboard(),
      child: Scaffold(
        backgroundColor: AppColors.bg,
        body: BlocBuilder<AdminDashboardCubit, AdminDashboardState>(
          builder: (context, state) {
            return Row(
              children: [
                AppSideNavigation(
                  brandName: 'Green Sprout',
                  brandSubtext: 'Super Admin Console',
                  onProfileTap: () => context.push(RouteNames.profileSetup),
                  onLogoutTap: () => context.go(RouteNames.login),
                  items: [
                    NavItem(
                      icon: Icons.dashboard_outlined,
                      label: 'Platform Overview',
                      isActive: state.activeTab == AdminDashboardTab.overview,
                      onTap: () => context.read<AdminDashboardCubit>().changeTab(AdminDashboardTab.overview),
                    ),
                    NavItem(
                      icon: Icons.build_outlined,
                      label: 'Service Requests',
                      badge: '1 new',
                      isActive: state.activeTab == AdminDashboardTab.serviceRequests,
                      onTap: () => context.read<AdminDashboardCubit>().changeTab(AdminDashboardTab.serviceRequests),
                    ),
                    NavItem(
                      icon: Icons.storefront_outlined,
                      label: 'Dealers',
                      badge: '4',
                      isActive: state.activeTab == AdminDashboardTab.dealerManagement,
                      onTap: () => context.read<AdminDashboardCubit>().changeTab(AdminDashboardTab.dealerManagement),
                    ),
                    NavItem(
                      icon: Icons.analytics_outlined,
                      label: 'Reports',
                      isActive: state.activeTab == AdminDashboardTab.reports,
                      onTap: () => context.read<AdminDashboardCubit>().changeTab(AdminDashboardTab.reports),
                    ),
                  ],
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildHeader(context),
                        const SizedBox(height: 32),
                        if (state.isLoading && 
                            state.dashboardData == null && 
                            state.tickets == null &&
                            state.dealers == null &&
                            state.reportSummary == null)
                          const Expanded(child: Center(child: CircularProgressIndicator()))
                        else if (state.error != null)
                          Expanded(child: Center(child: Text(state.error!, style: const TextStyle(color: AppColors.red500))))
                        else if (state.activeTab == AdminDashboardTab.overview)
                          _buildOverview(state)
                        else if (state.activeTab == AdminDashboardTab.serviceRequests)
                          _buildServiceRequests(context, state)
                        else if (state.activeTab == AdminDashboardTab.dealerManagement)
                          _buildDealerManagement(state)
                        else if (state.activeTab == AdminDashboardTab.reports)
                          _buildReports(state)
                        else
                          Expanded(
                            child: Center(
                              child: Text(
                                'Content for ${state.activeTab.name} coming soon',
                                style: const TextStyle(color: AppColors.ink400),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildDealerManagement(AdminDashboardState state) {
    if (state.dealers == null) return const SizedBox.shrink();
    return Expanded(child: AdminDealerManagementView(dealers: state.dealers!));
  }

  Widget _buildReports(AdminDashboardState state) {
    if (state.reportSummary == null || state.slaCompliance == null) return const SizedBox.shrink();
    return Expanded(child: AdminReportsView(summary: state.reportSummary!, sla: state.slaCompliance!));
  }

  Widget _buildOverview(AdminDashboardState state) {
    if (state.dashboardData == null) return const SizedBox.shrink();
    final data = state.dashboardData!;
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: AdminStatCard(
                    title: 'Total Requests',
                    value: data.summaryMetrics.totalTickets.toString(),
                    trend: '▲ 6% platform volume',
                    trendColor: Colors.green,
                    icon: Icons.build_circle_outlined,
                    iconColor: Colors.blue.shade300,
                    iconBgColor: Colors.blue.shade50,
                  ),
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: AdminStatCard(
                    title: 'Active Dealers',
                    value: data.summaryMetrics.activeDealersCount.toString(),
                    trend: 'Across 5 southern states',
                    trendColor: Colors.purple,
                    icon: Icons.store_outlined,
                    iconColor: Colors.purple.shade300,
                    iconBgColor: Colors.purple.shade50,
                  ),
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: AdminStatCard(
                    title: 'Total Service Technicians',
                    value: data.summaryMetrics.activeFieldTechnicians.toString(),
                    trend: 'Certified on field',
                    trendColor: Colors.orange,
                    icon: Icons.person_outline,
                    iconColor: Colors.orange.shade300,
                    iconBgColor: Colors.orange.shade50,
                  ),
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: AdminStatCard(
                    title: 'SLA Compliance',
                    value: data.summaryMetrics.slaComplianceRate,
                    trend: '▲ 96% resolved < 48h',
                    trendColor: Colors.green,
                    icon: Icons.track_changes,
                    iconColor: Colors.teal.shade300,
                    iconBgColor: Colors.teal.shade50,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 1,
                  child: TopDealersCard(regions: data.regionalDistribution),
                ),
                const SizedBox(width: 24),
                Expanded(
                  flex: 1,
                  child: PendingActionsCard(tickets: data.urgentAttentionQueue),
                ),
              ],
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceRequests(BuildContext context, AdminDashboardState state) {
    return Expanded(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 6,
            child: Column(
              children: [
                _buildSearchAndFilterBar(),
                const SizedBox(height: 24),
                Expanded(
                  child: AdminTicketListSidebar(
                    tickets: state.tickets ?? [],
                    selectedTicketId: state.selectedTicket?.ticketId ?? '',
                    onTicketSelected: (id) => context.read<AdminDashboardCubit>().selectTicket(id),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 24),
          Expanded(
            flex: 4,
            child: state.isDetailLoading
                ? const Center(child: CircularProgressIndicator())
                : state.selectedTicketDetail != null
                    ? AdminTicketDetailView(ticket: state.selectedTicketDetail!)
                    : Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.confirmation_number_outlined, size: 64, color: AppColors.ink400.withValues(alpha: 0.3)),
                            const SizedBox(height: 16),
                            const Text(
                              'Select a ticket to view detailed information',
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

  Widget _buildSearchAndFilterBar() {
    return Row(
      children: [
        Expanded(
          flex: 4,
          child: Container(
            height: 48,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.line),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                const Icon(Icons.search, color: AppColors.ink400, size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search tickets...',
                      hintStyle: const TextStyle(color: AppColors.ink400, fontSize: 14),
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      filled: false,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          flex: 6,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            child: Row(
              children: [
                _buildFilterPill('All', isActive: true),
                const SizedBox(width: 8),
                _buildFilterPill('Unassigned'),
                const SizedBox(width: 8),
                _buildFilterPill('Assigned to Handler'),
                const SizedBox(width: 8),
                _buildFilterPill('In Progress'),
                const SizedBox(width: 8),
                _buildFilterPill('Escalated'),
                const SizedBox(width: 8),
                _buildFilterPill('Closed'),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFilterPill(String label, {bool isActive = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: isActive ? AppColors.navy900 : Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: isActive ? AppColors.navy900 : AppColors.line),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isActive ? Colors.white : AppColors.ink600,
          fontSize: 13,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Super Admin Console',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.ink600,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Platform Overview',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: AppColors.navy900,
              ),
            ),
          ],
        ),
        ElevatedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.add, size: 20),
          label: const Text('Add New Dealer'),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.navy900,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTabs(BuildContext context, AdminDashboardState state) {
    return Row(
      children: [
        _TabItem(
          icon: Icons.dashboard,
          label: 'Platform Dashboard',
          isActive: state.activeTab == AdminDashboardTab.overview,
          onTap: () => context.read<AdminDashboardCubit>().changeTab(AdminDashboardTab.overview),
        ),
        const SizedBox(width: 12),
        _TabItem(
          icon: Icons.build_outlined,
          label: 'Service Requests',
          badge: '1 new',
          isActive: state.activeTab == AdminDashboardTab.serviceRequests,
          onTap: () => context.read<AdminDashboardCubit>().changeTab(AdminDashboardTab.serviceRequests),
        ),
        const SizedBox(width: 12),
        _TabItem(
          icon: Icons.storefront_outlined,
          label: 'Dealer Management',
          badge: '4',
          isActive: state.activeTab == AdminDashboardTab.dealerManagement,
          onTap: () => context.read<AdminDashboardCubit>().changeTab(AdminDashboardTab.dealerManagement),
        ),
        const SizedBox(width: 12),
        _TabItem(
          icon: Icons.analytics_outlined,
          label: 'Reports & Analytics',
          isActive: state.activeTab == AdminDashboardTab.reports,
          onTap: () => context.read<AdminDashboardCubit>().changeTab(AdminDashboardTab.reports),
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
            Icon(icon, size: 18, color: isActive ? Colors.white : AppColors.ink600),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: isActive ? Colors.white : AppColors.ink600,
                fontWeight: FontWeight.w600,
                fontSize: 14,
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
