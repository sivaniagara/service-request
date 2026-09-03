class AdminTicketModel {
  final String status;
  final List<AdminDealerListItem> dealerList;
  final List<AdminTicketItem> data;

  AdminTicketModel({
    required this.status,
    required this.dealerList,
    required this.data,
  });

  factory AdminTicketModel.fromJson(Map<String, dynamic> json) {
    return AdminTicketModel(
      status: json['status'] ?? 'success',
      dealerList: (json['dealerList'] as List?)
              ?.map((i) => AdminDealerListItem.fromJson(i))
              .toList() ??
          [],
      data: (json['data'] as List?)
              ?.map((i) => AdminTicketItem.fromJson(i))
              .toList() ??
          [],
    );
  }
}

class AdminDealerListItem {
  final String dealerId;
  final String dealerCode;
  final String name;
  final String region;
  final double rating;
  final int techniciansCount;

  AdminDealerListItem({
    required this.dealerId,
    required this.dealerCode,
    required this.name,
    required this.region,
    required this.rating,
    required this.techniciansCount,
  });

  factory AdminDealerListItem.fromJson(Map<String, dynamic> json) {
    return AdminDealerListItem(
      dealerId: json['dealerId'] ?? '',
      dealerCode: json['dealerCode'] ?? '',
      name: json['name'] ?? '',
      region: json['region'] ?? '',
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      techniciansCount: json['techniciansCount'] ?? 0,
    );
  }
}

class AdminTicketItem {
  final String ticketId;
  final String ticketNumber;
  final String title;
  final String? description;
  final String? productName;
  final List<String> issueCategory;
  final String priority;
  final String status;
  final AdminCustomerInfo customer;
  final List<AdminAssignedDealerSimple> assignedDealers;
  final DateTime createdAt;

  AdminTicketItem({
    required this.ticketId,
    required this.ticketNumber,
    required this.title,
    this.description,
    this.productName,
    required this.issueCategory,
    required this.priority,
    required this.status,
    required this.customer,
    required this.assignedDealers,
    required this.createdAt,
  });

  factory AdminTicketItem.fromJson(Map<String, dynamic> json) {
    return AdminTicketItem(
      ticketId: json['ticketId'] ?? '',
      ticketNumber: json['ticketNumber'] ?? '',
      title: json['title'] ?? '',
      description: json['description'],
      productName: json['productName'],
      issueCategory: List<String>.from(json['issueCategory']),
      priority: json['priority'] ?? '',
      status: json['status'] ?? '',
      customer: AdminCustomerInfo.fromJson(json['customer'] ?? {}),
      assignedDealers: (json['assignedDealers'] as List?)
              ?.map((i) => AdminAssignedDealerSimple.fromJson(i))
              .toList() ??
          [],
      createdAt: json['createdAt'] != null 
          ? DateTime.parse(json['createdAt']) 
          : DateTime.now(),
    );
  }
}

class AdminCustomerInfo {
  final String customerId;
  final String name;
  final String phone;
  final String siteLocation;

  AdminCustomerInfo({
    required this.customerId,
    required this.name,
    required this.phone,
    required this.siteLocation,
  });

  factory AdminCustomerInfo.fromJson(Map<String, dynamic> json) {
    return AdminCustomerInfo(
      customerId: json['customerId'] ?? '',
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      siteLocation: json['siteLocation'] ?? '',
    );
  }
}

class AdminAssignedDealerSimple {
  final String dealerId;
  final String name;

  AdminAssignedDealerSimple({
    required this.dealerId,
    required this.name,
  });

  factory AdminAssignedDealerSimple.fromJson(Map<String, dynamic> json) {
    return AdminAssignedDealerSimple(
      dealerId: json['dealerId'] ?? '',
      name: json['name'] ?? '',
    );
  }
}
