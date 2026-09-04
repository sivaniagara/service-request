import 'package:equatable/equatable.dart';

class TechnicianTicket extends Equatable {
  final String ticketId;
  final String ticketNumber;
  final String description;
  final String productName;
  final List<String> issueCategory;
  final String priority;
  final String status;
  final TicketCustomer customer;
  final String supportMode;
  final String createdAt;

  const TechnicianTicket({
    required this.ticketId,
    required this.ticketNumber,
    required this.description,
    required this.productName,
    required this.issueCategory,
    required this.priority,
    required this.status,
    required this.customer,
    required this.supportMode,
    required this.createdAt,
  });

  factory TechnicianTicket.fromJson(Map<String, dynamic> json) {
    return TechnicianTicket(
      ticketId: json['ticketId'] ?? '',
      ticketNumber: json['ticketNumber'] ?? '',
      description: json['description'] ?? '',
      productName: json['productName'] ?? '',
      issueCategory: List<String>.from(json['issueCategory'] ?? []),
      priority: json['priority'] ?? '',
      status: json['status'] ?? '',
      customer: TicketCustomer.fromJson(json['customer'] ?? {}),
      supportMode: json['supportMode'] ?? 'Site Visit',
      createdAt: json['createdAt'] ?? '',
    );
  }

  TechnicianTicket copyWith({
    String? status,
    String? supportMode,
  }) {
    return TechnicianTicket(
      ticketId: ticketId,
      ticketNumber: ticketNumber,
      description: description,
      productName: productName,
      issueCategory: issueCategory,
      priority: priority,
      status: status ?? this.status,
      customer: customer,
      supportMode: supportMode ?? this.supportMode,
      createdAt: createdAt,
    );
  }

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
        supportMode,
        createdAt,
      ];
}

class TicketCustomer extends Equatable {
  final String name;
  final String phone;
  final String siteLocation;

  const TicketCustomer({
    required this.name,
    required this.phone,
    required this.siteLocation,
  });

  factory TicketCustomer.fromJson(Map<String, dynamic> json) {
    return TicketCustomer(
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      siteLocation: json['siteLocation'] ?? '',
    );
  }

  @override
  List<Object?> get props => [name, phone, siteLocation];
}

class TechnicianTicketDetail extends Equatable {
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
  final String createdAt;
  final TicketCustomer? customer;
  final List<TicketMilestone> stepperMilestones;
  final List<TicketTimelineEvent> timelineEvents;
  final List<String> attachedPhotos;
  final List<String> requiredSkills;
  final String? equipmentModel;
  final String? equipmentSerialNo;

  const TechnicianTicketDetail({
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
    required this.requiredSkills,
    this.equipmentModel,
    this.equipmentSerialNo,
  });

  factory TechnicianTicketDetail.fromJson(Map<String, dynamic> json) {
    return TechnicianTicketDetail(
      ticketId: json['ticketId'] ?? '',
      ticketNumber: json['ticketNumber'] ?? '',
      title: json['title'] ?? json['description'],
      description: json['description'],
      issueCategory: List<String>.from(json['issueCategory'] ?? []),
      priority: json['priority'] ?? '',
      status: json['status'] ?? '',
      supportMode: json['supportMode'],
      siteLocation: json['siteLocation'] ?? '',
      preferredSlot: json['preferredSlot'],
      createdAt: json['createdAt'] ?? '',
      customer: json['customer'] != null ? TicketCustomer.fromJson(json['customer']) : null,
      stepperMilestones: (json['stepperMilestones'] as List?)
              ?.map((e) => TicketMilestone.fromJson(e))
              .toList() ??
          [],
      timelineEvents: (json['timelineEvents'] as List?)
              ?.map((e) => TicketTimelineEvent.fromJson(e))
              .toList() ??
          [],
      attachedPhotos: List<String>.from(json['attachedPhotos'] ?? []),
      requiredSkills: List<String>.from(json['requiredSkills'] ?? []),
      equipmentModel: json['equipmentModel'] ?? json['productName'],
      equipmentSerialNo: json['equipmentSerialNo'],
    );
  }

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
        requiredSkills,
        equipmentModel,
        equipmentSerialNo,
      ];
}

class TicketMilestone extends Equatable {
  final int stepOrder;
  final String key;
  final String title;
  final String description;
  final String status;
  final String? updatedAt;
  final String? updatedBy;

  const TicketMilestone({
    required this.stepOrder,
    required this.key,
    required this.title,
    required this.description,
    required this.status,
    this.updatedAt,
    this.updatedBy,
  });

  factory TicketMilestone.fromJson(Map<String, dynamic> json) {
    return TicketMilestone(
      stepOrder: json['stepOrder'] ?? 0,
      key: json['key'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      status: json['status'] ?? '',
      updatedAt: json['updatedAt'],
      updatedBy: json['updatedBy'],
    );
  }

  @override
  List<Object?> get props => [stepOrder, key, title, description, status, updatedAt, updatedBy];
}

class TicketTimelineEvent extends Equatable {
  final String id;
  final String timestamp;
  final String title;
  final String description;
  final String actor;
  final String actorRole;
  final String badgeType;

  const TicketTimelineEvent({
    required this.id,
    required this.timestamp,
    required this.title,
    required this.description,
    required this.actor,
    required this.actorRole,
    required this.badgeType,
  });

  factory TicketTimelineEvent.fromJson(Map<String, dynamic> json) {
    return TicketTimelineEvent(
      id: json['id'] ?? '',
      timestamp: json['timestamp'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      actor: json['actor'] ?? '',
      actorRole: json['actorRole'] ?? '',
      badgeType: json['badgeType'] ?? '',
    );
  }

  @override
  List<Object?> get props => [id, timestamp, title, description, actor, actorRole, badgeType];
}
