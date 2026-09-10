class AdminDealerModel {
  final String status;
  final DealerPagination? pagination;
  final DealerSummary? summary;
  final List<DealerData> data;

  AdminDealerModel({
    required this.status,
    this.pagination,
    this.summary,
    required this.data,
  });

  factory AdminDealerModel.fromJson(Map<String, dynamic> json) {
    return AdminDealerModel(
      status: json['status'],
      pagination: json['pagination'] != null ? DealerPagination.fromJson(json['pagination']) : null,
      summary: json['summary'] != null ? DealerSummary.fromJson(json['summary']) : null,
      data: (json['data'] as List).map((i) => DealerData.fromJson(i)).toList(),
    );
  }
}

class DealerPagination {
  final int totalRecords;
  final int page;
  final int perPage;
  final int totalPages;

  DealerPagination({
    required this.totalRecords,
    required this.page,
    required this.perPage,
    required this.totalPages,
  });

  factory DealerPagination.fromJson(Map<String, dynamic> json) {
    return DealerPagination(
      totalRecords: json['totalRecords'],
      page: json['page'],
      perPage: json['perPage'],
      totalPages: json['totalPages'],
    );
  }
}

class DealerSummary {
  final int totalDealers;
  final int activeDealers;
  final int totalTechnicians;
  final double avgDealerRating;

  DealerSummary({
    required this.totalDealers,
    required this.activeDealers,
    required this.totalTechnicians,
    required this.avgDealerRating,
  });

  factory DealerSummary.fromJson(Map<String, dynamic> json) {
    return DealerSummary(
      totalDealers: json['totalDealers'],
      activeDealers: json['activeDealers'],
      totalTechnicians: json['totalTechnicians'],
      avgDealerRating: json['avgDealerRating'].toDouble(),
    );
  }
}

class DealerData {
  final String dealerId;
  final String dealerCode;
  final String name;
  final String phone;
  final String region;
  final List<dynamic> territoryZones;
  final String officeAddress;
  final DealerCapacity capacity;
  final DealerPerformance performance;
  final bool isActive;

  DealerData({
    required this.dealerId,
    required this.dealerCode,
    required this.name,
    required this.phone,
    required this.region,
    required this.territoryZones,
    required this.officeAddress,
    required this.capacity,
    required this.performance,
    required this.isActive,
  });

  factory DealerData.fromJson(Map<String, dynamic> json) {
    return DealerData(
      dealerId: json['dealerId'],
      dealerCode: json['dealerCode'],
      name: json['name'],
      phone: json['phone'] ?? '',
      region: json['region'],
      territoryZones: json['territoryZones'] ?? [],
      officeAddress: json['officeAddress'],
      capacity: DealerCapacity.fromJson(json['capacity']),
      performance: DealerPerformance.fromJson(json['performance']),
      isActive: json['isActive'],
    );
  }
}

class DealerCapacity {
  final int maxConcurrentTickets;
  final int activeAssignedTickets;
  final double utilizationPercentage;
  final String capacityStatus;

  DealerCapacity({
    required this.maxConcurrentTickets,
    required this.activeAssignedTickets,
    required this.utilizationPercentage,
    required this.capacityStatus,
  });

  factory DealerCapacity.fromJson(Map<String, dynamic> json) {
    return DealerCapacity(
      maxConcurrentTickets: json['maxConcurrentTickets'],
      activeAssignedTickets: json['activeAssignedTickets'],
      utilizationPercentage: (json['utilizationPercentage'] as num).toDouble(),
      capacityStatus: json['capacityStatus'],
    );
  }
}

class DealerPerformance {
  final double rating;
  final int totalTicketsResolved;
  final String slaComplianceRate;
  final double avgResolutionHours;

  DealerPerformance({
    required this.rating,
    required this.totalTicketsResolved,
    required this.slaComplianceRate,
    required this.avgResolutionHours,
  });

  factory DealerPerformance.fromJson(Map<String, dynamic> json) {
    return DealerPerformance(
      rating: (json['rating'] as num).toDouble(),
      totalTicketsResolved: json['totalTicketsResolved'],
      slaComplianceRate: json['slaComplianceRate'],
      avgResolutionHours: (json['avgResolutionHours'] as num).toDouble(),
    );
  }
}
