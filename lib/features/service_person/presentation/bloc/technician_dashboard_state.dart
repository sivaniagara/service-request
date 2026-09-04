import 'package:equatable/equatable.dart';
import '../../data/models/technician_dashboard_model.dart';
import '../../data/models/technician_ticket_model.dart';
import '../../data/models/technician_report_model.dart';

enum TechnicianDashboardTab { dashboard, serviceRequests, reports }

class TechnicianDashboardState extends Equatable {
  final bool isLoading;
  final bool isTicketsLoading;
  final bool isDetailLoading;
  final bool isReportLoading;
  final bool isSubmitting;
  final String? error;
  final TechnicianDashboardData? dashboardData;
  final List<TechnicianTicket>? tickets;
  final TechnicianTicketDetail? selectedTicketDetail;
  final TechnicianReportData? reportData;
  final List<TechnicianHistoryItem>? history;
  final TechnicianDashboardTab activeTab;

  const TechnicianDashboardState({
    this.isLoading = false,
    this.isTicketsLoading = false,
    this.isDetailLoading = false,
    this.isReportLoading = false,
    this.isSubmitting = false,
    this.error,
    this.dashboardData,
    this.tickets,
    this.selectedTicketDetail,
    this.reportData,
    this.history,
    this.activeTab = TechnicianDashboardTab.dashboard,
  });

  TechnicianDashboardState copyWith({
    bool? isLoading,
    bool? isTicketsLoading,
    bool? isDetailLoading,
    bool? isReportLoading,
    bool? isSubmitting,
    String? error,
    TechnicianDashboardData? dashboardData,
    List<TechnicianTicket>? tickets,
    TechnicianTicketDetail? selectedTicketDetail,
    TechnicianReportData? reportData,
    List<TechnicianHistoryItem>? history,
    TechnicianDashboardTab? activeTab,
  }) {
    return TechnicianDashboardState(
      isLoading: isLoading ?? this.isLoading,
      isTicketsLoading: isTicketsLoading ?? this.isTicketsLoading,
      isDetailLoading: isDetailLoading ?? this.isDetailLoading,
      isReportLoading: isReportLoading ?? this.isReportLoading,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      error: error,
      dashboardData: dashboardData ?? this.dashboardData,
      tickets: tickets ?? this.tickets,
      selectedTicketDetail: selectedTicketDetail ?? this.selectedTicketDetail,
      reportData: reportData ?? this.reportData,
      history: history ?? this.history,
      activeTab: activeTab ?? this.activeTab,
    );
  }

  @override
  List<Object?> get props => [
        isLoading,
        isTicketsLoading,
        isDetailLoading,
        isReportLoading,
        isSubmitting,
        error,
        dashboardData,
        tickets,
        selectedTicketDetail,
        reportData,
        history,
        activeTab,
      ];
}
