import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../data/models/dashboard_models.dart';

class CategoryChartCard extends StatelessWidget {
  final List<RequestCategoryItem> categories;

  const CategoryChartCard({super.key, required this.categories});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final int total = categories.fold(0, (sum, val) => sum + val.count);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Requests by Category',
            style: textTheme.titleMedium,
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              SizedBox(
                height: 120,
                width: 120,
                child: Stack(
                  children: [
                    PieChart(
                      PieChartData(
                        sectionsSpace: 0,
                        centerSpaceRadius: 40,
                        sections: _getSections(categories, total),
                      ),
                    ),
                    Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            total.toString(),
                            style: textTheme.titleLarge?.copyWith(fontSize: 18),
                          ),
                          Text(
                            'TOTAL',
                            style: textTheme.labelLarge?.copyWith(fontSize: 8),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 24),
              Expanded(
                child: Column(
                  children: categories.map((item) {
                    final color = _parseColor(item.color);
                    final percentage = total > 0 ? (item.count / total * 100).toStringAsFixed(0) : "0";
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Row(
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: color,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              _formatLabel(item.category),
                              style: textTheme.bodyMedium?.copyWith(fontSize: 12),
                            ),
                          ),
                          Text(
                            item.count.toString(),
                            style: textTheme.titleMedium?.copyWith(fontSize: 12),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '$percentage%',
                            style: textTheme.labelLarge?.copyWith(fontSize: 10),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  List<PieChartSectionData> _getSections(List<RequestCategoryItem> categories, int total) {
    return categories.map((item) {
      return PieChartSectionData(
        color: _parseColor(item.color),
        value: item.count.toDouble(),
        title: '',
        radius: 12,
      );
    }).toList();
  }

  Color _parseColor(String colorString) {
    try {
      final hexColor = colorString.replaceAll('#', '');
      if (hexColor.length == 6) {
        return Color(int.parse('FF$hexColor', radix: 16));
      }
      return Color(int.parse(hexColor, radix: 16));
    } catch (e) {
      return AppColors.ink400;
    }
  }

  String _formatLabel(String key) {
    final k = key.toLowerCase();
    if (k == 'hardware') return 'Repair & Hardware';
    if (k == 'software') return 'Installation';
    if (k == 'sensor') return 'Sensors & Calibration';
    return key;
  }
}
