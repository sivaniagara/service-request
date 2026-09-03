import '../../data/models/admin_dashboard_model.dart';
import '../../data/models/admin_ticket_model.dart';
import '../../data/models/admin_ticket_detail_model.dart';
import '../../data/models/admin_dealer_model.dart';
import '../../data/models/admin_report_models.dart';

enum AdminDashboardTab { overview, serviceRequests, dealerManagement, reports }

class AdminDashboardState {
  final bool isLoading;
  final bool isDetailLoading;
  final AdminDashboardData? dashboardData;
  final List<AdminTicketItem>? tickets;
  final List<AdminDealerListItem>? dealerList;
  final AdminTicketItem? selectedTicket;
  final AdminTicketDetailData? selectedTicketDetail;
  final AdminDealerModel? dealers;
  final AdminReportSummaryData? reportSummary;
  final AdminSlaComplianceData? slaCompliance;
  final String? error;
  final AdminDashboardTab activeTab;

  AdminDashboardState({
    this.isLoading = false,
    this.isDetailLoading = false,
    this.dashboardData,
    this.tickets,
    this.dealerList,
    this.selectedTicket,
    this.selectedTicketDetail,
    this.dealers,
    this.reportSummary,
    this.slaCompliance,
    this.error,
    this.activeTab = AdminDashboardTab.overview,
  });

  AdminDashboardState copyWith({
    bool? isLoading,
    bool? isDetailLoading,
    AdminDashboardData? dashboardData,
    List<AdminTicketItem>? tickets,
    List<AdminDealerListItem>? dealerList,
    AdminTicketItem? selectedTicket,
    AdminTicketDetailData? selectedTicketDetail,
    AdminDealerModel? dealers,
    AdminReportSummaryData? reportSummary,
    AdminSlaComplianceData? slaCompliance,
    String? error,
    AdminDashboardTab? activeTab,
  }) {
    return AdminDashboardState(
      isLoading: isLoading ?? this.isLoading,
      isDetailLoading: isDetailLoading ?? this.isDetailLoading,
      dashboardData: dashboardData ?? this.dashboardData,
      tickets: tickets ?? this.tickets,
      dealerList: dealerList ?? this.dealerList,
      selectedTicket: selectedTicket ?? this.selectedTicket,
      selectedTicketDetail: selectedTicketDetail ?? this.selectedTicketDetail,
      dealers: dealers ?? this.dealers,
      reportSummary: reportSummary ?? this.reportSummary,
      slaCompliance: slaCompliance ?? this.slaCompliance,
      error: error ?? this.error,
      activeTab: activeTab ?? this.activeTab,
    );
  }
}
