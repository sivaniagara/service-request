class AdminDealerModel {
  final String status;
  final DealerPagination? pagination;
  final DealerSummary summary;
  final List<DealerData> data;

  AdminDealerModel({
    required this.status,
    this.pagination,
    required this.summary,
    required this.data,
  });

  factory AdminDealerModel.fromJson(Map<String, dynamic> json) {
    return AdminDealerModel(
      status: json['status'],
      pagination: json['pagination'] != null ? DealerPagination.fromJson(json['pagination']) : null,
      summary: DealerSummary.fromJson(json['summary']),
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
  final String region;
  final List<String> territoryZones;
  final String officeAddress;
  final ContactPerson contactPerson;
  final DealerCapacity capacity;
  final int techniciansCount;
  final DealerPerformance performance;
  final bool isActive;
  final DateTime onboardedDate;

  DealerData({
    required this.dealerId,
    required this.dealerCode,
    required this.name,
    required this.region,
    required this.territoryZones,
    required this.officeAddress,
    required this.contactPerson,
    required this.capacity,
    required this.techniciansCount,
    required this.performance,
    required this.isActive,
    required this.onboardedDate,
  });

  factory DealerData.fromJson(Map<String, dynamic> json) {
    return DealerData(
      dealerId: json['dealerId'],
      dealerCode: json['dealerCode'],
      name: json['name'],
      region: json['region'],
      territoryZones: List<String>.from(json['territoryZones']),
      officeAddress: json['officeAddress'],
      contactPerson: ContactPerson.fromJson(json['contactPerson']),
      capacity: DealerCapacity.fromJson(json['capacity']),
      techniciansCount: json['techniciansCount'],
      performance: DealerPerformance.fromJson(json['performance']),
      isActive: json['isActive'],
      onboardedDate: DateTime.parse(json['onboardedDate']),
    );
  }
}

class ContactPerson {
  final String userId;
  final String name;
  final String designation;
  final String email;
  final String phone;

  ContactPerson({
    required this.userId,
    required this.name,
    required this.designation,
    required this.email,
    required this.phone,
  });

  factory ContactPerson.fromJson(Map<String, dynamic> json) {
    return ContactPerson(
      userId: json['userId'],
      name: json['name'],
      designation: json['designation'],
      email: json['email'],
      phone: json['phone'],
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
      utilizationPercentage: json['utilizationPercentage'].toDouble(),
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
      rating: json['rating'].toDouble(),
      totalTicketsResolved: json['totalTicketsResolved'],
      slaComplianceRate: json['slaComplianceRate'],
      avgResolutionHours: json['avgResolutionHours'].toDouble(),
    );
  }
}
