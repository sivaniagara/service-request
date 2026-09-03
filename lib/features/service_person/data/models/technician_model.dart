class TechnicianProfile {
  final bool success;
  final Technician technician;
  final Metrics metrics;
  final List<AssignedJob> assignedJobs;

  TechnicianProfile({
    required this.success,
    required this.technician,
    required this.metrics,
    required this.assignedJobs,
  });

  factory TechnicianProfile.fromJson(Map<String, dynamic> json) {
    return TechnicianProfile(
      success: json['success'] ?? false,
      technician: Technician.fromJson(json['technician'] ?? {}),
      metrics: Metrics.fromJson(json['metrics'] ?? {}),
      assignedJobs: (json['assignedJobs'] as List? ?? [])
          .map((i) => AssignedJob.fromJson(i))
          .toList(),
    );
  }
}

class Technician {
  final String id;
  final String name;
  final String phone;
  final String email;
  final String dealerName;
  final String subDealerBranchName;
  final String availabilityStatus;
  final int experienceYears;
  final List<String> skills;

  Technician({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    required this.dealerName,
    required this.subDealerBranchName,
    required this.availabilityStatus,
    required this.experienceYears,
    required this.skills,
  });

  factory Technician.fromJson(Map<String, dynamic> json) {
    return Technician(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
      dealerName: json['dealerName'] ?? '',
      subDealerBranchName: json['subDealerBranchName'] ?? '',
      availabilityStatus: json['availabilityStatus'] ?? 'Available',
      experienceYears: json['experienceYears'] ?? 0,
      skills: List<String>.from(json['skills'] ?? []),
    );
  }
}

class Metrics {
  final int activeJobsCount;
  final int criticalJobsCount;
  final int completedJobsCount;
  final double averageRating;
  final double firstTimeFixRate;

  Metrics({
    required this.activeJobsCount,
    required this.criticalJobsCount,
    required this.completedJobsCount,
    required this.averageRating,
    required this.firstTimeFixRate,
  });

  factory Metrics.fromJson(Map<String, dynamic> json) {
    return Metrics(
      activeJobsCount: json['activeJobsCount'] ?? 0,
      criticalJobsCount: json['criticalJobsCount'] ?? 0,
      completedJobsCount: json['completedJobsCount'] ?? 0,
      averageRating: (json['averageRating'] ?? 0.0).toDouble(),
      firstTimeFixRate: (json['firstTimeFixRate'] ?? 0.0).toDouble(),
    );
  }
}

class AssignedJob {
  final String ticketId;
  final String ticketNumber;
  final String title;
  final String priority;
  final String status;
  final String techWorkState;
  final String requiredSkillMatch;
  final String customerName;
  final String siteLocation;
  final DateTime createdAt;

  AssignedJob({
    required this.ticketId,
    required this.ticketNumber,
    required this.title,
    required this.priority,
    required this.status,
    required this.techWorkState,
    required this.requiredSkillMatch,
    required this.customerName,
    required this.siteLocation,
    required this.createdAt,
  });

  factory AssignedJob.fromJson(Map<String, dynamic> json) {
    return AssignedJob(
      ticketId: json['ticketId'] ?? '',
      ticketNumber: json['ticketNumber'] ?? '',
      title: json['title'] ?? '',
      priority: json['priority'] ?? '',
      status: json['status'] ?? '',
      techWorkState: json['techWorkState'] ?? '',
      requiredSkillMatch: json['requiredSkillMatch'] ?? '',
      customerName: json['customerName'] ?? '',
      siteLocation: json['siteLocation'] ?? '',
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
    );
  }
}
