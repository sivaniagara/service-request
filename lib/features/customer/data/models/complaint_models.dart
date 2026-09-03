import 'package:equatable/equatable.dart';

class RaiseComplaintRequest extends Equatable {
  final String name;
  final String phone;
  final String? equipment;
  final String? location;
  final List<String> issueCategory;
  final String priority;
  final String description;
  final String? preferredDate;
  final String? preferredTime;
  final List<String> attachments;

  const RaiseComplaintRequest({
    required this.name,
    required this.phone,
    this.equipment,
    this.location,
    required this.issueCategory,
    this.priority = "Medium",
    required this.description,
    this.preferredDate,
    this.preferredTime,
    this.attachments = const [],
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'phone': phone,
      'equipment': equipment,
      'location': location,
      'issueCategory': issueCategory,
      'priority': priority,
      'description': description,
      'preferredDate': preferredDate,
      'preferredTime': preferredTime,
      'attachments': attachments,
    };
  }

  @override
  List<Object?> get props => [
        name,
        phone,
        equipment,
        location,
        issueCategory,
        priority,
        description,
        preferredDate,
        preferredTime,
        attachments,
      ];
}

class RaiseComplaintResponse extends Equatable {
  final String status;
  final String ticketId;
  final String ticketNumber;

  const RaiseComplaintResponse({
    required this.status,
    required this.ticketId,
    required this.ticketNumber,
  });

  factory RaiseComplaintResponse.fromJson(Map<String, dynamic> json) {
    return RaiseComplaintResponse(
      status: json['status'] ?? '',
      ticketId: json['ticketId'] ?? '',
      ticketNumber: json['ticketNumber'] ?? '',
    );
  }

  @override
  List<Object?> get props => [status, ticketId, ticketNumber];
}
