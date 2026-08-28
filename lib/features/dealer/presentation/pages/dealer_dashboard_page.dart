import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_side_navigation.dart';
import '../../../../core/router/route_names.dart';
import '../bloc/dealer_dashboard_cubit.dart';
import '../bloc/dealer_dashboard_state.dart';
import '../widgets/dashboard/dealer_rating_banner.dart';
import '../widgets/dashboard/team_workload_card.dart';
import '../widgets/dashboard/dealer_stat_card.dart';
import '../widgets/tickets/dealer_ticket_detail_view.dart';
import '../widgets/assign_technician_dialog.dart';
import '../widgets/dealer_team_view.dart';
import '../widgets/reports/dealer_performance_report_view.dart';
import '../../../../injection_container.dart';
import '../../data/models/dealer_ticket_model.dart';
import '../widgets/tickets/dealer_ticket_list_sidebar.dart';

class DealerDashboardPage extends StatelessWidget {
  const DealerDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<DealerDashboardCubit>()..loadDashboard(),
      child: Scaffold(
        backgroundColor: AppColors.bg,
        body: BlocBuilder<DealerDashboardCubit, DealerDashboardState>(
          builder: (context, state) {
            return Row(
              children: [
                AppSideNavigation(
                  brandName: 'Green Sprout',
                  brandSubtext: 'Dealer Workspace',
                  onProfileTap: () => context.push(RouteNames.profileSetup),
                  onLogoutTap: () => context.go(RouteNames.login),
                  items: [
                    NavItem(
                      icon: Icons.dashboard_outlined,
                      label: 'Dashboard',
                      isActive: state.activeTab == DealerDashboardTab.dashboard,
                      onTap: () => context.read<DealerDashboardCubit>().changeTab(DealerDashboardTab.dashboard),
                    ),
                    NavItem(
                      icon: Icons.build_outlined,
                      label: 'Service Requests',
                      badge: '3',
                      isActive: state.activeTab == DealerDashboardTab.serviceRequests,
                      onTap: () => context.read<DealerDashboardCubit>().changeTab(DealerDashboardTab.serviceRequests),
                    ),
                    NavItem(
                      icon: Icons.people_outline,
                      label: 'Service Team',
                      badge: '4',
                      isActive: state.activeTab == DealerDashboardTab.team,
                      onTap: () => context.read<DealerDashboardCubit>().changeTab(DealerDashboardTab.team),
                    ),
                    NavItem(
                      icon: Icons.analytics_outlined,
                      label: 'Performance',
                      isActive: state.activeTab == DealerDashboardTab.reports,
                      onTap: () => context.read<DealerDashboardCubit>().changeTab(DealerDashboardTab.reports),
                    ),
                  ],
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildHeader(context, state),
                        const SizedBox(height: 24),
                        if (state.isLoading)
                          const Expanded(child: Center(child: CircularProgressIndicator()))
                        else if (state.error != null)
                          Expanded(child: Center(child: Text(state.error!)))
                        else if (state.activeTab == DealerDashboardTab.dashboard)
                          _buildDashboardOverview(state)
                        else if (state.activeTab == DealerDashboardTab.serviceRequests)
                          _buildServiceRequests(context, state)
                        else if (state.activeTab == DealerDashboardTab.team)
                          _buildTeamView(state)
                        else if (state.activeTab == DealerDashboardTab.reports)
                          _buildPerformanceReport(state)
                        else
                          Expanded(
                            child: Center(
                              child: Text('Content for ${state.activeTab.name} coming soon'),
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

  Widget _buildPerformanceReport(DealerDashboardState state) {
    if (state.isReportLoading && state.performanceReport == null) {
      return const Expanded(child: Center(child: CircularProgressIndicator()));
    }
    if (state.performanceReport == null) {
      return const SizedBox.shrink();
    }
    return Expanded(
      child: DealerPerformanceReportView(report: state.performanceReport!),
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

  Widget _buildHeader(BuildContext context, DealerDashboardState state) {
    final profile = state.dashboardData?.profile;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.orange100,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    'Dealer Workspace',
                    style: TextStyle(
                      color: AppColors.amber500,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  profile?.name ?? 'Green Sprout Agro',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.navy900,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '• ${profile?.region ?? "Coimbatore, TN"}',
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.ink400,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              'Field Technician Dispatch & Complaint Execution Engine',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.ink600,
              ),
            ),
          ],
        ),
        ElevatedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.add, size: 20),
          label: const Text('Add Service Person'),
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

  Widget _buildDashboardOverview(DealerDashboardState state) {
    final data = state.dashboardData;
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          children: [
            DealerRatingBanner(
              rating: data?.profile.rating ?? 4.6,
              requestsHandled: data?.metrics.totalActiveTickets ?? 37,
              resolved: data?.metrics.inProgressTickets ?? 31,
              escalated: 2,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Expanded(
                  child: DealerStatCard(
                    title: 'Assigned Requests',
                    value: '3',
                    subtext: '▲ 5 vs last month',
                    subtextColor: Colors.green,
                    icon: Icons.build_circle_outlined,
                    iconColor: AppColors.blue500,
                    iconBgColor: AppColors.blue100,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: DealerStatCard(
                    title: 'Service Persons',
                    value: data?.metrics.totalTechniciansCount.toString() ?? '4',
                    subtext: 'On your active roster',
                    icon: Icons.person_outline,
                    iconColor: AppColors.purple500,
                    iconBgColor: AppColors.purple100,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: DealerStatCard(
                    title: 'Open Work Orders',
                    value: data?.metrics.pendingTechnicianAssignment.toString() ?? '2',
                    subtext: 'In progress',
                    subtextColor: AppColors.orange500,
                    icon: Icons.folder_open_outlined,
                    iconColor: AppColors.orange500,
                    iconBgColor: AppColors.orange100,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: DealerStatCard(
                    title: 'Customer Rating',
                    value: '${data?.profile.rating ?? 4.6}★',
                    subtext: '▲ 0.2 vs last period',
                    subtextColor: Colors.green,
                    icon: Icons.sentiment_satisfied_alt,
                    iconColor: AppColors.green500,
                    iconBgColor: AppColors.green100,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Expanded(
                  flex: 2,
                  child: TeamWorkloadCard(),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 1,
                  child: Container(), // Placeholder for other cards
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceRequests(BuildContext context, DealerDashboardState state) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.orange100.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.orange100),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: AppColors.orange500,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Icon(Icons.build, color: Colors.white, size: 16),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Dealer Execution & Technician Assignment',
                        style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.amber500, fontSize: 13),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Select a ticket to assign a field technician or update the vertical stepper to "Task Completed".',
                        style: TextStyle(color: AppColors.amber500, fontSize: 11),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          _buildDealerSearchAndFilterBar(),
          const SizedBox(height: 20),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 6,
                  child: state.isTicketsLoading
                      ? const Center(child: CircularProgressIndicator())
                      : DealerTicketListSidebar(
                          tickets: state.tickets ?? [],
                          selectedTicketId: state.selectedTicket?.ticketId ?? '',
                          onTicketSelected: (id) => context.read<DealerDashboardCubit>().selectTicket(id),
                          onAssign: (ticket) {
                            if (state.selectedTicketDetail != null && state.selectedTicketDetail!.ticketId == ticket.ticketId) {
                               _showAssignDialog(context, state.selectedTicketDetail!);
                            } else {
                              // If detail not loaded for this ticket, we'd fetch it here.
                              // For now, if it's the selected one, show it.
                            }
                          },
                        ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 4,
                  child: state.isDetailLoading
                      ? const Center(child: CircularProgressIndicator())
                      : state.selectedTicketDetail != null
                          ? DealerTicketDetailView(ticket: state.selectedTicketDetail!)
                          : const Center(child: Text('Select a ticket')),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDealerSearchAndFilterBar() {
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
                const Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search assigned tickets by #, customer, location...',
                      hintStyle: TextStyle(color: AppColors.ink400, fontSize: 14),
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
          flex: 3,
          child: Row(
            children: [
              _buildFilterPill('All', isActive: true),
              const SizedBox(width: 8),
              _buildFilterPill('Needs Tech'),
              const SizedBox(width: 8),
              _buildFilterPill('In Progress'),
              const SizedBox(width: 8),
              _buildFilterPill('Completed'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTeamView(DealerDashboardState state) {
    if (state.isTechniciansLoading && state.technicians == null) {
      return const Expanded(child: Center(child: CircularProgressIndicator()));
    }
    return Expanded(
      child: SingleChildScrollView(
        child: DealerTeamView(technicians: state.technicians ?? []),
      ),
    );
  }

  void _showAssignDialog(BuildContext context, DealerTicketDetail ticket) {
    showDialog(
      context: context,
      builder: (dialogContext) => BlocProvider.value(
        value: context.read<DealerDashboardCubit>(),
        child: AssignTechnicianDialog(ticket: ticket),
      ),
    );
  }
}
