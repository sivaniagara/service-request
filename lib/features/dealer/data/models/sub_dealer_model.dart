import 'package:equatable/equatable.dart';

class SubDealerManagementData extends Equatable {
  final SubDealerSummary summary;
  final List<SubDealerBranch> branches;

  const SubDealerManagementData({
    required this.summary,
    required this.branches,
  });

  factory SubDealerManagementData.fromJson(Map<String, dynamic> json) {
    return SubDealerManagementData(
      summary: SubDealerSummary.fromJson(json['summary']),
      branches: (json['branches'] as List)
          .map((e) => SubDealerBranch.fromJson(e))
          .toList(),
    );
  }

  @override
  List<Object?> get props => [summary, branches];
}

class SubDealerSummary extends Equatable {
  final int totalSubDealerBranches;
  final int activeBranchesCount;
  final int totalBranchTechnicians;
  final double avgBranchRating;

  const SubDealerSummary({
    required this.totalSubDealerBranches,
    required this.activeBranchesCount,
    required this.totalBranchTechnicians,
    required this.avgBranchRating,
  });

  factory SubDealerSummary.fromJson(Map<String, dynamic> json) {
    return SubDealerSummary(
      totalSubDealerBranches: json['totalSubDealerBranches'] ?? 0,
      activeBranchesCount: json['activeBranchesCount'] ?? 0,
      totalBranchTechnicians: json['totalBranchTechnicians'] ?? 0,
      avgBranchRating: (json['avgBranchRating'] as num?)?.toDouble() ?? 0.0,
    );
  }

  @override
  List<Object?> get props => [
        totalSubDealerBranches,
        activeBranchesCount,
        totalBranchTechnicians,
        avgBranchRating,
      ];
}

class SubDealerBranch extends Equatable {
  final String dealerId;
  final String dealerCode;
  final String branchName;
  final String location;
  final int techniciansCount;
  final String managerName;
  final String managerPhone;
  final String email;
  final String region;
  final double rating;
  final bool isActive;

  const SubDealerBranch({
    required this.dealerId,
    required this.dealerCode,
    required this.branchName,
    required this.location,
    required this.techniciansCount,
    required this.managerName,
    required this.managerPhone,
    this.email = '',
    this.region = '',
    required this.rating,
    required this.isActive,
  });

  factory SubDealerBranch.fromJson(Map<String, dynamic> json) {
    return SubDealerBranch(
      dealerId: json['dealerId'] ?? '',
      dealerCode: json['dealerCode'] ?? '',
      branchName: json['name'] ?? json['branchName'] ?? '',
      location: json['officeAddress'] ?? json['location'] ?? '',
      techniciansCount: json['techniciansCount'] ?? 0,
      managerName: json['managerName'] ?? json['name'] ?? '',
      managerPhone: json['phone'] ?? json['managerPhone'] ?? '',
      email: json['email'] ?? '',
      region: json['region'] ?? '',
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      isActive: json['isActive'] ?? false,
    );
  }

  @override
  List<Object?> get props => [
        dealerId,
        dealerCode,
        branchName,
        location,
        techniciansCount,
        managerName,
        managerPhone,
        email,
        region,
        rating,
        isActive,
      ];
}
