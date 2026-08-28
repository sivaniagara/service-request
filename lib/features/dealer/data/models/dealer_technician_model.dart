import 'package:equatable/equatable.dart';

class DealerTechnician extends Equatable {
  final String technicianId;
  final String techCode;
  final String name;
  final String phone;
  final String email;
  final String availabilityStatus;
  final int currentlyAssignedCount;
  final int totalResolved;
  final double rating;
  final List<String> skills;
  final bool isSkillsMatch;

  const DealerTechnician({
    required this.technicianId,
    required this.techCode,
    required this.name,
    required this.phone,
    required this.email,
    required this.availabilityStatus,
    required this.currentlyAssignedCount,
    required this.totalResolved,
    required this.rating,
    required this.skills,
    this.isSkillsMatch = false,
  });

  factory DealerTechnician.fromJson(Map<String, dynamic> json) {
    return DealerTechnician(
      technicianId: json['technicianId'] ?? '',
      techCode: json['techCode'] ?? '',
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
      availabilityStatus: json['availabilityStatus'] ?? '',
      currentlyAssignedCount: json['currentlyAssignedCount'] ?? 0,
      totalResolved: json['totalResolved'] ?? 0,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      skills: List<String>.from(json['skills'] ?? []),
      isSkillsMatch: json['isSkillsMatch'] ?? false,
    );
  }

  @override
  List<Object?> get props => [
        technicianId,
        techCode,
        name,
        phone,
        email,
        availabilityStatus,
        currentlyAssignedCount,
        totalResolved,
        rating,
        skills,
        isSkillsMatch,
      ];
}
