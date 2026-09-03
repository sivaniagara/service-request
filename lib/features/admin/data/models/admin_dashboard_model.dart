class AdminDashboardModel {
  final String status;
  final AdminDashboardData data;

  AdminDashboardModel({
    required this.status,
    required this.data,
  });

  factory AdminDashboardModel.fromJson(Map<String, dynamic> json) {
    return AdminDashboardModel(
      status: json['status'],
      data: AdminDashboardData.fromJson(json['data']),
    );
  }
}

class AdminDashboardData {
  final SummaryMetrics summaryMetrics;
  final List<RegionalDistribution> regionalDistribution;
  final List<UrgentAttentionTicket> urgentAttentionQueue;

  AdminDashboardData({
    required this.summaryMetrics,
    required this.regionalDistribution,
    required this.urgentAttentionQueue,
  });

  factory AdminDashboardData.fromJson(Map<String, dynamic> json) {
    return AdminDashboardData(
      summaryMetrics: SummaryMetrics.fromJson(json['summaryMetrics']),
      regionalDistribution: (json['regionalDistribution'] as List)
          .map((i) => RegionalDistribution.fromJson(i))
          .toList(),
      urgentAttentionQueue: (json['urgentAttentionQueue'] as List)
          .map((i) => UrgentAttentionTicket.fromJson(i))
          .toList(),
    );
  }
}

class SummaryMetrics {
  final int totalTickets;
  final int pendingAssignment;
  final int inProgress;
  final int escalated;
  final int resolvedToday;
  final int activeDealersCount;
  final int activeFieldTechnicians;
  final String slaComplianceRate;
  final int avgFirstResponseMinutes;

  SummaryMetrics({
    required this.totalTickets,
    required this.pendingAssignment,
    required this.inProgress,
    required this.escalated,
    required this.resolvedToday,
    required this.activeDealersCount,
    required this.activeFieldTechnicians,
    required this.slaComplianceRate,
    required this.avgFirstResponseMinutes,
  });

  factory SummaryMetrics.fromJson(Map<String, dynamic> json) {
    return SummaryMetrics(
      totalTickets: json['totalTickets'],
      pendingAssignment: json['pendingAssignment'],
      inProgress: json['inProgress'],
      escalated: json['escalated'],
      resolvedToday: json['resolvedToday'],
      activeDealersCount: json['activeDealersCount'],
      activeFieldTechnicians: json['activeFieldTechnicians'],
      slaComplianceRate: json['slaComplianceRate'],
      avgFirstResponseMinutes: json['avgFirstResponseMinutes'],
    );
  }
}

class RegionalDistribution {
  final String regionCode;
  final String regionName;
  final int activeTickets;
  final int dealersCount;
  final int availableTechnicians;
  final double capacityUtilizationPct;
  final String status;

  RegionalDistribution({
    required this.regionCode,
    required this.regionName,
    required this.activeTickets,
    required this.dealersCount,
    required this.availableTechnicians,
    required this.capacityUtilizationPct,
    required this.status,
  });

  factory RegionalDistribution.fromJson(Map<String, dynamic> json) {
    return RegionalDistribution(
      regionCode: json['regionCode'],
      regionName: json['regionName'],
      activeTickets: json['activeTickets'],
      dealersCount: json['dealersCount'],
      availableTechnicians: json['availableTechnicians'],
      capacityUtilizationPct: json['capacityUtilizationPct'].toDouble(),
      status: json['status'],
    );
  }
}

class UrgentAttentionTicket {
  final String ticketId;
  final String ticketNumber;
  final String customerName;
  final String siteLocation;
  final String priority;
  final String status;
  final double ageInHours;
  final double? slaBreachInHours;
  final String? escalationReason;
  final List<String> issueCategory;

  UrgentAttentionTicket({
    required this.ticketId,
    required this.ticketNumber,
    required this.customerName,
    required this.siteLocation,
    required this.priority,
    required this.status,
    required this.ageInHours,
    required this.issueCategory,
    this.slaBreachInHours,
    this.escalationReason,
  });

  factory UrgentAttentionTicket.fromJson(Map<String, dynamic> json) {
    return UrgentAttentionTicket(
      ticketId: json['ticketId'],
      ticketNumber: json['ticketNumber'],
      customerName: json['customerName'],
      siteLocation: json['siteLocation'],
      priority: json['priority'],
      status: json['status'],
      ageInHours: json['ageInHours'].toDouble(),
      slaBreachInHours: json['slaBreachInHours']?.toDouble(),
      escalationReason: json['escalationReason'],
      issueCategory: List<String>.from(json['issueCategory']),
    );
  }
}
