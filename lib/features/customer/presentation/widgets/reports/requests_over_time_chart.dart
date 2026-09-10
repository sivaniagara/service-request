import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../data/models/dashboard_models.dart';

class RequestsOverTimeChart extends StatelessWidget {
  final RequestsOverTime data;

  const RequestsOverTimeChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Requests Over Time',
          style: textTheme.titleMedium?.copyWith(color: AppColors.ink900, fontSize: 12),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 180,
          child: LineChart(
            LineChartData(
              gridData: FlGridData(
                show: true,
                drawVerticalLine: false,
                horizontalInterval: data.interval,
                getDrawingHorizontalLine: (value) {
                  return const FlLine(
                    color: AppColors.line,
                    strokeWidth: 1,
                    dashArray: [5, 5],
                  );
                },
              ),
              titlesData: FlTitlesData(
                show: true,
                rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 24,
                    interval: 1,
                    getTitlesWidget: (value, meta) {
                      final index = value.toInt();
                      if (index < 0 || index >= data.spots.length) return const SizedBox.shrink();
                      
                      return Text(
                        data.spots[index].label,
                        style: textTheme.labelLarge?.copyWith(
                          color: AppColors.ink400,
                          fontSize: 9,
                          fontWeight: FontWeight.normal,
                        ),
                      );
                    },
                  ),
                ),
                leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              ),
              borderData: FlBorderData(show: false),
              minX: 0,
              maxX: (data.spots.length - 1).toDouble(),
              minY: 0,
              maxY: data.maxY,
              lineBarsData: [
                LineChartBarData(
                  spots: data.spots
                      .map((s) => FlSpot(s.spotIndex.toDouble(), s.count.toDouble()))
                      .toList(),
                  isCurved: false,
                  color: AppColors.blue500,
                  barWidth: 2,
                  isStrokeCapRound: true,
                  dotData: FlDotData(
                    show: true,
                    getDotPainter: (spot, percent, barData, index) {
                      return FlDotCirclePainter(
                        radius: 3,
                        color: AppColors.blue500,
                        strokeWidth: 1.5,
                        strokeColor: Colors.white,
                      );
                    },
                  ),
                  belowBarData: BarAreaData(
                    show: true,
                    gradient: LinearGradient(
                      colors: [
                        AppColors.blue500.withOpacity(0.1),
                        AppColors.blue500.withOpacity(0),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
