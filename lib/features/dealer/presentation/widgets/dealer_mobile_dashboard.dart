import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/network/token_manager.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/router/route_names.dart';
import '../../../../injection_container.dart';
import '../bloc/dealer_dashboard_cubit.dart';
import '../bloc/dealer_dashboard_state.dart';
import 'dashboard/dealer_rating_banner.dart';
import 'dashboard/team_workload_card.dart';
import '../../../../core/widgets/kpi_card.dart';
import 'tickets/dealer_ticket_list_sidebar.dart';
import '../pages/dealer_ticket_detail_page.dart';
import 'dealer_mobile_team_view.dart';
import 'reports/dealer_performance_report_view.dart';
import 'dealer_mobile_sub_dealer_view.dart';
import 'add_technician_page.dart';
import 'add_sub_dealer_page.dart';

class DealerMobileDashboard extends StatelessWidget {
  const DealerMobileDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DealerDashboardCubit, DealerDashboardState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.bg,
          appBar: _buildAppBar(context, state),
          body: _buildBody(context, state),
          bottomNavigationBar: _buildBottomNav(context, state),
          floatingActionButton: _buildFab(context, state),
        );
      },
    );
  }

  Widget? _buildFab(BuildContext context, DealerDashboardState state) {
    if (state.activeTab == DealerDashboardTab.team) {
      return FloatingActionButton.extended(
        onPressed: () {
          final cubit = context.read<DealerDashboardCubit>();
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => BlocProvider.value(value: cubit, child: const AddTechnicianPage())),
          );
        },
        backgroundColor: AppColors.navy900,
        icon: const Icon(Icons.add, color: Colors.white, size: 20),
        label: const Text('Add Tech', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 13)),
      );
    }
    if (state.activeTab == DealerDashboardTab.subDealerManagement) {
      return FloatingActionButton.extended(
        onPressed: () {
          final cubit = context.read<DealerDashboardCubit>();
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => BlocProvider.value(value: cubit, child: const AddSubDealerPage())),
          );
        },
        backgroundColor: AppColors.navy900,
        icon: const Icon(Icons.add, color: Colors.white, size: 20),
        label: const Text('Add Branch', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 13)),
      );
    }
    return null;
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, DealerDashboardState state) {
    return AppBar(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      elevation: 0,
      scrolledUnderElevation: 1,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'DEALER WORKSPACE',
            style: TextStyle(
              color: AppColors.amber500,
              fontSize: 9.5,
              fontWeight: FontWeight.w900,
              letterSpacing: 0.6,
            ),
          ),
          Text(
            _getTabTitle(state.activeTab),
            style: const TextStyle(
              color: AppColors.navy900,
              fontSize: 17,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.logout, color: AppColors.red500),
          tooltip: 'Log out',
          onPressed: () async {
            await sl<TokenManager>().deleteToken();
            if (context.mounted) context.go(RouteNames.login);
          },
        ),
      ],
    );
  }

  String _getTabTitle(DealerDashboardTab tab) {
    switch (tab) {
      case DealerDashboardTab.dashboard:
        return 'Overview';
      case DealerDashboardTab.serviceRequests:
        return 'Service Requests';
      case DealerDashboardTab.team:
        return 'Service Team';
      case DealerDashboardTab.subDealerManagement:
        return 'Sub Dealers';
      case DealerDashboardTab.reports:
        return 'Performance';
    }
  }

  Widget _buildBody(BuildContext context, DealerDashboardState state) {
    if (state.isLoading && state.dashboardData == null) {
      return const Center(child: CircularProgressIndicator());
    }

    switch (state.activeTab) {
      case DealerDashboardTab.dashboard:
        return _buildOverview(context, state);
      case DealerDashboardTab.serviceRequests:
        return _buildServiceRequests(context, state);
      case DealerDashboardTab.team:
        return _buildTeamView(context, state);
      case DealerDashboardTab.subDealerManagement:
        return const DealerMobileSubDealerView();
      case DealerDashboardTab.reports:
        return _buildPerformanceReport(state);
    }
  }

  Widget _buildOverview(BuildContext context, DealerDashboardState state) {
    final data = state.dashboardData;
    return RefreshIndicator(
      onRefresh: () => context.read<DealerDashboardCubit>().loadDashboard(),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            DealerRatingBanner(
              rating: data?.profile.rating ?? 4.6,
              requestsHandled: data?.metrics.totalActiveTickets ?? 37,
              resolved: data?.metrics.inProgressTickets ?? 31,
              escalated: 2,
            ),
            const SizedBox(height: 16),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.5,
              children: [
                KPICard(
                  title: 'Assigned',
                  value: '3',
                  icon: Icons.build_circle_outlined,
                  iconColor: AppColors.blue500,
                  iconBgColor: AppColors.blue100,
                  subtitle: '',
                ),
                KPICard(
                  title: 'Technicians',
                  value: data?.metrics.totalTechniciansCount.toString() ?? '4',
                  icon: Icons.person_outline,
                  iconColor: AppColors.purple500,
                  iconBgColor: AppColors.purple100,
                ),
                KPICard(
                  title: 'Open Orders',
                  value: data?.metrics.pendingTechnicianAssignment.toString() ?? '2',
                  icon: Icons.folder_open_outlined,
                  iconColor: AppColors.orange500,
                  iconBgColor: AppColors.orange100,
                ),
                KPICard(
                  title: 'Rating',
                  value: '${data?.profile.rating ?? 4.6}★',
                  icon: Icons.sentiment_satisfied_alt,
                  iconColor: AppColors.green500,
                  iconBgColor: AppColors.green100,
                ),
              ],
            ),
            const SizedBox(height: 16),
            TeamWorkloadCard(
              technicians: state.dashboardData?.technicians ?? [],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceRequests(BuildContext context, DealerDashboardState state) {
    return RefreshIndicator(
      onRefresh: () => context.read<DealerDashboardCubit>().loadDashboard(),
      child: DealerTicketListSidebar(
        tickets: state.tickets ?? [],
        selectedTicketId: '',
        onAssign: (ticket) {}, // Handled in detail view on mobile
        onTicketSelected: (id) async {
          final cubit = context.read<DealerDashboardCubit>();
          await cubit.selectTicket(id);
          if (context.mounted && cubit.state.selectedTicketDetail != null) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => DealerTicketDetailPage(
                  ticket: cubit.state.selectedTicketDetail!,
                ),
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildTeamView(BuildContext context, DealerDashboardState state) {
    return RefreshIndicator(
      onRefresh: () => context.read<DealerDashboardCubit>().loadDashboard(),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: DealerMobileTeamView(data: state.serviceTeamData),
      ),
    );
  }

  Widget _buildPerformanceReport(DealerDashboardState state) {
    if (state.isReportLoading && state.performanceReport == null) {
      return const Center(child: CircularProgressIndicator());
    }
    if (state.performanceReport == null) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.all(16),
      child: DealerPerformanceReportView(report: state.performanceReport!),
    );
  }

  Widget _buildBottomNav(BuildContext context, DealerDashboardState state) {
    return BottomNavigationBar(
      currentIndex: state.activeTab.index,
      selectedItemColor: AppColors.navy900,
      unselectedItemColor: AppColors.ink400,
      type: BottomNavigationBarType.fixed,
      onTap: (index) => context.read<DealerDashboardCubit>().changeTab(DealerDashboardTab.values[index]),
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.dashboard_outlined), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.build_outlined), label: 'Tickets'),
        BottomNavigationBarItem(icon: Icon(Icons.people_outline), label: 'Team'),
        BottomNavigationBarItem(icon: Icon(Icons.account_tree_outlined), label: 'Sub'),
        BottomNavigationBarItem(icon: Icon(Icons.analytics_outlined), label: 'Perf'),
      ],
    );
  }
}