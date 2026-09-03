import 'package:equatable/equatable.dart';

class DealerTicket extends Equatable {
  final String ticketId;
  final String ticketNumber;
  final String? description;
  final String? productName;
  final List<String> issueCategory;
  final String priority;
  final String status;
  final DealerTicketCustomer customer;
  final List<DealerTechnicianSummary> assignedTechnicians;
  final DateTime createdAt;

  const DealerTicket({
    required this.ticketId,
    required this.ticketNumber,
    this.description,
    this.productName,
    required this.issueCategory,
    required this.priority,
    required this.status,
    required this.customer,
    required this.assignedTechnicians,
    required this.createdAt,
  });

  factory DealerTicket.fromJson(Map<String, dynamic> json) {
    return DealerTicket(
      ticketId: json['ticketId'],
      ticketNumber: json['ticketNumber'],
      description: json['description'],
      productName: json['productName'],
      issueCategory: List<String>.from(json['issueCategory'] ?? []),
      priority: json['priority'] ?? '',
      status: json['status'],
      customer: DealerTicketCustomer.fromJson(json['customer']),
      assignedTechnicians: (json['assignedTechnicians'] as List?)
              ?.map((e) => DealerTechnicianSummary.fromJson(e))
              .toList() ??
          [],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  String? get firstTechName => assignedTechnicians.isNotEmpty ? assignedTechnicians.first.name : null;

  @override
  List<Object?> get props => [
        ticketId,
        ticketNumber,
        description,
        productName,
        issueCategory,
        priority,
        status,
        customer,
        assignedTechnicians,
        createdAt,
      ];
}

class DealerTicketDetail extends Equatable {
  final String ticketId;
  final String ticketNumber;
  final String? title;
  final String? description;
  final List<String> issueCategory;
  final String priority;
  final String status;
  final String? supportMode;
  final String siteLocation;
  final String? preferredSlot;
  final DateTime createdAt;
  final DealerTicketCustomer? customer;
  final List<DealerMilestone> stepperMilestones;
  final List<DealerTimelineEvent> timelineEvents;
  final List<String> attachedPhotos;
  final List<DealerTechnicianDetail> assignedTechnicians;
  final List<String> requiredSkills;

  const DealerTicketDetail({
    required this.ticketId,
    required this.ticketNumber,
    this.title,
    this.description,
    required this.issueCategory,
    required this.priority,
    required this.status,
    this.supportMode,
    required this.siteLocation,
    this.preferredSlot,
    required this.createdAt,
    this.customer,
    required this.stepperMilestones,
    required this.timelineEvents,
    required this.attachedPhotos,
    required this.assignedTechnicians,
    required this.requiredSkills,
  });

  factory DealerTicketDetail.fromJson(Map<String, dynamic> json) {
    // Extract technicians from assignedDealer if present (matching prompt JSON)
    List<DealerTechnicianDetail> techs = [];
    if (json['assignedDealer'] != null && (json['assignedDealer'] as List).isNotEmpty) {
      for (var dealerEntry in (json['assignedDealer'] as List)) {
        if (dealerEntry['assignedTechnician'] != null) {
          techs.addAll((dealerEntry['assignedTechnician'] as List)
              .map((e) => DealerTechnicianDetail.fromJson(e))
              .toList());
        }
      }
    }

    return DealerTicketDetail(
      ticketId: json['ticketId'] ?? '',
      ticketNumber: json['ticketNumber'] ?? '',
      title: json['title'],
      description: json['description'],
      issueCategory: List<String>.from(json['issueCategory'] ?? []),
      priority: json['priority'] ?? '',
      status: json['status'] ?? '',
      supportMode: json['supportMode'],
      siteLocation: json['siteLocation'] ?? '',
      preferredSlot: json['preferredSlot'],
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : DateTime.now(),
      customer: json['customer'] != null ? DealerTicketCustomer.fromJson(json['customer']) : null,
      stepperMilestones: (json['stepperMilestones'] as List?)
              ?.map((e) => DealerMilestone.fromJson(e))
              .toList() ??
          [],
      timelineEvents: (json['timelineEvents'] as List?)
              ?.map((e) => DealerTimelineEvent.fromJson(e))
              .toList() ??
          [],
      attachedPhotos: List<String>.from(json['attachedPhotos'] ?? []),
      assignedTechnicians: techs,
      requiredSkills: List<String>.from(json['requiredSkills'] ?? []),
    );
  }

  String? get displayTitle => title ?? (issueCategory.isNotEmpty ? issueCategory.first : 'Service Request');

  String? get firstTechName => assignedTechnicians.isNotEmpty ? assignedTechnicians.first.name : null;

  @override
  List<Object?> get props => [
        ticketId,
        ticketNumber,
        title,
        description,
        issueCategory,
        priority,
        status,
        supportMode,
        siteLocation,
        preferredSlot,
        createdAt,
        customer,
        stepperMilestones,
        timelineEvents,
        attachedPhotos,
        assignedTechnicians,
        requiredSkills,
      ];
}

class DealerTechnicianSummary extends Equatable {
  final String technicianId;
  final String? name;

  const DealerTechnicianSummary({
    required this.technicianId,
    this.name,
  });

  factory DealerTechnicianSummary.fromJson(Map<String, dynamic> json) {
    return DealerTechnicianSummary(
      technicianId: json['technicianId'] ?? '',
      name: json['name'],
    );
  }

  @override
  List<Object?> get props => [technicianId, name];
}

class DealerTechnicianDetail extends Equatable {
  final String technicianId;
  final String name;
  final String phone;
  final double rating;
  final int totalResolved;
  final String travelDistance;
  final String estimatedEta;

  const DealerTechnicianDetail({
    required this.technicianId,
    required this.name,
    required this.phone,
    required this.rating,
    required this.totalResolved,
    required this.travelDistance,
    required this.estimatedEta,
  });

  factory DealerTechnicianDetail.fromJson(Map<String, dynamic> json) {
    return DealerTechnicianDetail(
      technicianId: json['technicianId'] ?? '',
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      totalResolved: json['totalResolved'] ?? 0,
      travelDistance: json['travelDistance'] ?? '',
      estimatedEta: json['estimatedEta'] ?? '',
    );
  }

  @override
  List<Object?> get props => [
        technicianId,
        name,
        phone,
        rating,
        totalResolved,
        travelDistance,
        estimatedEta,
      ];
}

class DealerTimelineEvent extends Equatable {
  final String id;
  final String timestamp;
  final String title;
  final String description;
  final String actor;
  final String actorRole;
  final String badgeType;

  const DealerTimelineEvent({
    required this.id,
    required this.timestamp,
    required this.title,
    required this.description,
    required this.actor,
    required this.actorRole,
    required this.badgeType,
  });

  factory DealerTimelineEvent.fromJson(Map<String, dynamic> json) {
    return DealerTimelineEvent(
      id: json['id'],
      timestamp: json['timestamp'],
      title: json['title'],
      description: json['description'],
      actor: json['actor'],
      actorRole: json['actorRole'],
      badgeType: json['badgeType'],
    );
  }

  @override
  List<Object?> get props => [id, timestamp, title, description, actor, actorRole, badgeType];
}

class DealerMilestone extends Equatable {
  final int stepOrder;
  final String key;
  final String title;
  final String description;
  final String status;
  final String? updatedAt;
  final String? updatedBy;

  const DealerMilestone({
    required this.stepOrder,
    required this.key,
    required this.title,
    required this.description,
    required this.status,
    this.updatedAt,
    this.updatedBy,
  });

  factory DealerMilestone.fromJson(Map<String, dynamic> json) {
    return DealerMilestone(
      stepOrder: json['stepOrder'],
      key: json['key'],
      title: json['title'],
      description: json['description'],
      status: json['status'],
      updatedAt: json['updatedAt'],
      updatedBy: json['updatedBy'],
    );
  }

  @override
  List<Object?> get props => [stepOrder, key, title, description, status, updatedAt, updatedBy];
}

class DealerTicketCustomer extends Equatable {
  final String customerId;
  final String name;
  final String phone;
  final String siteLocation;

  const DealerTicketCustomer({
    required this.customerId,
    required this.name,
    required this.phone,
    required this.siteLocation,
  });

  factory DealerTicketCustomer.fromJson(Map<String, dynamic> json) {
    return DealerTicketCustomer(
      customerId: json['customerId'] ?? '',
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      siteLocation: json['siteLocation'] ?? '',
    );
  }

  @override
  List<Object?> get props => [customerId, name, phone, siteLocation];
}
