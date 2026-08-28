class AdminReportSummaryModel {
  final String status;
  final AdminReportSummaryData data;

  AdminReportSummaryModel({required this.status, required this.data});

  factory AdminReportSummaryModel.fromJson(Map<String, dynamic> json) {
    return AdminReportSummaryModel(
      status: json['status'],
      data: AdminReportSummaryData.fromJson(json['data']),
    );
  }
}

class AdminReportSummaryData {
  final ReportFilter filter;
  final KpiMetrics kpiMetrics;
  final List<TicketVolumeTrend> ticketVolumeTrends;
  final SupportModeDistribution supportModeDistribution;
  final PriorityBreakdown priorityBreakdown;

  AdminReportSummaryData({
    required this.filter,
    required this.kpiMetrics,
    required this.ticketVolumeTrends,
    required this.supportModeDistribution,
    required this.priorityBreakdown,
  });

  factory AdminReportSummaryData.fromJson(Map<String, dynamic> json) {
    return AdminReportSummaryData(
      filter: ReportFilter.fromJson(json['filter']),
      kpiMetrics: KpiMetrics.fromJson(json['kpiMetrics']),
      ticketVolumeTrends: (json['ticketVolumeTrends'] as List)
          .map((i) => TicketVolumeTrend.fromJson(i))
          .toList(),
      supportModeDistribution: SupportModeDistribution.fromJson(json['supportModeDistribution']),
      priorityBreakdown: PriorityBreakdown.fromJson(json['priorityBreakdown']),
    );
  }
}

class ReportFilter {
  final String timeframe;
  final String startDate;
  final String endDate;
  final String region;

  ReportFilter({
    required this.timeframe,
    required this.startDate,
    required this.endDate,
    required this.region,
  });

  factory ReportFilter.fromJson(Map<String, dynamic> json) {
    return ReportFilter(
      timeframe: json['timeframe'],
      startDate: json['startDate'],
      endDate: json['endDate'],
      region: json['region'],
    );
  }
}

class KpiMetrics {
  final int totalTicketsLogged;
  final int totalTicketsResolved;
  final int pendingTickets;
  final double slaComplianceRate;
  final double averageFirstResponseMinutes;
  final double averageResolutionHours;
  final double firstVisitFixRatio;
  final double overallCustomerSatisfactionScore;
  final int totalRatingsReceived;

  KpiMetrics({
    required this.totalTicketsLogged,
    required this.totalTicketsResolved,
    required this.pendingTickets,
    required this.slaComplianceRate,
    required this.averageFirstResponseMinutes,
    required this.averageResolutionHours,
    required this.firstVisitFixRatio,
    required this.overallCustomerSatisfactionScore,
    required this.totalRatingsReceived,
  });

  factory KpiMetrics.fromJson(Map<String, dynamic> json) {
    return KpiMetrics(
      totalTicketsLogged: json['totalTicketsLogged'],
      totalTicketsResolved: json['totalTicketsResolved'],
      pendingTickets: json['pendingTickets'],
      slaComplianceRate: (json['slaComplianceRate'] as num).toDouble(),
      averageFirstResponseMinutes: (json['averageFirstResponseMinutes'] as num).toDouble(),
      averageResolutionHours: (json['averageResolutionHours'] as num).toDouble(),
      firstVisitFixRatio: (json['firstVisitFixRatio'] as num).toDouble(),
      overallCustomerSatisfactionScore: (json['overallCustomerSatisfactionScore'] as num).toDouble(),
      totalRatingsReceived: json['totalRatingsReceived'],
    );
  }
}

class TicketVolumeTrend {
  final String date;
  final int logged;
  final int resolved;

  TicketVolumeTrend({required this.date, required this.logged, required this.resolved});

  factory TicketVolumeTrend.fromJson(Map<String, dynamic> json) {
    return TicketVolumeTrend(
      date: json['date'],
      logged: json['logged'],
      resolved: json['resolved'],
    );
  }
}

class SupportModeDistribution {
  final SupportModeInfo siteVisits;
  final SupportModeInfo remoteSupport;

  SupportModeDistribution({required this.siteVisits, required this.remoteSupport});

  factory SupportModeDistribution.fromJson(Map<String, dynamic> json) {
    return SupportModeDistribution(
      siteVisits: SupportModeInfo.fromJson(json['siteVisits']),
      remoteSupport: SupportModeInfo.fromJson(json['remoteSupport']),
    );
  }
}

class SupportModeInfo {
  final int count;
  final double percentage;

  SupportModeInfo({required this.count, required this.percentage});

  factory SupportModeInfo.fromJson(Map<String, dynamic> json) {
    return SupportModeInfo(
      count: json['count'],
      percentage: (json['percentage'] as num).toDouble(),
    );
  }
}

class PriorityBreakdown {
  final int critical;
  final int high;
  final int medium;
  final int low;

  PriorityBreakdown({
    required this.critical,
    required this.high,
    required this.medium,
    required this.low,
  });

  factory PriorityBreakdown.fromJson(Map<String, dynamic> json) {
    return PriorityBreakdown(
      critical: json['critical'],
      high: json['high'],
      medium: json['medium'],
      low: json['low'],
    );
  }
}

class AdminSlaComplianceModel {
  final String status;
  final AdminSlaComplianceData data;

  AdminSlaComplianceModel({required this.status, required this.data});

  factory AdminSlaComplianceModel.fromJson(Map<String, dynamic> json) {
    return AdminSlaComplianceModel(
      status: json['status'],
      data: AdminSlaComplianceData.fromJson(json['data']),
    );
  }
}

class AdminSlaComplianceData {
  final String title;
  final String timeframe;
  final int totalTickets;
  final SlaPrimaryMetric primaryMetric;
  final List<SlaBreakdownItem> breakdown;

  AdminSlaComplianceData({
    required this.title,
    required this.timeframe,
    required this.totalTickets,
    required this.primaryMetric,
    required this.breakdown,
  });

  factory AdminSlaComplianceData.fromJson(Map<String, dynamic> json) {
    return AdminSlaComplianceData(
      title: json['title'],
      timeframe: json['timeframe'],
      totalTickets: json['totalTickets'],
      primaryMetric: SlaPrimaryMetric.fromJson(json['primaryMetric']),
      breakdown: (json['breakdown'] as List)
          .map((i) => SlaBreakdownItem.fromJson(i))
          .toList(),
    );
  }
}

class SlaPrimaryMetric {
  final int value;
  final double percentage;
  final String label;

  SlaPrimaryMetric({required this.value, required this.percentage, required this.label});

  factory SlaPrimaryMetric.fromJson(Map<String, dynamic> json) {
    return SlaPrimaryMetric(
      value: json['value'],
      percentage: (json['percentage'] as num).toDouble(),
      label: json['label'],
    );
  }
}

class SlaBreakdownItem {
  final String id;
  final String label;
  final int count;
  final double percentage;
  final String colorHex;

  SlaBreakdownItem({
    required this.id,
    required this.label,
    required this.count,
    required this.percentage,
    required this.colorHex,
  });

  factory SlaBreakdownItem.fromJson(Map<String, dynamic> json) {
    return SlaBreakdownItem(
      id: json['id'],
      label: json['label'],
      count: json['count'],
      percentage: (json['percentage'] as num).toDouble(),
      colorHex: json['colorHex'],
    );
  }
}
