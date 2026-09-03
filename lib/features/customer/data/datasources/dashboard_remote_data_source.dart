import '../../../../core/network/http_service.dart';
import '../models/complaint_models.dart';
import '../models/dashboard_models.dart';

abstract class DashboardRemoteDataSource {
  Future<CustomerDashboardData> getCustomerDashboard();
  Future<List<ServiceTicket>> getTickets(String status);
  Future<ServiceTicketDetail> getTicketDetail(String ticketId);
  Future<CustomerReport> getReport(String timeframe);
  Future<RaiseComplaintResponse> raiseTicket(RaiseComplaintRequest request);
}

class DashboardRemoteDataSourceImpl implements DashboardRemoteDataSource {
  final HttpService httpService;

  DashboardRemoteDataSourceImpl({required this.httpService});

  @override
  Future<CustomerDashboardData> getCustomerDashboard() async {
    final response = await httpService.get("/api/customer/dashboard");
    return CustomerDashboardData.fromJson(response['data']);
  }

  @override
  Future<List<ServiceTicket>> getTickets(String status) async {
    final response = await httpService.get("/api/customer/tickets?status=$status");
    return (response['data'] as List).map((e) => ServiceTicket.fromJson(e)).toList();
  }

  @override
  Future<ServiceTicketDetail> getTicketDetail(String ticketId) async {
    final response = await httpService.get("/api/customer/tickets/$ticketId");
    return ServiceTicketDetail.fromJson(response['data']);
  }

  @override
  Future<CustomerReport> getReport(String timeframe) async {
    final response = await httpService.get("/api/customer/reports?timeframe=$timeframe");
    return CustomerReport.fromJson(response['data']);
  }

  @override
  Future<RaiseComplaintResponse> raiseTicket(RaiseComplaintRequest request) async {
    final response = await httpService.post("/api/customer/tickets", body: request.toJson());
    return RaiseComplaintResponse.fromJson(response);
  }
}
