import 'package:equatable/equatable.dart';

class CustomerDashboardData extends Equatable {
  final CustomerProfile profile;
  final DashboardMetrics metrics;
  final List<ActiveTicket> activeTickets;
  final List<String> issueCategories;

  const CustomerDashboardData({
    required this.profile,
    required this.metrics,
    required this.activeTickets,
    required this.issueCategories,
  });

  factory CustomerDashboardData.fromJson(Map<String, dynamic> json) {
    return CustomerDashboardData(
      profile: CustomerProfile.fromJson(json['customerProfile']),
      metrics: DashboardMetrics.fromJson(json['metrics']),
      activeTickets: (json['activeTickets'] as List)
          .map((e) => ActiveTicket.fromJson(e))
          .toList(),
      issueCategories: List<String>.from(json['issueCategory'] ?? []),
    );
  }

  @override
  List<Object?> get props => [profile, metrics, activeTickets, issueCategories];
}

class CustomerProfile extends Equatable {
  final String userId;
  final String name;
  final String phone;
  final String email;
  final String address;

  const CustomerProfile({
    required this.userId,
    required this.name,
    required this.phone,
    required this.email,
    required this.address,
  });

  factory CustomerProfile.fromJson(Map<String, dynamic> json) {
    return CustomerProfile(
      userId: json['userId'].toString(),
      name: json['name'],
      phone: json['phone'],
      email: json['email'],
      address: json['address'],
    );
  }

  @override
  List<Object?> get props => [userId, name, phone, email, address];
}

class DashboardMetrics extends Equatable {
  final int totalComplaintsRaised;
  final int inProgressCount;
  final int resolvedCount;
  final double overallSatisfactionRating;

  const DashboardMetrics({
    required this.totalComplaintsRaised,
    required this.inProgressCount,
    required this.resolvedCount,
    required this.overallSatisfactionRating,
  });

  factory DashboardMetrics.fromJson(Map<String, dynamic> json) {
    return DashboardMetrics(
      totalComplaintsRaised: json['totalComplaintsRaised'],
      inProgressCount: json['inProgressCount'],
      resolvedCount: json['resolvedCount'],
      overallSatisfactionRating: (json['overallSatisfactionRating'] as num).toDouble(),
    );
  }

  @override
  List<Object?> get props => [
        totalComplaintsRaised,
        inProgressCount,
        resolvedCount,
        overallSatisfactionRating,
      ];
}

class ActiveTicket extends Equatable {
  final String ticketId;
  final String ticketNumber;
  final List<String> issueCategory;
  final String priority;
  final String status;
  final String currentMilestone;
  final String supportMode;
  final String siteLocation;
  final DateTime createdAt;
  final List<Dealer> assignedDealer;
  final List<Milestone> stepperMilestones;

  const ActiveTicket({
    required this.ticketId,
    required this.ticketNumber,
    required this.issueCategory,
    required this.priority,
    required this.status,
    required this.currentMilestone,
    required this.supportMode,
    required this.siteLocation,
    required this.createdAt,
    required this.assignedDealer,
    required this.stepperMilestones,
  });

  factory ActiveTicket.fromJson(Map<String, dynamic> json) {
    return ActiveTicket(
      ticketId: json['ticketId'] ?? '',
      ticketNumber: json['ticketNumber'] ?? '',
      issueCategory: List<String>.from(json['issueCategory'] ?? []),
      priority: json['priority'] ?? '',
      status: json['status'] ?? '',
      currentMilestone: json['currentMilestone'] ?? '',
      supportMode: json['supportMode'] ?? '',
      siteLocation: json['siteLocation'] ?? '',
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : DateTime.now(),
      assignedDealer: (json['assignedDealer'] as List?)
              ?.map((e) => Dealer.fromJson(e))
              .toList() ??
          [],
      stepperMilestones: (json['stepperMilestones'] as List?)
              ?.map((e) => Milestone.fromJson(e))
              .toList() ??
          [],
    );
  }

  @override
  List<Object?> get props => [
        ticketId,
        ticketNumber,
        issueCategory,
        priority,
        status,
        currentMilestone,
        supportMode,
        siteLocation,
        createdAt,
        assignedDealer,
        stepperMilestones,
      ];
}

class Dealer extends Equatable {
  final String? dealerId;
  final String name;
  final String phone;
  final String? email;
  final String? region;
  final List<Technician> assignedTechnician;

  const Dealer({
    this.dealerId,
    required this.name,
    required this.phone,
    this.email,
    this.region,
    required this.assignedTechnician,
  });

