import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import '../../../../core/network/token_manager.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_side_navigation.dart';
import '../../../../injection_container.dart';
import '../bloc/technician_dashboard_cubit.dart';
import '../bloc/technician_dashboard_state.dart';
import '../widgets/technician_dashboard_view.dart';
import '../widgets/technician_reports_view.dart';
import '../widgets/technician_service_requests_view.dart';

class TechnicianDashboardPage extends StatefulWidget {
  const TechnicianDashboardPage({super.key});

  @override
  State<TechnicianDashboardPage> createState() => _TechnicianDashboardPageState();
}

class _TechnicianDashboardPageState extends State<TechnicianDashboardPage> {
  String _targetTicketId = '';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<TechnicianDashboardCubit>()..loadDashboard(),
      child: BlocListener<TechnicianDashboardCubit, TechnicianDashboardState>(
        listenWhen: (previous, current) => previous.error != current.error && current.error != null,
        listener: (context, state) {
          if (state.error != null) {
            AwesomeDialog(
              context: context,
              dialogType: DialogType.error,
              animType: AnimType.bottomSlide,
              title: 'Error',
              desc: state.error,
              btnOkOnPress: () {},
              width: 400,
            ).show();
          }
        },
        child: Scaffold(
          backgroundColor: AppColors.bg,
          body: Row(
            children: [
              BlocBuilder<TechnicianDashboardCubit, TechnicianDashboardState>(
                buildWhen: (previous, current) => previous.activeTab != current.activeTab,
                builder: (context, state) {
                  return AppSideNavigation(
                    brandName: 'Green Sprout',
                    brandSubtext: 'Technician Console',
                    onProfileTap: () {},
                    onLogoutTap: () async {
                      await sl<TokenManager>().deleteToken();
                      if (context.mounted) context.go(RouteNames.login);
                    },
                    items: [
                      NavItem(
                        icon: Icons.dashboard_outlined,
                        label: 'Dashboard',
                        isActive: state.activeTab == TechnicianDashboardTab.dashboard,
                        onTap: () => context.read<TechnicianDashboardCubit>().changeTab(TechnicianDashboardTab.dashboard),
                      ),
                      NavItem(
                        icon: Icons.build_outlined,
                        label: 'Service Request',
                        isActive: state.activeTab == TechnicianDashboardTab.serviceRequests,
                        onTap: () {
                          setState(() => _targetTicketId = '');
                          context.read<TechnicianDashboardCubit>().changeTab(TechnicianDashboardTab.serviceRequests);
                        },
                      ),
                      NavItem(
                        icon: Icons.analytics_outlined,
                        label: 'Report',
                        isActive: state.activeTab == TechnicianDashboardTab.reports,
                        onTap: () => context.read<TechnicianDashboardCubit>().changeTab(TechnicianDashboardTab.reports),
                      ),
                    ],
                  );
                },
              ),
              Expanded(
                child: BlocBuilder<TechnicianDashboardCubit, TechnicianDashboardState>(
                  builder: (context, state) {
                    if (state.isLoading || state.isTicketsLoading || state.isReportLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    return _buildBody(state, context);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBody(TechnicianDashboardState state, BuildContext context) {
    switch (state.activeTab) {
      case TechnicianDashboardTab.dashboard:
        if (state.dashboardData == null) {
          return const Center(child: Text("Failed to load dashboard data"));
        }
        return TechnicianDashboardView(
          data: state.dashboardData!,
          onOpenQueue: () => context.read<TechnicianDashboardCubit>().changeTab(TechnicianDashboardTab.serviceRequests),
          onViewTicket: (id) {
            setState(() => _targetTicketId = id);
            context.read<TechnicianDashboardCubit>().changeTab(TechnicianDashboardTab.serviceRequests);
          },
        );
      case TechnicianDashboardTab.serviceRequests:
        return TechnicianServiceRequestsView(
          tickets: state.tickets ?? [],
          initialTicketId: _targetTicketId,
          onStatusUpdate: (id, status, {notes, photos}) {
            AwesomeDialog(
              context: context,
              dialogType: status == 'Closed' ? DialogType.warning : DialogType.question,
              animType: AnimType.bottomSlide,
              title: status == 'Closed' ? 'Resolve Ticket' : 'Update Status',
              desc: status == 'Closed' 
                ? 'Are you sure you want to mark this ticket as resolved?' 
                : 'Do you want to change status to $status?',
              btnCancelOnPress: () {},
              btnOkOnPress: () async {
                final cubit = context.read<TechnicianDashboardCubit>();
                final detail = cubit.state.selectedTicketDetail;
                if (detail == null) return;

                bool success = false;
                if (status == 'Closed') {
                  success = await cubit.resolveTicket(id, notes ?? "Resolved", photos ?? []);
                } else {
                  success = await cubit.updateTicketStatus(id, status, detail.supportMode!);
                }

                if (success && mounted) {
                  AwesomeDialog(
                    context: context,
                    dialogType: DialogType.success,
                    animType: AnimType.bottomSlide,
                    title: 'Success',
                    desc: status == 'Closed' ? 'Ticket resolved successfully' : 'Status updated to $status',
                    btnOkOnPress: () {},
                    width: 400,
                  ).show();
                }
              },
              width: 400,
            ).show();
          },
          onSupportModeChange: (id, mode) {
            AwesomeDialog(
              context: context,
              dialogType: DialogType.question,
              animType: AnimType.bottomSlide,
              title: 'Change Support Mode',
              desc: 'Are you sure you want to change the support mode to $mode?',
              btnCancelOnPress: () {},
              btnOkOnPress: () async {
                final cubit = context.read<TechnicianDashboardCubit>();
                final success = await cubit.updateSupportMode(id, mode);
                if (success && mounted) {
                  AwesomeDialog(
                    context: context,
                    dialogType: DialogType.success,
                    animType: AnimType.bottomSlide,
                    title: 'Success',
                    desc: 'Support mode updated to $mode',
                    btnOkOnPress: () {},
                    width: 400,
                  ).show();
                }
              },
              width: 400,
            ).show();
          },
          onTaskComplete: (id) {
            final notesController = TextEditingController();
            AwesomeDialog(
              context: context,
              dialogType: DialogType.question,
              animType: AnimType.bottomSlide,
              title: 'Complete Technician Task',
              body: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Text('Please provide any notes for this task.'),
                    const SizedBox(height: 16),
                    TextField(
                      controller: notesController,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        hintText: 'Notes (optional)',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),
              ),
              btnCancelOnPress: () {},
              btnOkOnPress: () async {
                // Show loading dialog
                final loadingDialog = AwesomeDialog(
                  context: context,
                  dialogType: DialogType.noHeader,
                  animType: AnimType.scale,
                  body: const Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 16),
                        Text('Completing task...'),
                      ],
                    ),
                  ),
                  dismissOnTouchOutside: false,
                  dismissOnBackKeyPress: false,
                  width: 400,
                );
                loadingDialog.show();

                final cubit = context.read<TechnicianDashboardCubit>();
                final success = await cubit.completeTechnicianTask(id, notesController.text);
                
                if (context.mounted) {
                  Navigator.of(context).pop(); // Dismiss loading dialog
                }

                if (success && mounted) {
                  AwesomeDialog(
                    context: context,
                    dialogType: DialogType.success,
                    animType: AnimType.bottomSlide,
                    title: 'Task Completed',
                    desc: 'Your portion of the ticket has been marked as complete.',
                    btnOkOnPress: () {},
                    width: 400,
                  ).show();
                }
              },
              width: 400,
            ).show();
          },
        );
      case TechnicianDashboardTab.reports:
        if (state.reportData == null) {
          return const Center(child: Text("Failed to load report data"));
        }
        return TechnicianReportsView(
          reportData: state.reportData!,
          history: state.history ?? [],
        );
    }
  }
}
