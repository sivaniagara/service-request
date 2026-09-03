import 'package:equatable/equatable.dart';

class DealerServiceTeamModel extends Equatable {
  final DealerServiceTeamSummary summary;
  final List<DealerTechnician> technicians;

  const DealerServiceTeamModel({
    required this.summary,
    required this.technicians,
  });

  factory DealerServiceTeamModel.fromJson(Map<String, dynamic> json) {
    return DealerServiceTeamModel(
      summary: DealerServiceTeamSummary.fromJson(json['summary'] ?? {}),
      technicians: (json['technicians'] as List?)
              ?.map((e) => DealerTechnician.fromJson(e))
              .toList() ??
          [],
    );
  }

  @override
  List<Object?> get props => [summary, technicians];
}

class DealerServiceTeamSummary extends Equatable {
  final int totalServicePersons;
  final int requestsHandled;
  final int currentlyAssigned;
  final double avgTechRating;

  const DealerServiceTeamSummary({
    required this.totalServicePersons,
    required this.requestsHandled,
    required this.currentlyAssigned,
    required this.avgTechRating,
  });

  factory DealerServiceTeamSummary.fromJson(Map<String, dynamic> json) {
    return DealerServiceTeamSummary(
      totalServicePersons: json['totalServicePersons'] ?? 0,
      requestsHandled: json['requestsHandled'] ?? 0,
      currentlyAssigned: json['currentlyAssigned'] ?? 0,
      avgTechRating: (json['avgTechRating'] as num?)?.toDouble() ?? 0.0,
    );
  }

  @override
  List<Object?> get props => [totalServicePersons, requestsHandled, currentlyAssigned, avgTechRating];
}

class DealerTechnician extends Equatable {
  final String technicianId;
  final String name;
  final String phone;
  final String email;
  final String availabilityStatus;
  final int currentlyAssignedCount;
  final int totalResolved;
  final double rating;
  final List<String> skills;
  final String? travelDistance;
  final String? estimatedEta;

  const DealerTechnician({
    required this.technicianId,
    required this.name,
    required this.phone,
    required this.email,
    required this.availabilityStatus,
    required this.currentlyAssignedCount,
    required this.totalResolved,
    required this.rating,
    this.skills = const [],
    this.travelDistance,
    this.estimatedEta,
  });

  factory DealerTechnician.fromJson(Map<String, dynamic> json) {
    return DealerTechnician(
      technicianId: json['technicianId'] ?? '',
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
      availabilityStatus: json['availabilityStatus'] ?? '',
      currentlyAssignedCount: json['currentlyAssignedCount'] ?? 0,
      totalResolved: json['totalResolved'] ?? 0,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      skills: json['skills'] != null ? List<String>.from(json['skills']) : const [],
      travelDistance: json['travelDistance'],
      estimatedEta: json['estimatedEta'],
    );
  }

  @override
  List<Object?> get props => [
        technicianId,
        name,
        phone,
        email,
        availabilityStatus,
        currentlyAssignedCount,
        totalResolved,
        rating,
        skills,
        travelDistance,
        estimatedEta,
      ];
}
