import 'package:equatable/equatable.dart';

class TechnicianReportData extends Equatable {
  final TechnicianSummary technician;
  final String timeRange;
  final ReportPeriod period;
  final ReportKPIs kpis;
  final IncentivesAndEarnings incentives;

  const TechnicianReportData({
    required this.technician,
    required this.timeRange,
    required this.period,
    required this.kpis,
    required this.incentives,
  });

  factory TechnicianReportData.fromJson(Map<String, dynamic> json) {
    return TechnicianReportData(
      technician: TechnicianSummary.fromJson(json['technician'] ?? {}),
      timeRange: json['timeRange'] ?? '',
      period: ReportPeriod.fromJson(json['period'] ?? {}),
      kpis: ReportKPIs.fromJson(json['kpis'] ?? {}),
      incentives: IncentivesAndEarnings.fromJson(json['incentivesAndEarnings'] ?? {}),
    );
  }

  @override
  List<Object?> get props => [technician, timeRange, period, kpis, incentives];
}

class TechnicianSummary extends Equatable {
  final String id;
  final String name;
  final String dealerName;
  final String subDealerBranchName;

  const TechnicianSummary({
    required this.id,
    required this.name,
    required this.dealerName,
    required this.subDealerBranchName,
  });

  factory TechnicianSummary.fromJson(Map<String, dynamic> json) {
    return TechnicianSummary(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      dealerName: json['dealerName'] ?? '',
      subDealerBranchName: json['subDealerBranchName'] ?? '',
    );
  }

  @override
  List<Object?> get props => [id, name, dealerName, subDealerBranchName];
}

class ReportPeriod extends Equatable {
  final String startDate;
  final String endDate;

  const ReportPeriod({required this.startDate, required this.endDate});

  factory ReportPeriod.fromJson(Map<String, dynamic> json) {
    return ReportPeriod(
      startDate: json['startDate'] ?? '',
      endDate: json['endDate'] ?? '',
    );
  }

  @override
  List<Object?> get props => [startDate, endDate];
}

class ReportKPIs extends Equatable {
  final int totalJobsAssigned;
  final int totalJobsResolved;
  final int pendingJobs;
  final double completionRatePercentage;
  final double firstTimeFixRatePercentage;
  final double averageResolutionTimeHours;
  final int averageTravelTimeMinutes;
  final double onTimeSlaCompliancePercentage;
  final double averageRating;
  final int totalReviewsCount;
  final Map<String, int> ratingDistribution;

  const ReportKPIs({
    required this.totalJobsAssigned,
    required this.totalJobsResolved,
    required this.pendingJobs,
    required this.completionRatePercentage,
    required this.firstTimeFixRatePercentage,
    required this.averageResolutionTimeHours,
    required this.averageTravelTimeMinutes,
    required this.onTimeSlaCompliancePercentage,
    required this.averageRating,
    required this.totalReviewsCount,
    required this.ratingDistribution,
  });

  factory ReportKPIs.fromJson(Map<String, dynamic> json) {
    return ReportKPIs(
      totalJobsAssigned: json['totalJobsAssigned'] ?? 0,
      totalJobsResolved: json['totalJobsResolved'] ?? 0,
      pendingJobs: json['pendingJobs'] ?? 0,
      completionRatePercentage: (json['completionRatePercentage'] ?? 0.0).toDouble(),
      firstTimeFixRatePercentage: (json['firstTimeFixRatePercentage'] ?? 0.0).toDouble(),
      averageResolutionTimeHours: (json['averageResolutionTimeHours'] ?? 0.0).toDouble(),
      averageTravelTimeMinutes: json['averageTravelTimeMinutes'] ?? 0,
      onTimeSlaCompliancePercentage: (json['onTimeSlaCompliancePercentage'] ?? 0.0).toDouble(),
      averageRating: (json['averageRating'] ?? 0.0).toDouble(),
      totalReviewsCount: json['totalReviewsCount'] ?? 0,
      ratingDistribution: Map<String, int>.from(json['ratingDistribution'] ?? {}),
    );
  }

  @override
  List<Object?> get props => [
        totalJobsAssigned,
        totalJobsResolved,
        pendingJobs,
        completionRatePercentage,
        firstTimeFixRatePercentage,
        averageResolutionTimeHours,
        averageTravelTimeMinutes,
        onTimeSlaCompliancePercentage,
        averageRating,
        totalReviewsCount,
        ratingDistribution,
      ];
}

class IncentivesAndEarnings extends Equatable {
  final int baseDoorstepVisitsCount;
  final double distanceTravelledKm;
  final double totalLaborHours;
  final double sparePartsReplacementValueINR;
  final double earnedIncentiveINR;

  const IncentivesAndEarnings({
    required this.baseDoorstepVisitsCount,
    required this.distanceTravelledKm,
    required this.totalLaborHours,
    required this.sparePartsReplacementValueINR,
    required this.earnedIncentiveINR,
  });

  factory IncentivesAndEarnings.fromJson(Map<String, dynamic> json) {
    return IncentivesAndEarnings(
      baseDoorstepVisitsCount: json['baseDoorstepVisitsCount'] ?? 0,
      distanceTravelledKm: (json['distanceTravelledKm'] ?? 0.0).toDouble(),
      totalLaborHours: (json['totalLaborHours'] ?? 0.0).toDouble(),
      sparePartsReplacementValueINR: (json['sparePartsReplacementValueINR'] ?? 0.0).toDouble(),
      earnedIncentiveINR: (json['earnedIncentiveINR'] ?? 0.0).toDouble(),
    );
  }

  @override
  List<Object?> get props => [
        baseDoorstepVisitsCount,
        distanceTravelledKm,
        totalLaborHours,
        sparePartsReplacementValueINR,
        earnedIncentiveINR,
      ];
}

class TechnicianHistoryItem extends Equatable {
  final String ticketId;
  final String ticketNumber;
  final String title;
  final String category;
  final String product;
  final String priority;
  final String status;
  final String supportMode;
  final String customerName;
  final String siteLocation;
  final double rating;
  final String? feedbackComment;

  const TechnicianHistoryItem({
    required this.ticketId,
    required this.ticketNumber,
    required this.title,
    required this.category,
    required this.product,
    required this.priority,
    required this.status,
    required this.supportMode,
    required this.customerName,
    required this.siteLocation,
    required this.rating,
    this.feedbackComment,
  });

  factory TechnicianHistoryItem.fromJson(Map<String, dynamic> json) {
    return TechnicianHistoryItem(
      ticketId: json['ticketId'] ?? '',
      ticketNumber: json['ticketNumber'] ?? '',
      title: json['title'] ?? '',
      category: json['category'] ?? '',
      product: json['product'] ?? '',
      priority: json['priority'] ?? '',
      status: json['status'] ?? '',
      supportMode: json['supportMode'] ?? '',
      customerName: (json['customer'] ?? {})['name'] ?? '',
      siteLocation: (json['customer'] ?? {})['siteLocation'] ?? '',
      rating: ((json['customerFeedback'] ?? {})['rating'] ?? 0.0).toDouble(),
      feedbackComment: (json['customerFeedback'] ?? {})['comment'],
    );
  }

  @override
  List<Object?> get props => [
        ticketId,
        ticketNumber,
        title,
        category,
        product,
        priority,
        status,
        supportMode,
        customerName,
        siteLocation,
        rating,
        feedbackComment,
      ];
}