  factory Dealer.fromJson(Map<String, dynamic> json) {
    return Dealer(
      dealerId: json['dealerId'],
      name: json['name'],
      phone: json['phone'],
      email: json['email'],
      region: json['region'],
      assignedTechnician: (json['assignedTechnician'] != null)
          ? (json['assignedTechnician'] as List)
              .map((e) => Technician.fromJson(e))
              .toList()
          : [],
    );
  }

  @override
  List<Object?> get props => [dealerId, name, phone, email, region, assignedTechnician];
}

class Technician extends Equatable {
  final String? technicianId;
  final String name;
  final String phone;
  final String? status;
  final double? rating;
  final int? totalResolved;
  final String? travelDistance;
  final String? estimatedEta;

  const Technician({
    this.technicianId,
    required this.name,
    required this.phone,
    this.status,
    this.rating,
    this.totalResolved,
    this.travelDistance,
    this.estimatedEta,
  });

  factory Technician.fromJson(Map<String, dynamic> json) {
    return Technician(
      technicianId: json['technicianId'],
      name: json['name'],
      phone: json['phone'],
      status: json['status'],
      rating: (json['rating'] as num?)?.toDouble(),
      totalResolved: json['totalResolved'],
      travelDistance: json['travelDistance'],
      estimatedEta: json['estimatedEta'],
    );
  }

  @override
  List<Object?> get props => [
        technicianId,
        name,
        phone,
        status,
        rating,
        totalResolved,
        travelDistance,
        estimatedEta,
      ];
}

class ServiceTicket extends Equatable {
  final String ticketId;
  final String ticketNumber;
  final String? description;
  final List<String> issueCategory;
  final String priority;
  final String status;
  final String? supportMode;
  final String? siteLocation;
  final DateTime createdAt;
  final bool hasRating;
  final int assignedDealersCount;
  final List<Technician> assignedTechnicians;

  const ServiceTicket({
    required this.ticketId,
    required this.ticketNumber,
    this.description,
    required this.issueCategory,
    required this.priority,
    required this.status,
    this.supportMode,
    this.siteLocation,
    required this.createdAt,
    required this.hasRating,
    required this.assignedDealersCount,
    required this.assignedTechnicians,
  });

  factory ServiceTicket.fromJson(Map<String, dynamic> json) {
    return ServiceTicket(
      ticketId: json['ticketId'],
      ticketNumber: json['ticketNumber'],
      description: json['description'],
      issueCategory: List<String>.from(json['issueCategory'] ?? []),
      priority: json['priority'],
      status: json['status'],
      supportMode: json['supportMode'],
      siteLocation: json['siteLocation'],
      createdAt: DateTime.parse(json['createdAt']),
      hasRating: json['hasRating'] ?? false,
      assignedDealersCount: json['assignedDealersCount'] ?? 0,
      assignedTechnicians: (json['assignedTechnicians'] as List?)
              ?.map((e) => Technician.fromJson(e))
              .toList() ??
          [],
    );
  }

  @override
  List<Object?> get props => [
        ticketId,
        ticketNumber,
        description,
        issueCategory,
        priority,
        status,
        supportMode,
        siteLocation,
        createdAt,
        hasRating,
        assignedDealersCount,
        assignedTechnicians,
      ];
}

class ServiceTicketDetail extends Equatable {
  final String ticketId;
  final String ticketNumber;
  final String title;
  final String? description;
  final List<String> issueCategory;
  final String priority;
  final String status;
  final String? supportMode;
  final String? siteLocation;
  final String? preferredSlot;
  final DateTime createdAt;
  final List<Dealer> assignedDealer;
  final List<Milestone> stepperMilestones;
  final List<TimelineEvent> timelineEvents;
  final List<String> attachedPhotos;

  const ServiceTicketDetail({
    required this.ticketId,
    required this.ticketNumber,
    required this.title,
    this.description,
    required this.issueCategory,
    required this.priority,
    required this.status,
    this.supportMode,
    this.siteLocation,
    this.preferredSlot,
    required this.createdAt,
    required this.assignedDealer,
    required this.stepperMilestones,
    required this.timelineEvents,
    required this.attachedPhotos,
  });

