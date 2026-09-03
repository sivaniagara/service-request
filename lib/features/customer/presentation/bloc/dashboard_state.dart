import 'package:equatable/equatable.dart';
import '../../data/models/dashboard_models.dart';

enum DashboardTab { overview, complaints, reports }

class DashboardState extends Equatable {
  final DashboardTab activeTab;
  final bool isLoading;
  final CustomerDashboardData? dashboardData;
  final List<ServiceTicket>? tickets;
  final ServiceTicketDetail? selectedTicket;
  final CustomerReport? report;
  final String? selectedActiveTicketId;
  final String? error;

  const DashboardState({
    this.activeTab = DashboardTab.overview,
    this.isLoading = false,
    this.dashboardData,
    this.tickets,
    this.selectedTicket,
    this.report,
    this.selectedActiveTicketId,
    this.error,
  });

  DashboardState copyWith({
    DashboardTab? activeTab,
    bool? isLoading,
    CustomerDashboardData? dashboardData,
    List<ServiceTicket>? tickets,
    ServiceTicketDetail? selectedTicket,
    CustomerReport? report,
    String? selectedActiveTicketId,
    String? error,
  }) {
    return DashboardState(
      activeTab: activeTab ?? this.activeTab,
      isLoading: isLoading ?? this.isLoading,
      dashboardData: dashboardData ?? this.dashboardData,
      tickets: tickets ?? this.tickets,
      selectedTicket: selectedTicket ?? this.selectedTicket,
      report: report ?? this.report,
      selectedActiveTicketId: selectedActiveTicketId ?? this.selectedActiveTicketId,
      error: error,
    );
  }

  @override
  List<Object?> get props => [
        activeTab,
        isLoading,
        dashboardData,
        tickets,
        selectedTicket,
        report,
        selectedActiveTicketId,
        error,
      ];
}
