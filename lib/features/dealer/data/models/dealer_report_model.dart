import 'package:equatable/equatable.dart';

class DealerPerformanceReport extends Equatable {
  final ReportHeader header;
  final WeeklyRequestTrends weeklyTrends;
  final RequestsByCategory categoryBreakdown;
  final RequestStatusBreakdown statusBreakdown;

  const DealerPerformanceReport({
    required this.header,
    required this.weeklyTrends,
    required this.categoryBreakdown,
    required this.statusBreakdown,
  });

  factory DealerPerformanceReport.fromJson(Map<String, dynamic> json) {
    return DealerPerformanceReport(
      header: ReportHeader.fromJson(json['header']),
      weeklyTrends: WeeklyRequestTrends.fromJson(json['weeklyRequestTrends']),
      categoryBreakdown: RequestsByCategory.fromJson(json['requestsByCategory']),
      statusBreakdown: RequestStatusBreakdown.fromJson(json['requestStatusBreakdown']),
    );
  }

  @override
  List<Object?> get props => [header, weeklyTrends, categoryBreakdown, statusBreakdown];
}

class ReportHeader extends Equatable {
  final String title;
  final String subtitle;
  final String dealerName;
  final String selectedTimeframe;
  final List<String> availableTimeframes;

  const ReportHeader({
    required this.title,
    required this.subtitle,
    required this.dealerName,
    required this.selectedTimeframe,
    required this.availableTimeframes,
  });

  factory ReportHeader.fromJson(Map<String, dynamic> json) {
    return ReportHeader(
      title: json['title'],
      subtitle: json['subtitle'],
      dealerName: json['dealerName'],
      selectedTimeframe: json['selectedTimeframe'],
      availableTimeframes: List<String>.from(json['availableTimeframes']),
    );
  }

  @override
  List<Object?> get props => [title, subtitle, dealerName, selectedTimeframe, availableTimeframes];
}

class WeeklyRequestTrends extends Equatable {
  final String chartTitle;
  final List<TrendDataPoint> dataPoints;

  const WeeklyRequestTrends({
    required this.chartTitle,
    required this.dataPoints,
  });

  factory WeeklyRequestTrends.fromJson(Map<String, dynamic> json) {
    return WeeklyRequestTrends(
      chartTitle: json['chartTitle'],
      dataPoints: (json['dataPoints'] as List)
          .map((e) => TrendDataPoint.fromJson(e))
          .toList(),
    );
  }

  @override
  List<Object?> get props => [chartTitle, dataPoints];
}

class TrendDataPoint extends Equatable {
  final String weekLabel;
  final int count;

  const TrendDataPoint({
    required this.weekLabel,
    required this.count,
  });

  factory TrendDataPoint.fromJson(Map<String, dynamic> json) {
    return TrendDataPoint(
      weekLabel: json['weekLabel'],
      count: json['count'],
    );
  }

  @override
  List<Object?> get props => [weekLabel, count];
}

class RequestsByCategory extends Equatable {
  final String title;
  final int maxCount;
  final List<CategoryMetric> categories;

  const RequestsByCategory({
    required this.title,
    required this.maxCount,
    required this.categories,
  });

  factory RequestsByCategory.fromJson(Map<String, dynamic> json) {
    return RequestsByCategory(
      title: json['title'],
      maxCount: json['maxCount'],
      categories: (json['categories'] as List)
          .map((e) => CategoryMetric.fromJson(e))
          .toList(),
    );
  }

  @override
  List<Object?> get props => [title, maxCount, categories];
}

class CategoryMetric extends Equatable {
  final String id;
  final String name;
  final String subtitle;
  final int count;
  final String colorHex;

  const CategoryMetric({
    required this.id,
    required this.name,
    required this.subtitle,
    required this.count,
    required this.colorHex,
  });

  factory CategoryMetric.fromJson(Map<String, dynamic> json) {
    return CategoryMetric(
      id: json['id'],
      name: json['name'],
      subtitle: json['subtitle'],
      count: json['count'],
      colorHex: json['colorHex'],
    );
  }

  @override
  List<Object?> get props => [id, name, subtitle, count, colorHex];
}

class RequestStatusBreakdown extends Equatable {
  final String title;
  final int totalCount;
  final String totalLabel;
  final List<StatusMetric> statuses;

  const RequestStatusBreakdown({
    required this.title,
    required this.totalCount,
    required this.totalLabel,
    required this.statuses,
  });

  factory RequestStatusBreakdown.fromJson(Map<String, dynamic> json) {
    return RequestStatusBreakdown(
      title: json['title'],
      totalCount: json['totalCount'],
      totalLabel: json['totalLabel'],
      statuses: (json['statuses'] as List)
          .map((e) => StatusMetric.fromJson(e))
          .toList(),
    );
  }

  @override
  List<Object?> get props => [title, totalCount, totalLabel, statuses];
}

class StatusMetric extends Equatable {
  final String id;
  final String label;
  final int count;
  final double percentage;
  final String colorHex;

  const StatusMetric({
    required this.id,
    required this.label,
    required this.count,
    required this.percentage,
    required this.colorHex,
  });

  factory StatusMetric.fromJson(Map<String, dynamic> json) {
    return StatusMetric(
      id: json['id'],
      label: json['label'],
      count: json['count'],
      percentage: (json['percentage'] as num).toDouble(),
      colorHex: json['colorHex'],
    );
  }

  @override
  List<Object?> get props => [id, label, count, percentage, colorHex];
}
