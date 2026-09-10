import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/network/token_manager.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/router/route_names.dart';
import '../../../../injection_container.dart';
import '../bloc/technician_dashboard_cubit.dart';
import '../bloc/technician_dashboard_state.dart';
import 'technician_dashboard_view.dart';
import 'technician_reports_view.dart';
import 'technician_ticket_list_sidebar.dart';
import '../pages/technician_ticket_detail_page.dart';

class TechnicianMobileDashboard extends StatelessWidget {
  final Function(String ticketId, String mode) onSupportModeChange;
  final Function(String ticketId) onTaskComplete;

  const TechnicianMobileDashboard({
    super.key,
    required this.onSupportModeChange,
    required this.onTaskComplete,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TechnicianDashboardCubit, TechnicianDashboardState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.bg,
          appBar: _buildAppBar(context, state),
          body: _buildBody(context, state),
          bottomNavigationBar: _buildBottomNav(context, state),
        );
      },
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, TechnicianDashboardState state) {
    return AppBar(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      elevation: 0,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Technician Console',
            style: TextStyle(
              color: AppColors.ink400,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            _getTabTitle(state.activeTab),
            style: const TextStyle(
              color: AppColors.navy900,
              fontSize: 18,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.logout, color: AppColors.red500),
          onPressed: () async {
            await sl<TokenManager>().deleteToken();
            if (context.mounted) context.go(RouteNames.login);
          },
        ),
      ],
    );
  }

  String _getTabTitle(TechnicianDashboardTab tab) {
    switch (tab) {
      case TechnicianDashboardTab.dashboard:
        return 'Overview';
      case TechnicianDashboardTab.serviceRequests:
        return 'Service Requests';
      case TechnicianDashboardTab.reports:
        return 'Reports';
    }
  }

  Widget _buildBody(BuildContext context, TechnicianDashboardState state) {
    if (state.isLoading || state.isTicketsLoading || state.isReportLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    switch (state.activeTab) {
      case TechnicianDashboardTab.dashboard:
        return _buildOverview(context, state);
      case TechnicianDashboardTab.serviceRequests:
        return _buildServiceRequests(context, state);
      case TechnicianDashboardTab.reports:
        return _buildReports(state);
    }
  }

  Widget _buildOverview(BuildContext context, TechnicianDashboardState state) {
    if (state.dashboardData == null) return const SizedBox.shrink();
    return TechnicianDashboardView(
      data: state.dashboardData!,
      onOpenQueue: () => context.read<TechnicianDashboardCubit>().changeTab(TechnicianDashboardTab.serviceRequests),
      onViewTicket: (id) async {
        final cubit = context.read<TechnicianDashboardCubit>();
        await cubit.loadTicketDetail(id);
        if (context.mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => BlocProvider.value(
                value: cubit,
                child: TechnicianTicketDetailPage(
                  ticketId: id,
                  onSupportModeChange: (mode) => onSupportModeChange(id, mode),
                  onTaskComplete: () => onTaskComplete(id),
                ),
              ),
            ),
          );
        }
      },
    );
  }

  Widget _buildServiceRequests(BuildContext context, TechnicianDashboardState state) {
    return RefreshIndicator(
      onRefresh: () => context.read<TechnicianDashboardCubit>().loadDashboard(),
      child: TechnicianTicketListSidebar(
        tickets: state.tickets ?? [],
        selectedTicketId: '',
        onTicketSelected: (id) async {
          final cubit = context.read<TechnicianDashboardCubit>();
          await cubit.loadTicketDetail(id);
          if (context.mounted) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => BlocProvider.value(
                  value: cubit,
                  child: TechnicianTicketDetailPage(
                    ticketId: id,
                    onSupportModeChange: (mode) => onSupportModeChange(id, mode),
                    onTaskComplete: () => onTaskComplete(id),
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildReports(TechnicianDashboardState state) {
    if (state.reportData == null) return const SizedBox.shrink();
    return TechnicianReportsView(
      reportData: state.reportData!,
      history: state.history ?? [],
    );
  }

  Widget _buildBottomNav(BuildContext context, TechnicianDashboardState state) {
    return BottomNavigationBar(
      currentIndex: state.activeTab.index,
      selectedItemColor: AppColors.navy900,
      unselectedItemColor: AppColors.ink400,
      onTap: (index) => context.read<TechnicianDashboardCubit>().changeTab(TechnicianDashboardTab.values[index]),
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.dashboard_outlined), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.build_outlined), label: 'Work'),
        BottomNavigationBarItem(icon: Icon(Icons.analytics_outlined), label: 'Reports'),
      ],
    );
  }
}
