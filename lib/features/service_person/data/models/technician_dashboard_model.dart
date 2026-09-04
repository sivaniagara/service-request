import 'package:equatable/equatable.dart';

class TechnicianDashboardData extends Equatable {
  final TechnicianProfile profile;
  final TechnicianStats stats;
  final List<ActiveWorkOrder> activeWorkOrders;
  final List<String> skills;

  const TechnicianDashboardData({
    required this.profile,
    required this.stats,
    required this.activeWorkOrders,
    required this.skills,
  });

  factory TechnicianDashboardData.fromJson(Map<String, dynamic> json) {
    return TechnicianDashboardData(
      profile: TechnicianProfile.fromJson(json['profile']),
      stats: TechnicianStats.fromJson(json['stats']),
      activeWorkOrders: (json['activeWorkOrders'] as List?)
              ?.map((e) => ActiveWorkOrder.fromJson(e))
              .toList() ??
          [],
      skills: (json['skills'] as List?)?.map((e) => e.toString()).toList() ?? [],
    );
  }

  @override
  List<Object?> get props => [profile, stats, activeWorkOrders, skills];
}

class TechnicianProfile extends Equatable {
  final String technicianId;
  final String name;
  final String role;
  final String dealerName;
  final String phone;
  final String email;
  final String availabilityStatus;

  const TechnicianProfile({
    required this.technicianId,
    required this.name,
    required this.role,
    required this.dealerName,
    required this.phone,
    required this.email,
    required this.availabilityStatus,
  });

  factory TechnicianProfile.fromJson(Map<String, dynamic> json) {
    return TechnicianProfile(
      technicianId: json['technicianId'] ?? '',
      name: json['name'] ?? '',
      role: json['role'] ?? 'Field Technician',
      dealerName: json['dealerName'] ?? '',
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
      availabilityStatus: json['availabilityStatus'] ?? '',
    );
  }

  @override
  List<Object?> get props =>
      [technicianId, name, role, dealerName, phone, email, availabilityStatus];
}

class TechnicianStats extends Equatable {
  final int activeAssignments;
  final int highPriorityCount;
  final int resolvedOverall;
  final String onTimeResolutionRate;
  final double customerRating;
  final double firstTimeFixRate;
  final int repeatComplaints;

  const TechnicianStats({
    required this.activeAssignments,
    required this.highPriorityCount,
    required this.resolvedOverall,
    required this.onTimeResolutionRate,
    required this.customerRating,
    required this.firstTimeFixRate,
    required this.repeatComplaints,
  });

  factory TechnicianStats.fromJson(Map<String, dynamic> json) {
    return TechnicianStats(
      activeAssignments: json['activeAssignments'] ?? 0,
      highPriorityCount: json['highPriorityCount'] ?? 0,
      resolvedOverall: json['resolvedOverall'] ?? 0,
      onTimeResolutionRate: json['onTimeResolutionRate'] ?? '0%',
      customerRating: (json['customerRating'] as num?)?.toDouble() ?? 0.0,
      firstTimeFixRate: (json['firstTimeFixRate'] as num?)?.toDouble() ?? 0.0,
      repeatComplaints: json['repeatComplaints'] ?? 0,
    );
  }

  @override
  List<Object?> get props => [
        activeAssignments,
        highPriorityCount,
        resolvedOverall,
        onTimeResolutionRate,
        customerRating,
        firstTimeFixRate,
        repeatComplaints
      ];
}

class ActiveWorkOrder extends Equatable {
  final String ticketId;
  final String ticketNumber;
  final String title;
  final String category;
  final String priority;
  final String status;
  final String equipmentModel;
  final WorkOrderCustomer customer;
  final String supportMode;
  final String createdAt;

  const ActiveWorkOrder({
    required this.ticketId,
    required this.ticketNumber,
    required this.title,
    required this.category,
    required this.priority,
    required this.status,
    required this.equipmentModel,
    required this.customer,
    required this.supportMode,
    required this.createdAt,
  });

  factory ActiveWorkOrder.fromJson(Map<String, dynamic> json) {
    return ActiveWorkOrder(
      ticketId: json['ticketId'] ?? '',
      ticketNumber: json['ticketNumber'] ?? '',
      title: json['title'] ?? '',
      category: json['category'] ?? '',
      priority: json['priority'] ?? '',
      status: json['status'] ?? '',
      equipmentModel: json['equipmentModel'] ?? '',
      customer: WorkOrderCustomer.fromJson(json['customer'] ?? {}),
      supportMode: json['supportMode'] ?? 'Site Visit',
      createdAt: json['createdAt'] ?? '',
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
        customer,
        supportMode,
        createdAt
      ];
}

class WorkOrderCustomer extends Equatable {
  final String name;
  final String phone;
  final String siteLocation;

  const WorkOrderCustomer({
    required this.name,
    required this.phone,
    required this.siteLocation,
  });

  factory WorkOrderCustomer.fromJson(Map<String, dynamic> json) {
    return WorkOrderCustomer(
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      siteLocation: json['siteLocation'] ?? '',
    );
  }

  @override
  List<Object?> get props => [name, phone, siteLocation];
}
