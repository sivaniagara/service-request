import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_theme.dart';
import '../../data/models/admin_report_models.dart';
import '../../data/models/admin_dashboard_model.dart';
import '../bloc/admin_dashboard_cubit.dart';

class AdminReportsView extends StatelessWidget {
  final AdminReportSummaryData summary;
  final AdminSlaComplianceData sla;
  final List<RegionalDistribution>? regions;

  const AdminReportsView({super.key, required this.summary, required this.sla, this.regions});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),
          const SizedBox(height: 24),
          _buildKpiGrid(),
          const SizedBox(height: 24),
          _buildTrendCard(),
          const SizedBox(height: 24),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 3, child: _buildSlaCard()),
              const SizedBox(width: 24),
              Expanded(flex: 2, child: _buildDistributionCards()),
            ],
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Platform SLA & Service Request Report',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: AppColors.navy900),
            ),
            const SizedBox(height: 4),
            Text(
              'Summary for ${summary.filter.timeframe} in ${summary.filter.region}',
              style: const TextStyle(fontSize: 13, color: AppColors.ink400, fontWeight: FontWeight.w500),
            ),
          ],
        ),
        Row(
          children: [
            if (regions != null && regions!.isNotEmpty) ...[
              _buildRegionDropdown(context),
              const SizedBox(width: 16),
            ],
            _buildTimeframePill(context, '7D'),
            const SizedBox(width: 8),
            _buildTimeframePill(context, '30D'),
            const SizedBox(width: 8),
            _buildTimeframePill(context, '90D'),
            const SizedBox(width: 8),
            _buildTimeframePill(context, '1Y'),
            const SizedBox(width: 24),
            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.file_download_outlined, size: 18),
              label: const Text('Export Data'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.navy900,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                textStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRegionDropdown(BuildContext context) {
    final currentRegion = summary.filter.region;
    // Map API's "all" representation to null for the dropdown value
    final dropdownValue = (currentRegion == 'all' || currentRegion == 'All Regions') ? null : currentRegion;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.line),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: dropdownValue,
          hint: const Text('All Regions', style: TextStyle(fontSize: 13, color: AppColors.ink600)),
          icon: const Icon(Icons.keyboard_arrow_down, size: 20, color: AppColors.ink400),
          items: [
            const DropdownMenuItem<String>(
              value: null,
              child: Text('All Regions', style: TextStyle(fontSize: 13)),
            ),
            ...regions!.map((r) => DropdownMenuItem<String>(
              value: r.regionName,
              child: Text(r.regionName, style: const TextStyle(fontSize: 13)),
            )),
          ],
          onChanged: (val) {
            context.read<AdminDashboardCubit>().loadReports(
              timeframe: summary.filter.timeframe,
              region: val,
            );
          },
        ),
      ),
    );
  }

  Widget _buildTimeframePill(BuildContext context, String label) {
    final currentRegion = summary.filter.region;
    final regionParam = (currentRegion == 'all' || currentRegion == 'All Regions') ? null : currentRegion;
    final isActive = summary.filter.timeframe == label;
    return InkWell(
      onTap: () => context.read<AdminDashboardCubit>().loadReports(timeframe: label, region: regionParam),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isActive ? AppColors.navy900 : AppColors.bg,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isActive ? Colors.white : AppColors.ink600,
            fontWeight: isActive ? FontWeight.bold : FontWeight.w600,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  Widget _buildKpiGrid() {
    final metrics = summary.kpiMetrics;
    return GridView.count(
      crossAxisCount: 4,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 20,
      mainAxisSpacing: 20,
      childAspectRatio: 2.2,
      children: [
        _KpiMiniCard(
          title: 'Total Logged',
          value: metrics.totalTicketsLogged.toString(),
          icon: Icons.confirmation_number_outlined,
          color: AppColors.blue500,
        ),
        _KpiMiniCard(
          title: 'SLA Compliance',
          value: '${metrics.slaComplianceRate.toInt()}%',
          icon: Icons.verified_user_outlined,
          color: AppColors.green500,
        ),
        _KpiMiniCard(
          title: 'Avg. Resolution',
          value: '${metrics.averageResolutionHours.toInt()}h',
          icon: Icons.timer_outlined,
          color: Colors.orange,
        ),
        _KpiMiniCard(
          title: 'Satisfaction',
          value: metrics.overallCustomerSatisfactionScore.toStringAsFixed(1),
          icon: Icons.star_outline,
          color: Colors.purple,
        ),
      ],
    );
  }

  Widget _buildTrendCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Ticket Volume Trend',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: AppColors.navy900),
              ),
              Row(
                children: [
                  _TrendLegend(label: 'Logged', color: AppColors.blue500),
                  const SizedBox(width: 16),
                  _TrendLegend(label: 'Resolved', color: AppColors.green500),
                ],
              ),
            ],
          ),
          const SizedBox(height: 32),
          SizedBox(
            height: 260,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (value) => FlLine(
                    color: AppColors.line.withValues(alpha: 0.5),
                    strokeWidth: 1,
                    dashArray: [5, 5],
                  ),
                ),
                titlesData: FlTitlesData(
                  show: true,
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 32,
                      interval: 1,
                      getTitlesWidget: (value, meta) {
                        final index = value.toInt();
                        if (index >= 0 && index < summary.ticketVolumeTrends.length) {
                          if (summary.ticketVolumeTrends.length > 10 && index % 2 != 0) return const SizedBox.shrink();
                          final dateStr = summary.ticketVolumeTrends[index].date;
                          return Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: Text(
                              dateStr,
                              style: const TextStyle(color: AppColors.ink400, fontSize: 10, fontWeight: FontWeight.w600),
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) => Text(
                        value.toInt().toString(),
                        style: const TextStyle(color: AppColors.ink400, fontSize: 10),
                      ),
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  _buildTrendLine(
                    summary.ticketVolumeTrends.asMap().entries.map((e) => FlSpot(e.key.toDouble(), e.value.logged.toDouble())).toList(),
                    AppColors.blue500,
                  ),
                  _buildTrendLine(
                    summary.ticketVolumeTrends.asMap().entries.map((e) => FlSpot(e.key.toDouble(), e.value.resolved.toDouble())).toList(),
                    AppColors.green500,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  LineChartBarData _buildTrendLine(List<FlSpot> spots, Color color) {
    return LineChartBarData(
      spots: spots,
      isCurved: true,
      color: color,
      barWidth: 3,
      isStrokeCapRound: true,
      dotData: const FlDotData(show: false),
      belowBarData: BarAreaData(
        show: true,
        gradient: LinearGradient(
          colors: [color.withValues(alpha: 0.1), color.withValues(alpha: 0)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
    );
  }

  Widget _buildDistributionCards() {
    return Column(
      children: [
        _DistributionCard(
          title: 'Support Mode Breakdown',
          items: [
            _DistItem(
              label: 'Site Visits',
              count: summary.supportModeDistribution.siteVisits.count,
              percent: summary.supportModeDistribution.siteVisits.percentage,
              color: AppColors.navy900,
            ),
            _DistItem(
              label: 'Remote Support',
              count: summary.supportModeDistribution.remoteSupport.count,
              percent: summary.supportModeDistribution.remoteSupport.percentage,
              color: AppColors.blue500,
            ),
          ],
        ),
        const SizedBox(height: 24),
        _DistributionCard(
          title: 'Priority Breakdown',
          items: [
            _DistItem(label: 'Critical', count: summary.priorityBreakdown.critical, color: AppColors.red500),
            _DistItem(label: 'High', count: summary.priorityBreakdown.high, color: Colors.orange),
            _DistItem(label: 'Medium', count: summary.priorityBreakdown.medium, color: AppColors.blue500),
            _DistItem(label: 'Low', count: summary.priorityBreakdown.low, color: AppColors.green500),
          ],
        ),
      ],
    );
  }

  Widget _buildSlaCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            sla.title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: AppColors.navy900),
          ),
          const SizedBox(height: 32),
          Row(
            children: [
              SizedBox(
                width: 160,
                height: 160,
                child: Stack(
                  children: [
                    PieChart(
                      PieChartData(
                        sectionsSpace: 0,
                        centerSpaceRadius: 60,
                        startDegreeOffset: -90,
                        sections: sla.breakdown.map((item) {
                          return PieChartSectionData(
                            color: Color(int.parse(item.colorHex.replaceFirst('#', 'ff'), radix: 16)),
                            value: item.percentage,
                            title: '',
                            radius: 18,
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
                            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: AppColors.navy900),
                          ),
                          Text(
                            sla.primaryMetric.label,
                            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: AppColors.ink400),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 48),
              Expanded(
                child: Column(
                  children: sla.breakdown.map((item) => Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: Row(
                          children: [
                            Container(
                              width: 10,
                              height: 10,
                              decoration: BoxDecoration(
                                color: Color(int.parse(item.colorHex.replaceFirst('#', 'ff'), radix: 16)),
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                item.label,
                                style: const TextStyle(color: AppColors.ink600, fontSize: 13, fontWeight: FontWeight.w600),
                              ),
                            ),
                            Text(
                              item.count.toString(),
                              style: const TextStyle(fontWeight: FontWeight.w900, color: AppColors.navy900, fontSize: 13),
                            ),
                            const SizedBox(width: 12),
                            SizedBox(
                              width: 40,
                              child: Text(
                                '${item.percentage.toInt()}%',
                                textAlign: TextAlign.end,
                                style: const TextStyle(color: AppColors.ink400, fontSize: 12, fontWeight: FontWeight.bold),
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

class _KpiMiniCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _KpiMiniCard({required this.title, required this.value, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.line),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(title, style: const TextStyle(color: AppColors.ink400, fontSize: 12, fontWeight: FontWeight.w600)),
              Text(value, style: const TextStyle(color: AppColors.navy900, fontSize: 20, fontWeight: FontWeight.w900)),
            ],
          ),
        ],
      ),
    );
  }
}

class _TrendLegend extends StatelessWidget {
  final String label;
  final Color color;
  const _TrendLegend({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(color: AppColors.ink600, fontSize: 12, fontWeight: FontWeight.w600)),
      ],
    );
  }
}

class _DistributionCard extends StatelessWidget {
  final String title;
  final List<_DistItem> items;
  const _DistributionCard({required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: AppColors.navy900)),
          const SizedBox(height: 20),
          ...items.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(item.label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.ink600)),
                        Text(
                          item.percent != null ? '${item.count} (${item.percent!.toInt()}%)' : item.count.toString(),
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: AppColors.navy900),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(2),
                      child: LinearProgressIndicator(
                        value: item.percent != null ? item.percent! / 100 : 0.5,
                        backgroundColor: AppColors.bg,
                        color: item.color,
                        minHeight: 4,
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}

class _DistItem {
  final String label;
  final int count;
  final double? percent;
  final Color color;
  _DistItem({required this.label, required this.count, this.percent, required this.color});
}