  factory ServiceTicketDetail.fromJson(Map<String, dynamic> json) {
    return ServiceTicketDetail(
      ticketId: json['ticketId'],
      ticketNumber: json['ticketNumber'],
      title: json['title'] ?? '',
      description: json['description'],
      issueCategory: List<String>.from(json['issueCategory'] ?? []),
      priority: json['priority'],
      status: json['status'],
      supportMode: json['supportMode'],
      siteLocation: json['siteLocation'],
      preferredSlot: json['preferredSlot'],
      createdAt: DateTime.parse(json['createdAt']),
      assignedDealer: (json['assignedDealer'] as List?)
              ?.map((e) => Dealer.fromJson(e))
              .toList() ??
          [],
      stepperMilestones: (json['stepperMilestones'] as List?)
              ?.map((e) => Milestone.fromJson(e))
              .toList() ??
          [],
      timelineEvents: (json['timelineEvents'] as List?)
              ?.map((e) => TimelineEvent.fromJson(e))
              .toList() ??
          [],
      attachedPhotos: List<String>.from(json['attachedPhotos'] ?? []),
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
        assignedDealer,
        stepperMilestones,
        timelineEvents,
        attachedPhotos,
      ];
}

class Milestone extends Equatable {
  final int stepOrder;
  final String key;
  final String title;
  final String? description;
  final String status;
  final String? updatedAt;
  final String? updatedBy;

  const Milestone({
    required this.stepOrder,
    required this.key,
    required this.title,
    this.description,
    required this.status,
    this.updatedAt,
    this.updatedBy,
  });

  factory Milestone.fromJson(Map<String, dynamic> json) {
    return Milestone(
      stepOrder: json['stepOrder'],
      key: json['key'],
      title: json['title'],
      description: json['description'],
      status: json['status'],
      updatedAt: json['updatedAt'],
      updatedBy: json['updatedBy'],
    );
  }

  @override
  List<Object?> get props => [stepOrder, key, title, description, status, updatedAt, updatedBy];
}

class TimelineEvent extends Equatable {
  final String id;
  final String timestamp;
  final String title;
  final String description;
  final String actor;
  final String actorRole;
  final String badgeType;

  const TimelineEvent({
    required this.id,
    required this.timestamp,
    required this.title,
    required this.description,
    required this.actor,
    required this.actorRole,
    required this.badgeType,
  });

