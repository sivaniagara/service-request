import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../../../../core/theme/app_theme.dart';

class RequestsOverTimeChart extends StatelessWidget {
  const RequestsOverTimeChart({super.key});

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
          height: 180, // Reduced from 240
          child: LineChart(
            LineChartData(
              gridData: FlGridData(
                show: true,
                drawVerticalLine: false,
                horizontalInterval: 1,
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
                      String text = '';
                      switch (value.toInt()) {
                        case 0: text = 'Feb'; break;
                        case 1: text = 'Mar'; break;
                        case 2: text = 'Apr'; break;
                        case 3: text = 'May'; break;
                        case 4: text = 'Jun'; break;
                        case 5: text = 'Jul'; break;
                        case 6: text = 'Aug'; break;
                        case 7: text = 'Sep'; break;
                      }
                      return Text(
                        text,
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
              maxX: 7,
              minY: 0,
              maxY: 3,
              lineBarsData: [
                LineChartBarData(
                  spots: const [
                    FlSpot(0, 1.2),
                    FlSpot(1, 0.8),
                    FlSpot(2, 1.2),
                    FlSpot(3, 0.8),
                    FlSpot(4, 1.2),
                    FlSpot(5, 1.2),
                    FlSpot(6, 1.8),
                    FlSpot(7, 0.8),
                  ],
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
