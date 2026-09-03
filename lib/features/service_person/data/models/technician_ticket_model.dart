import 'package:equatable/equatable.dart';

class TechnicianTicket extends Equatable {
  final String ticketId;
  final String ticketNumber;
  final String title;
  final String category;
  final String priority;
  final String status;
  final String equipmentModel;
  final String equipmentSerialNo;
  final TicketCustomer customer;
  final DelegatedSubDealer delegatedSubDealer;
  final String? scheduledTime;
  final List<TicketStepperStep> stepperSteps;
  final List<TicketTimelineEvent> timelineEvents;
  final String supportMode; // Remote or Site Visit

  const TechnicianTicket({
    required this.ticketId,
    required this.ticketNumber,
    required this.title,
    required this.category,
    required this.priority,
    required this.status,
    required this.equipmentModel,
    required this.equipmentSerialNo,
    required this.customer,
    required this.delegatedSubDealer,
    this.scheduledTime,
    required this.stepperSteps,
    required this.timelineEvents,
    this.supportMode = 'Site Visit',
  });

  factory TechnicianTicket.fromJson(Map<String, dynamic> json) {
    return TechnicianTicket(
      ticketId: json['ticketId'] ?? '',
      ticketNumber: json['ticketNumber'] ?? '',
      title: json['title'] ?? '',
      category: json['category'] ?? '',
      priority: json['priority'] ?? '',
      status: json['status'] ?? '',
      equipmentModel: json['equipmentModel'] ?? '',
      equipmentSerialNo: json['equipmentSerialNo'] ?? '',
      customer: TicketCustomer.fromJson(json['customer'] ?? {}),
      delegatedSubDealer: DelegatedSubDealer.fromJson(json['delegatedSubDealer'] ?? {}),
      scheduledTime: json['scheduledTime'],
      stepperSteps: (json['stepperSteps'] as List? ?? [])
          .map((i) => TicketStepperStep.fromJson(i))
          .toList(),
      timelineEvents: (json['timelineEvents'] as List? ?? [])
          .map((i) => TicketTimelineEvent.fromJson(i))
          .toList(),
      supportMode: json['supportMode'] ?? 'Site Visit',
    );
  }

  TechnicianTicket copyWith({
    String? status,
    String? supportMode,
  }) {
    return TechnicianTicket(
      ticketId: ticketId,
      ticketNumber: ticketNumber,
      title: title,
      category: category,
      priority: priority,
      status: status ?? this.status,
      equipmentModel: equipmentModel,
      equipmentSerialNo: equipmentSerialNo,
      customer: customer,
      delegatedSubDealer: delegatedSubDealer,
      scheduledTime: scheduledTime,
      stepperSteps: stepperSteps,
      timelineEvents: timelineEvents,
      supportMode: supportMode ?? this.supportMode,
    );
  }

  @override
  List<Object?> get props => [
        ticketId,
        ticketNumber,
        title,
        category,
        priority,
        status,
        equipmentModel,
        equipmentSerialNo,
        customer,
        delegatedSubDealer,
        scheduledTime,
        stepperSteps,
        timelineEvents,
        supportMode,
      ];
}

class TicketCustomer extends Equatable {
  final String id;
  final String name;
  final String phone;
  final String siteLocation;

  const TicketCustomer({
    required this.id,
    required this.name,
    required this.phone,
    required this.siteLocation,
  });

  factory TicketCustomer.fromJson(Map<String, dynamic> json) {
    return TicketCustomer(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      siteLocation: json['siteLocation'] ?? '',
    );
  }

  @override
  List<Object?> get props => [id, name, phone, siteLocation];
}

class DelegatedSubDealer extends Equatable {
  final String id;
  final String name;
  final String contactPerson;
  final String phone;

  const DelegatedSubDealer({
    required this.id,
    required this.name,
    required this.contactPerson,
    required this.phone,
  });

  factory DelegatedSubDealer.fromJson(Map<String, dynamic> json) {
    return DelegatedSubDealer(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      contactPerson: json['contactPerson'] ?? '',
      phone: json['phone'] ?? '',
    );
  }

  @override
  List<Object?> get props => [id, name, contactPerson, phone];
}

class TicketStepperStep extends Equatable {
  final int stepOrder;
  final String title;
  final String description;
  final String status;
  final String? updatedAt;
  final String? updatedBy;

  const TicketStepperStep({
    required this.stepOrder,
    required this.title,
    required this.description,
    required this.status,
    this.updatedAt,
    this.updatedBy,
  });

  factory TicketStepperStep.fromJson(Map<String, dynamic> json) {
    return TicketStepperStep(
      stepOrder: json['id'] ?? json['stepOrder'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      status: json['status'] ?? '',
      updatedAt: json['updatedAt'],
      updatedBy: json['updatedBy'],
    );
  }

  @override
  List<Object?> get props => [stepOrder, title, description, status, updatedAt, updatedBy];
}

class TicketTimelineEvent extends Equatable {
  final String id;
  final String timestamp;
  final String title;
  final String description;

  const TicketTimelineEvent({
    required this.id,
    required this.timestamp,
    required this.title,
    required this.description,
  });

  factory TicketTimelineEvent.fromJson(Map<String, dynamic> json) {
    return TicketTimelineEvent(
      id: json['id'] ?? '',
      timestamp: json['timestamp'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
    );
  }

  @override
  List<Object?> get props => [id, timestamp, title, description];
}
