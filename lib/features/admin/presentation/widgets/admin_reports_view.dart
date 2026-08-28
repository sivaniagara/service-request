import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../../core/theme/app_theme.dart';
import '../../data/models/admin_report_models.dart';

class AdminReportsView extends StatelessWidget {
  final AdminReportSummaryData summary;
  final AdminSlaComplianceData sla;

  const AdminReportsView({super.key, required this.summary, required this.sla});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 16),
          _buildTrendCard(),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 1, child: _buildRegionCard()),
              const SizedBox(width: 16),
              Expanded(flex: 1, child: _buildSlaCard()),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Platform SLA & Service Request Report',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.navy900),
            ),
            const SizedBox(height: 2),
            const Text(
              'Platform-wide performance, ticket trends, and regions',
              style: TextStyle(fontSize: 12, color: AppColors.ink400),
            ),
          ],
        ),
        Row(
          children: [
            _buildTimeframePill('7D'),
            const SizedBox(width: 4),
            _buildTimeframePill('30D', isActive: true),
            const SizedBox(width: 4),
            _buildTimeframePill('90D'),
            const SizedBox(width: 12),
            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.file_download_outlined, size: 16),
              label: const Text('Export'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.navy900,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTimeframePill(String label, {bool isActive = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isActive ? AppColors.bg : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isActive ? AppColors.navy900 : AppColors.ink400,
          fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildTrendCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Ticket Volume Trend Across All Dealers',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.navy900),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 220,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 2,
                  getDrawingHorizontalLine: (value) => FlLine(
                    color: AppColors.line.withValues(alpha: 0.5),
                    strokeWidth: 1,
                    dashArray: [5, 5],
                  ),
                ),
                titlesData: FlTitlesData(
                  show: true,
                  rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      interval: 1,
                      getTitlesWidget: (value, meta) {
                        final months = ['Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug'];
                        if (value.toInt() >= 0 && value.toInt() < months.length) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              months[value.toInt()],
                              style: const TextStyle(color: AppColors.ink400, fontSize: 11),
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: const [
                      FlSpot(0, 4),
                      FlSpot(1, 5),
                      FlSpot(2, 3.8),
                      FlSpot(3, 5.2),
                      FlSpot(4, 4.8),
                      FlSpot(5, 6),
                      FlSpot(6, 5.5),
                    ],
                    isCurved: true,
                    color: AppColors.blue500,
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) => FlDotCirclePainter(
                        radius: 4,
                        color: Colors.white,
                        strokeWidth: 2.5,
                        strokeColor: AppColors.blue500,
                      ),
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        colors: [
                          AppColors.blue500.withValues(alpha: 0.15),
                          AppColors.blue500.withValues(alpha: 0),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ],
                lineTouchData: LineTouchData(
                  touchTooltipData: LineTouchTooltipData(
                    getTooltipColor: (touchedSpot) => AppColors.navy900,
                    getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
                      return touchedBarSpots.map((barSpot) {
                        return LineTooltipItem(
                          '${barSpot.y.toInt()} Tickets',
                          const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        );
                      }).toList();
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRegionCard() {
    final regions = [
      {'name': 'Tamil Nadu', 'cities': 'Coimbatore, Salem, Pollachi', 'count': 128, 'color': AppColors.navy900},
      {'name': 'Karnataka', 'cities': 'Bengaluru, Mysuru', 'count': 94, 'color': AppColors.purple500},
      {'name': 'Andhra Pradesh', 'cities': 'Vijayawada, Guntur', 'count': 66, 'color': Colors.orange},
      {'name': 'Telangana', 'cities': 'Hyderabad, Warangal', 'count': 41, 'color': AppColors.blue500},
      {'name': 'Kerala', 'cities': 'Kochi, Palakkad', 'count': 22, 'color': AppColors.green500},
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Requests by Region',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.navy900),
          ),
          const SizedBox(height: 16),
          ...regions.map((region) => Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(region['name'] as String,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                          Text(region['cities'] as String,
                              style: const TextStyle(color: AppColors.ink400, fontSize: 10)),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 5,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(2),
                        child: LinearProgressIndicator(
                          value: (region['count'] as int) / 128,
                          backgroundColor: AppColors.bg,
                          color: region['color'] as Color,
                          minHeight: 6,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    SizedBox(
                      width: 24,
                      child: Text(
                        region['count'].toString(),
                        textAlign: TextAlign.end,
                        style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.ink600, fontSize: 11),
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildSlaCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'SLA Compliance Breakdown',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.navy900),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              SizedBox(
                width: 110,
                height: 110,
                child: Stack(
                  children: [
                    PieChart(
                      PieChartData(
                        sectionsSpace: 0,
                        centerSpaceRadius: 40,
                        startDegreeOffset: -90,
                        sections: sla.breakdown.map((item) {
                          return PieChartSectionData(
                            color: Color(int.parse(item.colorHex.replaceFirst('#', 'ff'), radix: 16)),
                            value: item.percentage,
                            title: '',
                            radius: 12,
                          );
                        }).toList(),
                      ),
                    ),
                    Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '${sla.primaryMetric.percentage.toInt()}%',
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.navy900),
                          ),
                          Text(
                            sla.primaryMetric.label,
                            style: const TextStyle(fontSize: 8, fontWeight: FontWeight.w900, color: AppColors.ink400),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  children: sla.breakdown.map((item) => Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Row(
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: Color(int.parse(item.colorHex.replaceFirst('#', 'ff'), radix: 16)),
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                item.label,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(color: AppColors.ink600, fontSize: 11, fontWeight: FontWeight.w500),
                              ),
                            ),
                            Text(
                              item.count.toString(),
                              style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.ink900, fontSize: 11),
                            ),
                            const SizedBox(width: 4),
                            SizedBox(
                              width: 28,
                              child: Text(
                                '${item.percentage.toInt()}%',
                                textAlign: TextAlign.end,
                                style: const TextStyle(color: AppColors.ink400, fontSize: 10),
                              ),
                            ),
                          ],
                        ),
                      )).toList(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
