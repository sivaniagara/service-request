class AdminTicketModel {
  final String status;
  final Pagination? pagination;
  final List<DealerListItem> dealerList;
  final List<AdminTicket> data;

  AdminTicketModel({
    required this.status,
    this.pagination,
    required this.dealerList,
    required this.data,
  });

  factory AdminTicketModel.fromJson(Map<String, dynamic> json) {
    return AdminTicketModel(
      status: json['status'],
      pagination: json['pagination'] != null ? Pagination.fromJson(json['pagination']) : null,
      dealerList: (json['dealerList'] as List?)
              ?.map((i) => DealerListItem.fromJson(i))
              .toList() ??
          [],
      data: (json['data'] as List).map((i) => AdminTicket.fromJson(i)).toList(),
    );
  }
}

class DealerListItem {
  final String dealerId;
  final String dealerCode;
  final String name;
  final String region;
  final double rating;
  final int techniciansCount;

  DealerListItem({
    required this.dealerId,
    required this.dealerCode,
    required this.name,
    required this.region,
    required this.rating,
    required this.techniciansCount,
  });

  factory DealerListItem.fromJson(Map<String, dynamic> json) {
    return DealerListItem(
      dealerId: json['dealerId'],
      dealerCode: json['dealerCode'],
      name: json['name'],
      region: json['region'],
      rating: (json['rating'] as num).toDouble(),
      techniciansCount: json['techniciansCount'] as int,
    );
  }
}

class Pagination {
  final int totalRecords;
  final int page;
  final int perPage;
  final int totalPages;

  Pagination({
    required this.totalRecords,
    required this.page,
    required this.perPage,
    required this.totalPages,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) {
    return Pagination(
      totalRecords: json['totalRecords'],
      page: json['page'],
      perPage: json['perPage'],
      totalPages: json['totalPages'],
    );
  }
}

class AdminTicket {
  final String ticketId;
  final String ticketNumber;
  final String title;
  final String description;
  final String productName;
  final String issueCategory;
  final String priority;
  final String status;
  final String? supportMode;
  final AdminTicketCustomer customer;
  final List<AssignedDealer> assignedDealers;
  final DateTime createdAt;

  AdminTicket({
    required this.ticketId,
    required this.ticketNumber,
    required this.title,
    required this.description,
    required this.productName,
    required this.issueCategory,
    required this.priority,
    required this.status,
    this.supportMode,
    required this.customer,
    required this.assignedDealers,
    required this.createdAt,
  });

  factory AdminTicket.fromJson(Map<String, dynamic> json) {
    return AdminTicket(
      ticketId: json['ticketId'],
      ticketNumber: json['ticketNumber'],
      title: json['title'],
      description: json['description'],
      productName: json['productName'],
      issueCategory: json['issueCategory'],
      priority: json['priority'],
      status: json['status'],
      supportMode: json['supportMode'],
      customer: AdminTicketCustomer.fromJson(json['customer']),
      assignedDealers: (json['assignedDealers'] as List?)
              ?.map((i) => AssignedDealer.fromJson(i))
              .toList() ??
          [],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}

class AdminTicketCustomer {
  final String customerId;
  final String name;
  final String phone;
  final String siteLocation;

  AdminTicketCustomer({
    required this.customerId,
    required this.name,
    required this.phone,
    required this.siteLocation,
  });

  factory AdminTicketCustomer.fromJson(Map<String, dynamic> json) {
    return AdminTicketCustomer(
      customerId: json['customerId'],
      name: json['name'],
      phone: json['phone'],
      siteLocation: json['siteLocation'],
    );
  }
}

class AssignedDealer {
  final String dealerId;
  final String dealerName;
  final String region;
  final bool isPrimary;
  final List<AssignedTechnician> assignedTechnicians;

  AssignedDealer({
    required this.dealerId,
    required this.dealerName,
    required this.region,
    required this.isPrimary,
    required this.assignedTechnicians,
  });

  factory AssignedDealer.fromJson(Map<String, dynamic> json) {
    return AssignedDealer(
      dealerId: json['dealerId'],
      dealerName: json['dealerName'],
      region: json['region'],
      isPrimary: json['isPrimary'],
      assignedTechnicians: (json['assignedTechnicians'] as List?)
              ?.map((i) => AssignedTechnician.fromJson(i))
              .toList() ??
          [],
    );
  }
}

class AssignedTechnician {
  final String technicianId;
  final String name;
  final String phone;
  final String status;

  AssignedTechnician({
    required this.technicianId,
    required this.name,
    required this.phone,
    required this.status,
  });

  factory AssignedTechnician.fromJson(Map<String, dynamic> json) {
    return AssignedTechnician(
      technicianId: json['technicianId'],
      name: json['name'],
      phone: json['phone'],
      status: json['status'],
    );
  }
}
