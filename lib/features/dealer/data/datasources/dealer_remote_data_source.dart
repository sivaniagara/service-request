import '../../../../core/network/http_service.dart';
import '../models/dealer_dashboard_model.dart';
import '../models/dealer_ticket_model.dart';
import '../models/dealer_technician_model.dart';

abstract class DealerRemoteDataSource {
  Future<DealerDashboardData> getDealerDashboard();
  Future<List<DealerTicket>> getDealerTickets();
  Future<DealerTicketDetail> getDealerTicketDetail(String ticketId);
  Future<List<DealerTechnician>> getTechnicians();
  Future<DealerServiceTeamModel> getServiceTeam();
  Future<void> addTechnician(Map<String, dynamic> data);
  Future<void> assignTechnician(String ticketId, String technicianId, String notes);
}

class DealerRemoteDataSourceImpl implements DealerRemoteDataSource {
  final HttpService httpService;

  DealerRemoteDataSourceImpl({required this.httpService});

  @override
  Future<DealerDashboardData> getDealerDashboard() async {
    final response = await httpService.get("/api/dealer/dashboard");
    return DealerDashboardData.fromJson(response['data']);
  }

  @override
  Future<List<DealerTicket>> getDealerTickets() async {
    final response = await httpService.get("/api/dealer/tickets");
    return (response['data'] as List).map((e) => DealerTicket.fromJson(e)).toList();
  }

  @override
  Future<DealerTicketDetail> getDealerTicketDetail(String ticketId) async {
    final response = await httpService.get("/api/customer/tickets/$ticketId");
    return DealerTicketDetail.fromJson(response['data']);
  }

  @override
  Future<List<DealerTechnician>> getTechnicians() async {
    final response = await httpService.get("/api/dealer/technicians");
    return (response['data'] as List).map((e) => DealerTechnician.fromJson(e)).toList();
  }

  @override
  Future<DealerServiceTeamModel> getServiceTeam() async {
    final response = await httpService.get("/api/dealer/service-team");
    return DealerServiceTeamModel.fromJson(response['data']);
  }

  @override
  Future<void> addTechnician(Map<String, dynamic> data) async {
    await httpService.post("/api/dealer/technicians", body: data);
  }

  @override
  Future<void> assignTechnician(String ticketId, String technicianId, String notes) async {
    await httpService.post(
      "/api/dealer/tickets/$ticketId/assign-technician",
      body: {
        "technicianId": technicianId,
        "notes": notes,
      },
    );
  }
}
