import '../../data/models/dealer_dashboard_model.dart';
import '../../data/models/dealer_ticket_model.dart';
import '../../data/models/dealer_technician_model.dart';
import '../../data/models/dealer_report_model.dart';

enum DealerDashboardTab { dashboard, serviceRequests, team, reports }

class DealerDashboardState {
  final bool isLoading;
  final bool isTicketsLoading;
  final bool isDetailLoading;
  final bool isReportLoading;
  final DealerDashboardData? dashboardData;
  final List<DealerTicket>? tickets;
  final DealerTicket? selectedTicket;
  final DealerTicketDetail? selectedTicketDetail;
  final List<DealerTechnician>? technicians;
  final DealerPerformanceReport? performanceReport;
  final bool isTechniciansLoading;
  final String? error;
  final DealerDashboardTab activeTab;

  DealerDashboardState({
    this.isLoading = false,
    this.isTicketsLoading = false,
    this.isDetailLoading = false,
    this.isReportLoading = false,
    this.dashboardData,
    this.tickets,
    this.selectedTicket,
    this.selectedTicketDetail,
    this.technicians,
    this.performanceReport,
    this.isTechniciansLoading = false,
    this.error,
    this.activeTab = DealerDashboardTab.dashboard,
  });

  DealerDashboardState copyWith({
    bool? isLoading,
    bool? isTicketsLoading,
    bool? isDetailLoading,
    bool? isReportLoading,
    DealerDashboardData? dashboardData,
    List<DealerTicket>? tickets,
    DealerTicket? selectedTicket,
    DealerTicketDetail? selectedTicketDetail,
    List<DealerTechnician>? technicians,
    DealerPerformanceReport? performanceReport,
    bool? isTechniciansLoading,
    String? error,
    DealerDashboardTab? activeTab,
  }) {
    return DealerDashboardState(
      isLoading: isLoading ?? this.isLoading,
      isTicketsLoading: isTicketsLoading ?? this.isTicketsLoading,
      isDetailLoading: isDetailLoading ?? this.isDetailLoading,
      isReportLoading: isReportLoading ?? this.isReportLoading,
      dashboardData: dashboardData ?? this.dashboardData,
      tickets: tickets ?? this.tickets,
      selectedTicket: selectedTicket ?? this.selectedTicket,
      selectedTicketDetail: selectedTicketDetail ?? this.selectedTicketDetail,
      technicians: technicians ?? this.technicians,
      performanceReport: performanceReport ?? this.performanceReport,
      isTechniciansLoading: isTechniciansLoading ?? this.isTechniciansLoading,
      error: error ?? this.error,
      activeTab: activeTab ?? this.activeTab,
    );
  }
}
