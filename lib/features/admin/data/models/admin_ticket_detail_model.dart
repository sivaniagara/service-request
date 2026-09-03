class AdminTicketDetailModel {
  final String status;
  final AdminTicketDetailData data;

  AdminTicketDetailModel({
    required this.status,
    required this.data,
  });

  factory AdminTicketDetailModel.fromJson(Map<String, dynamic> json) {
    return AdminTicketDetailModel(
      status: json['status'] ?? 'success',
      data: AdminTicketDetailData.fromJson(json['data'] ?? {}),
    );
  }
}

class AdminTicketDetailData {
  final String ticketId;
  final String ticketNumber;
  final String title;
  final String? description;
  final List<String> issueCategory;
  final String priority;
  final String status;
  final String? supportMode;
  final String siteLocation;
  final String? preferredSlot;
  final DateTime createdAt;
  final AdminTicketCustomerDetail customer;
  final List<AdminAssignedDealerDetail> assignedDealer;
  final List<AdminStepperMilestone> stepperMilestones;
  final List<AdminTimelineEvent> timelineEvents;
  final List<String> attachedPhotos;

  AdminTicketDetailData({
    required this.ticketId,
    required this.ticketNumber,
    required this.title,
    this.description,
    required this.issueCategory,
    required this.priority,
    required this.status,
    this.supportMode,
    required this.siteLocation,
    this.preferredSlot,
    required this.createdAt,
    required this.customer,
    required this.assignedDealer,
    required this.stepperMilestones,
    required this.timelineEvents,
    required this.attachedPhotos,
  });

  factory AdminTicketDetailData.fromJson(Map<String, dynamic> json) {
    return AdminTicketDetailData(
      ticketId: json['ticketId'] ?? '',
      ticketNumber: json['ticketNumber'] ?? '',
      title: json['title'] ?? '',
      description: json['description'],
      issueCategory: List<String>.from(json['issueCategory'] ?? []),
      priority: json['priority'] ?? '',
      status: json['status'] ?? '',
      supportMode: json['supportMode'],
      siteLocation: json['siteLocation'] ?? '',
      preferredSlot: json['preferredSlot'],
      createdAt: json['createdAt'] != null 
          ? DateTime.parse(json['createdAt']) 
          : DateTime.now(),
      customer: json['customer'] != null 
          ? AdminTicketCustomerDetail.fromJson(json['customer'])
          : AdminTicketCustomerDetail(
              customerId: '',
              name: '',
              phone: '',
              siteLocation: json['siteLocation'] ?? '',
            ),
      assignedDealer: (json['assignedDealer'] as List?)
              ?.map((i) => AdminAssignedDealerDetail.fromJson(i))
              .toList() ??
          [],
      stepperMilestones: (json['stepperMilestones'] as List?)
              ?.map((i) => AdminStepperMilestone.fromJson(i))
              .toList() ??
          [],
      timelineEvents: (json['timelineEvents'] as List?)
              ?.map((i) => AdminTimelineEvent.fromJson(i))
              .toList() ??
          [],
      attachedPhotos: List<String>.from(json['attachedPhotos'] ?? []),
    );
  }
}

class AdminTicketCustomerDetail {
  final String customerId;
  final String name;
  final String phone;
  final String siteLocation;

  AdminTicketCustomerDetail({
    required this.customerId,
    required this.name,
    required this.phone,
    required this.siteLocation,
  });

  factory AdminTicketCustomerDetail.fromJson(Map<String, dynamic> json) {
    return AdminTicketCustomerDetail(
      customerId: json['customerId'] ?? '',
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      siteLocation: json['siteLocation'] ?? '',
    );
  }
}

class AdminAssignedDealerDetail {
  final String dealerId;
  final String name;
  final String phone;
  final String? email;
  final String? region;
  final List<AdminAssignedTechnicianDetail> assignedTechnician;

  AdminAssignedDealerDetail({
    required this.dealerId,
    required this.name,
    required this.phone,
    this.email,
    this.region,
    required this.assignedTechnician,
  });

  factory AdminAssignedDealerDetail.fromJson(Map<String, dynamic> json) {
    return AdminAssignedDealerDetail(
      dealerId: json['dealerId'] ?? '',
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      email: json['email'],
      region: json['region'],
      assignedTechnician: (json['assignedTechnician'] as List?)
              ?.map((i) => AdminAssignedTechnicianDetail.fromJson(i))
              .toList() ??
          [],
    );
  }
}

class AdminAssignedTechnicianDetail {
  final String technicianId;
  final String name;
  final String phone;
  final double rating;
  final int totalResolved;
  final String travelDistance;
  final String estimatedEta;
  final String? status;

  AdminAssignedTechnicianDetail({
    required this.technicianId,
    required this.name,
    required this.phone,
    required this.rating,
    required this.totalResolved,
    required this.travelDistance,
    required this.estimatedEta,
    this.status,
  });

  factory AdminAssignedTechnicianDetail.fromJson(Map<String, dynamic> json) {
    return AdminAssignedTechnicianDetail(
      technicianId: json['technicianId'] ?? '',
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      rating: (json['rating'] as num?)?.toDouble() ?? 4.8,
      totalResolved: json['totalResolved'] ?? 0,
      travelDistance: json['travelDistance'] ?? '4.2 km',
      estimatedEta: json['estimatedEta'] ?? '12 mins',
      status: json['status'] ?? 'On job',
    );
  }
}

class AdminStepperMilestone {
  final int stepOrder;
  final String key;
  final String title;
  final String? description;
  final String status;
  final String? updatedAt;
  final String? updatedBy;

  AdminStepperMilestone({
    required this.stepOrder,
    required this.key,
    required this.title,
    this.description,
    required this.status,
    this.updatedAt,
    this.updatedBy,
  });

  factory AdminStepperMilestone.fromJson(Map<String, dynamic> json) {
    return AdminStepperMilestone(
      stepOrder: json['stepOrder'] ?? 0,
      key: json['key'] ?? '',
      title: json['title'] ?? '',
      description: json['description'],
      status: json['status'] ?? 'pending',
      updatedAt: json['updatedAt'],
      updatedBy: json['updatedBy'],
    );
  }
}

class AdminTimelineEvent {
  final String id;
  final String timestamp;
  final String title;
  final String description;
  final String actor;
  final String actorRole;
  final String badgeType;

  AdminTimelineEvent({
    required this.id,
    required this.timestamp,
    required this.title,
    required this.description,
    required this.actor,
    required this.actorRole,
    required this.badgeType,
  });

  factory AdminTimelineEvent.fromJson(Map<String, dynamic> json) {
    return AdminTimelineEvent(
      id: json['id'] ?? '',
      timestamp: json['timestamp'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      actor: json['actor'] ?? '',
      actorRole: json['actorRole'] ?? '',
      badgeType: json['badgeType'] ?? '',
    );
  }
}
