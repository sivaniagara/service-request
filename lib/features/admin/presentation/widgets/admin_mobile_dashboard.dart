import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/network/token_manager.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/router/route_names.dart';
import '../../../../injection_container.dart';
import '../bloc/admin_dashboard_cubit.dart';
import '../bloc/admin_dashboard_state.dart';
import 'add_dealer_page.dart';
import 'admin_mobile_stat_grid.dart';
import 'top_dealers_card.dart';
import 'pending_actions_card.dart';
import 'admin_mobile_ticket_card.dart';
import '../pages/admin_ticket_detail_page.dart';
import 'admin_mobile_dealer_management_view.dart';
import 'admin_mobile_reports_view.dart';

class AdminMobileDashboard extends StatelessWidget {
  const AdminMobileDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdminDashboardCubit, AdminDashboardState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.bg,
          appBar: _buildAppBar(context, state),
          body: _buildBody(context, state),
          bottomNavigationBar: _buildBottomNav(context, state),
          floatingActionButton: state.activeTab == AdminDashboardTab.dealerManagement
              ? FloatingActionButton.extended(
            onPressed: () => _openAddDealer(context),
            backgroundColor: AppColors.navy900,
            icon: const Icon(Icons.add, color: Colors.white, size: 20),
            label: const Text(
              'Add Dealer',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 13),
            ),
          )
              : null,
        );
      },
    );
  }

  void _openAddDealer(BuildContext context) {
    final cubit = context.read<AdminDashboardCubit>();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(value: cubit, child: const AddDealerPage()),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, AdminDashboardState state) {
    return AppBar(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      elevation: 0,
      scrolledUnderElevation: 1,
      titleSpacing: 16,
      title: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            margin: const EdgeInsets.only(right: 8, top: 2),
            decoration: const BoxDecoration(color: Color(0xFF7C6CF0), shape: BoxShape.circle),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'SUPER ADMIN CONSOLE',
                style: TextStyle(color: AppColors.ink400, fontSize: 9.5, fontWeight: FontWeight.w900, letterSpacing: 0.6),
              ),
              Text(
                _getTabTitle(state.activeTab),
                style: const TextStyle(color: AppColors.navy900, fontSize: 17, fontWeight: FontWeight.w900),
              ),
            ],
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

  String _getTabTitle(AdminDashboardTab tab) {
    switch (tab) {
      case AdminDashboardTab.overview:
        return 'Platform Overview';
      case AdminDashboardTab.serviceRequests:
        return 'Service Requests';
      case AdminDashboardTab.dealerManagement:
        return 'Dealer Management';
      case AdminDashboardTab.reports:
        return 'Reports & Analytics';
    }
  }

  Widget _buildBody(BuildContext context, AdminDashboardState state) {
    if (state.isLoading &&
        state.dashboardData == null &&
        state.tickets == null &&
        state.dealers == null) {
      return const Center(child: CircularProgressIndicator());
    }

    switch (state.activeTab) {
      case AdminDashboardTab.overview:
        return _buildOverview(context, state);
      case AdminDashboardTab.serviceRequests:
        return _buildServiceRequests(context, state);
      case AdminDashboardTab.dealerManagement:
        return _buildDealerManagement(state);
      case AdminDashboardTab.reports:
        return _buildReports(state);
    }
  }

  Widget _buildOverview(BuildContext context, AdminDashboardState state) {
    if (state.dashboardData == null) return const SizedBox.shrink();
    final data = state.dashboardData!;

    return RefreshIndicator(
      onRefresh: () => context.read<AdminDashboardCubit>().loadDashboard(),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AdminMobileStatGrid(
              stats: [
                AdminMobileStat(
                  title: 'Total Requests',
                  value: data.summaryMetrics.totalTickets.toString(),
                  trend: '▲ 6% volume',
                  trendColor: Colors.green,
                  icon: Icons.build_circle_outlined,
                  iconColor: Colors.blue.shade300,
                  iconBgColor: Colors.blue.shade50,
                ),
                AdminMobileStat(
                  title: 'Active Dealers',
                  value: data.summaryMetrics.activeDealersCount.toString(),
                  trend: '5 states',
                  trendColor: Colors.purple,
                  icon: Icons.store_outlined,
                  iconColor: Colors.purple.shade300,
                  iconBgColor: Colors.purple.shade50,
                ),
                AdminMobileStat(
                  title: 'Technicians',
                  value: data.summaryMetrics.activeFieldTechnicians.toString(),
                  trend: 'Certified',
                  trendColor: Colors.orange,
                  icon: Icons.person_outline,
                  iconColor: Colors.orange.shade300,
                  iconBgColor: Colors.orange.shade50,
                ),
                AdminMobileStat(
                  title: 'SLA Compliance',
                  value: data.summaryMetrics.slaComplianceRate,
                  trend: '▲ <48h',
                  trendColor: Colors.green,
                  icon: Icons.track_changes,
                  iconColor: Colors.teal.shade300,
                  iconBgColor: Colors.teal.shade50,
                ),
              ],
            ),
            const SizedBox(height: 20),
            TopDealersCard(regions: data.regionalDistribution),
            const SizedBox(height: 20),
            PendingActionsCard(tickets: data.urgentAttentionQueue),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceRequests(BuildContext context, AdminDashboardState state) {
    final tickets = state.tickets ?? [];

    return RefreshIndicator(
      onRefresh: () => context.read<AdminDashboardCubit>().loadDashboard(),
      child: tickets.isEmpty
          ? ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: const [
          SizedBox(height: 120),
          Center(
            child: Text('No service requests yet', style: TextStyle(color: AppColors.ink400)),
          ),
        ],
      )
          : ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        itemCount: tickets.length,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final ticket = tickets[index];
          return AdminMobileTicketCard(
            ticket: ticket,
            onTap: () async {
              final cubit = context.read<AdminDashboardCubit>();
              await cubit.selectTicket(ticket.ticketId);
              if (context.mounted && cubit.state.selectedTicketDetail != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AdminTicketDetailPage(
                      ticket: cubit.state.selectedTicketDetail!,
                      cubit: cubit,
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

  Widget _buildDealerManagement(AdminDashboardState state) {
    if (state.dealers == null) return const Center(child: CircularProgressIndicator());
    return AdminMobileDealerManagementView(dealers: state.dealers!);
  }

  Widget _buildReports(AdminDashboardState state) {
    if (state.reportSummary == null || state.slaCompliance == null) {
      return const Center(child: CircularProgressIndicator());
    }
    return AdminMobileReportsView(
      summary: state.reportSummary!,
      sla: state.slaCompliance!,
      regions: state.dashboardData?.regionalDistribution,
    );
  }

  Widget _buildBottomNav(BuildContext context, AdminDashboardState state) {
    return BottomNavigationBar(
      currentIndex: state.activeTab.index,
      selectedItemColor: const Color(0xFF7C6CF0),
      unselectedItemColor: AppColors.ink400,
      type: BottomNavigationBarType.fixed,
      onTap: (index) => context.read<AdminDashboardCubit>().changeTab(AdminDashboardTab.values[index]),
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.dashboard_outlined), label: 'Stats'),
        BottomNavigationBarItem(icon: Icon(Icons.build_outlined), label: 'Tickets'),
        BottomNavigationBarItem(icon: Icon(Icons.storefront_outlined), label: 'Dealers'),
        BottomNavigationBarItem(icon: Icon(Icons.analytics_outlined), label: 'Reports'),
      ],
    );
  }
}