  factory TimelineEvent.fromJson(Map<String, dynamic> json) {
    return TimelineEvent(
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

class CustomerReport extends Equatable {
  final String timeframe;
  final ReportSummary summary;
  final RequestsOverTime requestsOverTime;
  final List<RequestHistorySummaryItem> requestHistorySummary;
  final List<CategoryBreakdown> categoryBreakdown;
  final List<ServiceHistoryItem> serviceHistory;
  final String? downloadPdfUrl;

  const CustomerReport({
    required this.timeframe,
    required this.summary,
    required this.requestsOverTime,
    required this.requestHistorySummary,
    required this.categoryBreakdown,
    required this.serviceHistory,
    this.downloadPdfUrl,
  });

  factory CustomerReport.fromJson(Map<String, dynamic> json) {
    return CustomerReport(
      timeframe: json['timeframe'] ?? '',
      summary: ReportSummary.fromJson(json['summaryCards'] ?? {}),
      requestsOverTime: RequestsOverTime.fromJson(json['requestsOverTime'] ?? {}),
      requestHistorySummary: (json['requestHistorySummary'] as List?)
              ?.map((e) => RequestHistorySummaryItem.fromJson(e))
              .toList() ??
          [],
      categoryBreakdown: (json['categoryBreakdown'] as List?)
              ?.map((e) => CategoryBreakdown.fromJson(e))
              .toList() ??
          [],
      serviceHistory: (json['serviceHistory'] as List?)
              ?.map((e) => ServiceHistoryItem.fromJson(e))
              .toList() ??
          [],
      downloadPdfUrl: json['downloadPdfUrl'],
    );
  }

  @override
  List<Object?> get props => [
        timeframe,
        summary,
        requestsOverTime,
        requestHistorySummary,
        categoryBreakdown,
        serviceHistory,
        downloadPdfUrl,
      ];
}

class RequestsOverTime extends Equatable {
  final List<ChartSpot> spots;
  final double maxY;
  final double interval;

  const RequestsOverTime({
    required this.spots,
    required this.maxY,
    required this.interval,
  });

  factory RequestsOverTime.fromJson(Map<String, dynamic> json) {
    return RequestsOverTime(
      spots: (json['spots'] as List?)
              ?.map((e) => ChartSpot.fromJson(e))
              .toList() ??
          [],
      maxY: (json['maxY'] as num?)?.toDouble() ?? 0.0,
      interval: (json['interval'] as num?)?.toDouble() ?? 1.0,
    );
  }

  @override
  List<Object?> get props => [spots, maxY, interval];
}

class ChartSpot extends Equatable {
  final String label;
  final int year;
  final int count;
  final int spotIndex;

  const ChartSpot({
    required this.label,
    required this.year,
    required this.count,
    required this.spotIndex,
  });

  factory ChartSpot.fromJson(Map<String, dynamic> json) {
    return ChartSpot(
      label: json['label'] ?? '',
      year: json['year'] ?? 0,
      count: json['count'] ?? 0,
      spotIndex: json['spotIndex'] ?? 0,
    );
  }

  @override
  List<Object?> get props => [label, year, count, spotIndex];
}

class RequestHistorySummaryItem extends Equatable {
  final String ticketId;
  final String ticketNumber;
  final String site;
  final String raised;
  final String raisedIso;
  final String status;
  final List<String> issueCategory;
  final String priority;

  const RequestHistorySummaryItem({
    required this.ticketId,
    required this.ticketNumber,
    required this.site,
    required this.raised,
    required this.raisedIso,
    required this.status,
    required this.issueCategory,
    required this.priority,
  });

  factory RequestHistorySummaryItem.fromJson(Map<String, dynamic> json) {
    return RequestHistorySummaryItem(
      ticketId: json['ticketId'] ?? '',
      ticketNumber: json['ticketNumber'] ?? '',
      site: json['site'] ?? '',
      raised: json['raised'] ?? '',
      raisedIso: json['raisedIso'] ?? '',
      status: json['status'] ?? '',
      issueCategory: List<String>.from(json['issueCategory'] ?? []),
      priority: json['priority'] ?? '',
    );
  }

  @override
  List<Object?> get props => [
        ticketId,
        ticketNumber,
        site,
        raised,
        raisedIso,
        status,
        issueCategory,
        priority,
      ];
}

class ReportSummary extends Equatable {
  final int totalServiceRequests;
  final String firstVisitResolvedRate;
  final double averageTurnaroundHours;
  final double averageSatisfactionScore;

  const ReportSummary({
    required this.totalServiceRequests,
    required this.firstVisitResolvedRate,
    required this.averageTurnaroundHours,
    required this.averageSatisfactionScore,
  });

  factory ReportSummary.fromJson(Map<String, dynamic> json) {
    return ReportSummary(
      totalServiceRequests: json['totalServiceRequests'],
      firstVisitResolvedRate: json['firstVisitResolvedRate'],
      averageTurnaroundHours: (json['averageTurnaroundHours'] as num).toDouble(),
      averageSatisfactionScore: (json['averageSatisfactionScore'] as num).toDouble(),
    );
  }

  @override
  List<Object?> get props => [
        totalServiceRequests,
        firstVisitResolvedRate,
        averageTurnaroundHours,
        averageSatisfactionScore,
      ];
}

class CategoryBreakdown extends Equatable {
  final String category;
  final int count;
  final double percentage;
  final String color;

  const CategoryBreakdown({
    required this.category,
    required this.count,
    required this.percentage,
    required this.color,
  });

  factory CategoryBreakdown.fromJson(Map<String, dynamic> json) {
    return CategoryBreakdown(
      category: json['category'],
      count: json['count'],
      percentage: (json['percentage'] as num).toDouble(),
      color: json['color'] ?? '#000000',
    );
  }

  @override
  List<Object?> get props => [category, count, percentage, color];
}

class ServiceHistoryItem extends Equatable {
  final String ticketNumber;
  final String product;
  final String resolvedDate;
  final String turnaroundTime;
  final String technicianName;
  final String dealerName;
  final int ratingGiven;
  final String downloadPdfUrl;

  const ServiceHistoryItem({
    required this.ticketNumber,
    required this.product,
    required this.resolvedDate,
    required this.turnaroundTime,
    required this.technicianName,
    required this.dealerName,
    required this.ratingGiven,
    required this.downloadPdfUrl,
  });

  factory ServiceHistoryItem.fromJson(Map<String, dynamic> json) {
    return ServiceHistoryItem(
      ticketNumber: json['ticketNumber'],
      product: json['product'],
      resolvedDate: json['resolvedDate'],
      turnaroundTime: json['turnaroundTime'],
      technicianName: json['technicianName'],
      dealerName: json['dealerName'],
      ratingGiven: json['ratingGiven'],
      downloadPdfUrl: json['downloadPdfUrl'],
    );
  }

  @override
  List<Object?> get props => [
        ticketNumber,
        product,
        resolvedDate,
        turnaroundTime,
        technicianName,
        dealerName,
        ratingGiven,
        downloadPdfUrl,
      ];
}
