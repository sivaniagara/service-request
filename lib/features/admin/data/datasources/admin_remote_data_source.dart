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
  Future<AdminReportSummaryModel> getReportSummary({String timeframe = '30D', String? region});
  Future<AdminSlaComplianceModel> getSlaCompliance({String timeframe = '30D'});
  Future<void> addDealer(Map<String, dynamic> data);
  Future<void> assignDealer(String ticketId, List<String> dealerIds, String instructions);
  Future<void> verifyCompletion(String ticketId, String notes);
  Future<void> sendCloseOtp(String ticketId);
  Future<void> verifyCloseOtp(String ticketId, String otp);
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
  Future<AdminReportSummaryModel> getReportSummary({String timeframe = '30D', String? region}) async {
    String url = "/api/admin/reports/summary?timeframe=$timeframe";
    if (region != null) url += "&region=$region";
    final response = await httpService.get(url);
    return AdminReportSummaryModel.fromJson(response);
  }

  @override
  Future<AdminSlaComplianceModel> getSlaCompliance({String timeframe = '30D'}) async {
    final response = await httpService.get("/api/admin/reports/sla-compliance?timeframe=$timeframe");
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

  @override
  Future<void> verifyCompletion(String ticketId, String notes) async {
    await httpService.patch(
      "/api/admin/tickets/$ticketId/verify-completion",
      body: {"notes": notes},
    );
  }

  @override
  Future<void> sendCloseOtp(String ticketId) async {
    await httpService.post("/api/admin/tickets/$ticketId/close/send-otp");
  }

  @override
  Future<void> verifyCloseOtp(String ticketId, String otp) async {
    await httpService.post(
      "/api/admin/tickets/$ticketId/close/verify-otp",
      body: {"otp": otp},
    );
  }
}
