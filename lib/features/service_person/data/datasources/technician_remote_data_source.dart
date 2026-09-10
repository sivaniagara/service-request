import '../../../../core/network/http_service.dart';
import '../models/technician_dashboard_model.dart';
import '../models/technician_ticket_model.dart';
import '../models/technician_report_model.dart';

abstract class TechnicianRemoteDataSource {
  Future<TechnicianDashboardData> getTechnicianDashboard();
  Future<List<TechnicianTicket>> getTechnicianTickets();
  Future<TechnicianTicketDetail> getTechnicianTicketDetail(String ticketId);
  Future<TechnicianReportData> getTechnicianReports();
  Future<List<TechnicianHistoryItem>> getTechnicianHistory();
  Future<void> updateSupportMode(String ticketId, String supportMode);
  Future<Map<String, dynamic>> completeTechnicianTask(String ticketId, String notes);
}

class TechnicianRemoteDataSourceImpl implements TechnicianRemoteDataSource {
  final HttpService httpService;

  TechnicianRemoteDataSourceImpl({required this.httpService});

  @override
  Future<TechnicianDashboardData> getTechnicianDashboard() async {
    final response = await httpService.get("/api/technician/dashboard");
    return TechnicianDashboardData.fromJson(response['data']);
  }

  @override
  Future<List<TechnicianTicket>> getTechnicianTickets() async {
    final response = await httpService.get("/api/technician/tickets");
    return (response['data'] as List).map((e) => TechnicianTicket.fromJson(e)).toList();
  }

  @override
  Future<TechnicianTicketDetail> getTechnicianTicketDetail(String ticketId) async {
    final response = await httpService.get("/api/customer/tickets/$ticketId");
    return TechnicianTicketDetail.fromJson(response['data']);
  }

  @override
  Future<TechnicianReportData> getTechnicianReports() async {
    final response = await httpService.get("/api/technician/reports");
    return TechnicianReportData.fromJson(response['data']);
  }

  @override
  Future<List<TechnicianHistoryItem>> getTechnicianHistory() async {
    final response = await httpService.get("/api/technician/history");
    return (response['data'] as List).map((e) => TechnicianHistoryItem.fromJson(e)).toList();
  }

  @override
  Future<void> updateSupportMode(String ticketId, String supportMode) async {
    await httpService.patch(
      "/api/technician/tickets/$ticketId/mode",
      body: {"supportMode": supportMode},
    );
  }

  @override
  Future<Map<String, dynamic>> completeTechnicianTask(String ticketId, String notes) async {
    final response = await httpService.post(
      "/api/technician/tickets/$ticketId/complete",
      body: {"notes": notes},
    );
    return response;
  }
}
