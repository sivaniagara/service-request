import 'package:equatable/equatable.dart';
import 'dealer_technician_model.dart';

class DealerDashboardData extends Equatable {
  final DealerProfile profile;
  final DealerMetrics metrics;
  final List<UrgentTicket> urgentActionQueue;
  final TechnicianSummary technicianSummary;
  final List<DealerTechnician> technicians;

  const DealerDashboardData({
    required this.profile,
    required this.metrics,
    required this.urgentActionQueue,
    required this.technicianSummary,
    required this.technicians,
  });

  factory DealerDashboardData.fromJson(Map<String, dynamic> json) {
    return DealerDashboardData(
      profile: DealerProfile.fromJson(json['dealerProfile']),
      metrics: DealerMetrics.fromJson(json['metrics']),
      urgentActionQueue: (json['urgentActionQueue'] as List)
          .map((e) => UrgentTicket.fromJson(e))
          .toList(),
      technicianSummary: TechnicianSummary.fromJson(json['technicianSummary']),
      technicians: (json['technicians'] as List)
          .map((e) => DealerTechnician.fromJson(e))
          .toList(),
    );
  }

  @override
  List<Object?> get props => [profile, metrics, urgentActionQueue, technicianSummary, technicians];
}

class DealerProfile extends Equatable {
  final String dealerId;
  final String name;
  final String region;
  final String phone;
  final double rating;

  const DealerProfile({
    required this.dealerId,
    required this.name,
    required this.region,
    required this.phone,
    required this.rating,
  });

  factory DealerProfile.fromJson(Map<String, dynamic> json) {
    return DealerProfile(
      dealerId: json['dealerId'],
      name: json['name'],
      region: json['region'],
      phone: json['phone'],
      rating: (json['rating'] as num).toDouble(),
    );
  }

  @override
  List<Object?> get props => [dealerId, name, region, phone, rating];
}

class DealerMetrics extends Equatable {
  final int totalActiveTickets;
  final int pendingTechnicianAssignment;
  final int inProgressTickets;
  final int resolvedToday;
  final int maxCapacity;
  final double capacityUtilizationPct;
  final int availableTechniciansCount;
  final int totalTechniciansCount;

  const DealerMetrics({
    required this.totalActiveTickets,
    required this.pendingTechnicianAssignment,
    required this.inProgressTickets,
    required this.resolvedToday,
    required this.maxCapacity,
    required this.capacityUtilizationPct,
    required this.availableTechniciansCount,
    required this.totalTechniciansCount,
  });

  factory DealerMetrics.fromJson(Map<String, dynamic> json) {
    return DealerMetrics(
      totalActiveTickets: json['totalActiveTickets'],
      pendingTechnicianAssignment: json['pendingTechnicianAssignment'],
      inProgressTickets: json['inProgressTickets'],
      resolvedToday: json['resolvedToday'],
      maxCapacity: json['maxCapacity'],
      capacityUtilizationPct: (json['capacityUtilizationPct'] as num).toDouble(),
      availableTechniciansCount: json['availableTechniciansCount'],
      totalTechniciansCount: json['totalTechniciansCount'],
    );
  }

  @override
  List<Object?> get props => [
        totalActiveTickets,
        pendingTechnicianAssignment,
        inProgressTickets,
        resolvedToday,
        maxCapacity,
        capacityUtilizationPct,
        availableTechniciansCount,
        totalTechniciansCount,
      ];
}

class UrgentTicket extends Equatable {
  final String ticketId;
  final String ticketNumber;
  final List<String> issueCategory;
  final String priority;
  final String status;
  final String customerName;
  final String siteLocation;
  final DateTime createdAt;
  final String actionRequired;

  const UrgentTicket({
    required this.ticketId,
    required this.ticketNumber,
    required this.issueCategory,
    required this.priority,
    required this.status,
    required this.customerName,
    required this.siteLocation,
    required this.createdAt,
    required this.actionRequired,
  });

  factory UrgentTicket.fromJson(Map<String, dynamic> json) {
    return UrgentTicket(
      ticketId: json['ticketId'],
      ticketNumber: json['ticketNumber'],
      issueCategory: List<String>.from(json['issueCategory']),
      priority: json['priority'],
      status: json['status'],
      customerName: json['customerName'],
      siteLocation: json['siteLocation'],
      createdAt: DateTime.parse(json['createdAt']),
      actionRequired: json['actionRequired'],
    );
  }

  @override
  List<Object?> get props => [
        ticketId,
        ticketNumber,
        issueCategory,
        priority,
        status,
        customerName,
        siteLocation,
        createdAt,
        actionRequired,
      ];
}

class TechnicianSummary extends Equatable {
  final int available;
  final int onJob;
  final int offline;

  const TechnicianSummary({
    required this.available,
    required this.onJob,
    required this.offline,
  });

  factory TechnicianSummary.fromJson(Map<String, dynamic> json) {
    return TechnicianSummary(
      available: json['available'],
      onJob: json['onJob'],
      offline: json['offline'],
    );
  }

  @override
  List<Object?> get props => [available, onJob, offline];
}
