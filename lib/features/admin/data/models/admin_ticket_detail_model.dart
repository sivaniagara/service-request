class AdminTicketDetailModel {
  final String status;
  final AdminTicketDetailData data;

  AdminTicketDetailModel({
    required this.status,
    required this.data,
  });

  factory AdminTicketDetailModel.fromJson(Map<String, dynamic> json) {
    return AdminTicketDetailModel(
      status: json['status'],
      data: AdminTicketDetailData.fromJson(json['data']),
    );
  }
}

class AdminTicketDetailData {
  final String ticketId;
  final String ticketNumber;
  final String title;
  final String description;
  final String issueCategory;
  final String priority;
  final String status;
  final String? supportMode;
  final String siteLocation;
  final String? preferredSlot;
  final DateTime createdAt;
  final AdminTicketCustomerDetail customer;
  final List<AssignedDealerDetail> assignedDealer;
  final List<StepperMilestone> stepperMilestones;
  final List<TimelineEvent> timelineEvents;
  final List<String> attachedPhotos;

  AdminTicketDetailData({
    required this.ticketId,
    required this.ticketNumber,
    required this.title,
    required this.description,
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
      ticketId: json['ticketId'],
      ticketNumber: json['ticketNumber'],
      title: json['title'],
      description: json['description'],
      issueCategory: json['issueCategory'],
      priority: json['priority'],
      status: json['status'],
      supportMode: json['supportMode'],
      siteLocation: json['siteLocation'],
      preferredSlot: json['preferredSlot'],
      createdAt: DateTime.parse(json['createdAt']),
      customer: json['customer'] != null 
          ? AdminTicketCustomerDetail.fromJson(json['customer'])
          : AdminTicketCustomerDetail(
              customerId: '',
              name: '',
              phone: '',
              siteLocation: json['siteLocation'] ?? '',
            ),
      assignedDealer: (json['assignedDealer'] as List?)
              ?.map((i) => AssignedDealerDetail.fromJson(i))
              .toList() ??
          [],
      stepperMilestones: (json['stepperMilestones'] as List?)
              ?.map((i) => StepperMilestone.fromJson(i))
              .toList() ??
          [],
      timelineEvents: (json['timelineEvents'] as List?)
              ?.map((i) => TimelineEvent.fromJson(i))
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
      customerId: json['customerId'],
      name: json['name'],
      phone: json['phone'],
      siteLocation: json['siteLocation'],
    );
  }
}

class AssignedDealerDetail {
  final String dealerId;
  final String name;
  final String phone;
  final String email;
  final String region;
  final List<AssignedTechnicianDetail> assignedTechnician;

  AssignedDealerDetail({
    required this.dealerId,
    required this.name,
    required this.phone,
    required this.email,
    required this.region,
    required this.assignedTechnician,
  });

  factory AssignedDealerDetail.fromJson(Map<String, dynamic> json) {
    return AssignedDealerDetail(
      dealerId: json['dealerId'],
      name: json['name'],
      phone: json['phone'],
      email: json['email'],
      region: json['region'],
      assignedTechnician: (json['assignedTechnician'] as List?)
              ?.map((i) => AssignedTechnicianDetail.fromJson(i))
              .toList() ??
          [],
    );
  }
}

class AssignedTechnicianDetail {
  final String technicianId;
  final String name;
  final String phone;
  final double rating;
  final int totalResolved;
  final String travelDistance;
  final String estimatedEta;

  AssignedTechnicianDetail({
    required this.technicianId,
    required this.name,
    required this.phone,
    required this.rating,
    required this.totalResolved,
    required this.travelDistance,
    required this.estimatedEta,
  });

  factory AssignedTechnicianDetail.fromJson(Map<String, dynamic> json) {
    return AssignedTechnicianDetail(
      technicianId: json['technicianId'],
      name: json['name'],
      phone: json['phone'],
      rating: (json['rating'] as num).toDouble(),
      totalResolved: json['totalResolved'] as int,
      travelDistance: json['travelDistance'],
      estimatedEta: json['estimatedEta'],
    );
  }
}

class StepperMilestone {
  final int stepOrder;
  final String key;
  final String title;
  final String description;
  final String status;
  final String? updatedAt;
  final String? updatedBy;

  StepperMilestone({
    required this.stepOrder,
    required this.key,
    required this.title,
    required this.description,
    required this.status,
    this.updatedAt,
    this.updatedBy,
  });

  factory StepperMilestone.fromJson(Map<String, dynamic> json) {
    return StepperMilestone(
      stepOrder: json['stepOrder'],
      key: json['key'],
      title: json['title'],
      description: json['description'],
      status: json['status'],
      updatedAt: json['updatedAt'],
      updatedBy: json['updatedBy'],
    );
  }
}

class TimelineEvent {
  final String id;
  final String timestamp;
  final String title;
  final String description;
  final String actor;
  final String actorRole;
  final String badgeType;

  TimelineEvent({
    required this.id,
    required this.timestamp,
    required this.title,
    required this.description,
    required this.actor,
    required this.actorRole,
    required this.badgeType,
  });

  factory TimelineEvent.fromJson(Map<String, dynamic> json) {
    return TimelineEvent(
      id: json['id'],
      timestamp: json['timestamp'],
      title: json['title'],
      description: json['description'],
      actor: json['actor'],
      actorRole: json['actorRole'],
      badgeType: json['badgeType'],
    );
  }
}
