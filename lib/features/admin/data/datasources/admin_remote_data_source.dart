import '../../../../core/network/http_service.dart';
import '../models/admin_dashboard_model.dart';
import '../models/admin_ticket_model.dart';
import '../models/admin_ticket_detail_model.dart';
import '../models/admin_dealer_model.dart';
import '../models/admin_report_models.dart';

abstract class AdminRemoteDataSource {
  Future<AdminDashboardModel> getDashboardData();
  Future<AdminTicketModel> getAdminTickets();
  Future<AdminTicketDetailModel> getAdminTicketDetail(String ticketId);
  Future<AdminDealerModel> getAdminDealers();
  Future<AdminReportSummaryModel> getReportSummary();
  Future<AdminSlaComplianceModel> getSlaCompliance();
  Future<void> addDealer(Map<String, dynamic> data);
  Future<void> assignDealer(String ticketId, List<String> dealerIds, String instructions);
}

class AdminRemoteDataSourceImpl implements AdminRemoteDataSource {
  final HttpService httpService;

  AdminRemoteDataSourceImpl({required this.httpService});

  @override
  Future<AdminDashboardModel> getDashboardData() async {
    final response = await httpService.get("/api/admin/dashboard");
    return AdminDashboardModel.fromJson(response);
  }

  @override
  Future<AdminTicketModel> getAdminTickets() async {
    final response = await httpService.get("/api/admin/tickets");
    return AdminTicketModel.fromJson(response);
  }

  @override
  Future<AdminTicketDetailModel> getAdminTicketDetail(String ticketId) async {
    final response = await httpService.get("/api/customer/tickets/$ticketId");
    return AdminTicketDetailModel.fromJson(response);
  }

  @override
  Future<AdminDealerModel> getAdminDealers() async {
    final response = await httpService.get("/api/admin/dealers");
    return AdminDealerModel.fromJson(response);
  }

  @override
  Future<AdminReportSummaryModel> getReportSummary() async {
    final response = await httpService.get("/api/admin/reports/summary");
    return AdminReportSummaryModel.fromJson(response);
  }

  @override
  Future<AdminSlaComplianceModel> getSlaCompliance() async {
    final response = await httpService.get("/api/admin/reports/sla-compliance");
    return AdminSlaComplianceModel.fromJson(response);
  }

  @override
  Future<void> addDealer(Map<String, dynamic> data) async {
    await httpService.post("/api/admin/dealers", body: data);
  }

  @override
  Future<void> assignDealer(String ticketId, List<String> dealerIds, String instructions) async {
    await httpService.post(
      "/api/admin/tickets/$ticketId/assign-dealer",
      body: {
        "dealerIds": dealerIds,
        "instructions": instructions,
      },
    );
  }
}
