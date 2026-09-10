import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_theme.dart';
import '../../data/models/admin_report_models.dart';
import '../../data/models/admin_dashboard_model.dart';
import '../bloc/admin_dashboard_cubit.dart';

class AdminMobileReportsView extends StatefulWidget {
  final AdminReportSummaryData summary;
  final AdminSlaComplianceData sla;
  final List<RegionalDistribution>? regions;

  const AdminMobileReportsView({super.key, required this.summary, required this.sla, this.regions});

  @override
  State<AdminMobileReportsView> createState() => _AdminMobileReportsViewState();
}

class _AdminMobileReportsViewState extends State<AdminMobileReportsView> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 20),
          _buildKpiGrid(),
          const SizedBox(height: 20),
          _buildTrendCard(),
          const SizedBox(height: 20),
          _buildSlaCard(),
          const SizedBox(height: 20),
          _buildSupportModeCard(),
          const SizedBox(height: 20),
          _buildPriorityCard(),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Platform Performance',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: AppColors.navy900),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Summary for ${widget.summary.filter.timeframe}',
                    style: const TextStyle(fontSize: 11.5, color: AppColors.ink400, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: () {},
              tooltip: 'Export',
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: AppColors.navy900, borderRadius: BorderRadius.circular(10)),
                child: const Icon(Icons.file_download_outlined, size: 16, color: Colors.white),
              ),
            ),
          ],
        ),
        if (widget.regions != null && widget.regions!.isNotEmpty) ...[
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.line),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                isExpanded: true,
                value: (widget.summary.filter.region == 'all' || widget.summary.filter.region == 'All Regions') ? null : widget.summary.filter.region,
                hint: const Text('Filter by Region', style: TextStyle(fontSize: 13, color: AppColors.ink600)),
                icon: const Icon(Icons.keyboard_arrow_down, size: 20, color: AppColors.ink400),
                items: [
                  const DropdownMenuItem<String>(
                    value: null,
                    child: Text('All Regions', style: TextStyle(fontSize: 13)),
                  ),
                  ...widget.regions!.map((r) => DropdownMenuItem<String>(
                    value: r.regionName,
                    child: Text(r.regionName, style: const TextStyle(fontSize: 13)),
                  )),
                ],
                onChanged: (val) {
                  context.read<AdminDashboardCubit>().loadReports(
                    timeframe: widget.summary.filter.timeframe,
                    region: val,
                  );
                },
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildKpiGrid() {
    final metrics = widget.summary.kpiMetrics;
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.6,
      children: [
        _MobileKpiCard(
          title: 'Tickets Logged',
          value: metrics.totalTicketsLogged.toString(),
          icon: Icons.confirmation_number_outlined,
          color: AppColors.blue500,
        ),
        _MobileKpiCard(
          title: 'SLA Compliance',
          value: '${metrics.slaComplianceRate.toInt()}%',
          icon: Icons.verified_user_outlined,
          color: AppColors.green500,
        ),
        _MobileKpiCard(
          title: 'Avg. Resolution',
          value: '${metrics.averageResolutionHours.toInt()}h',
          icon: Icons.timer_outlined,
          color: Colors.orange,
        ),
        _MobileKpiCard(
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
      padding: const EdgeInsets.all(16),
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
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w900, color: AppColors.navy900),
              ),
              Row(
                children: [
                  _timeframePill('7D'),
                  const SizedBox(width: 4),
                  _timeframePill('30D'),
                  const SizedBox(width: 4),
                  _timeframePill('90D'),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 180,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (value) => FlLine(
                    color: AppColors.line.withValues(alpha: 0.5),
                    strokeWidth: 1,
                    dashArray: const [5, 5],
                  ),
                ),
                titlesData: FlTitlesData(
                  show: true,
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 26,
                      interval: 1,
                      getTitlesWidget: (value, meta) {
                        final index = value.toInt();
                        if (index >= 0 && index < widget.summary.ticketVolumeTrends.length) {
                          if (widget.summary.ticketVolumeTrends.length > 6 && index % 2 != 0) return const SizedBox.shrink();
                          return Padding(
                            padding: const EdgeInsets.only(top: 6.0),
                            child: Text(
                              widget.summary.ticketVolumeTrends[index].date,
                              style: const TextStyle(color: AppColors.ink400, fontSize: 9, fontWeight: FontWeight.w600),
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
                      reservedSize: 28,
                      getTitlesWidget: (value, meta) => Text(
                        value.toInt().toString(),
                        style: const TextStyle(color: AppColors.ink400, fontSize: 9),
                      ),
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  _buildTrendLine(
                    widget.summary.ticketVolumeTrends.asMap().entries.map((e) => FlSpot(e.key.toDouble(), e.value.logged.toDouble())).toList(),
                    AppColors.blue500,
                  ),
                  _buildTrendLine(
                    widget.summary.ticketVolumeTrends.asMap().entries.map((e) => FlSpot(e.key.toDouble(), e.value.resolved.toDouble())).toList(),
                    AppColors.green500,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _TrendLegend(label: 'Logged', color: AppColors.blue500),
              const SizedBox(width: 16),
              _TrendLegend(label: 'Resolved', color: AppColors.green500),
            ],
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
      barWidth: 2.5,
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

  Widget _timeframePill(String label) {
    final isActive = widget.summary.filter.timeframe == label;
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: () => context.read<AdminDashboardCubit>().loadReports(timeframe: label),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: isActive ? AppColors.navy900 : AppColors.bg,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isActive ? Colors.white : AppColors.ink400,
            fontWeight: isActive ? FontWeight.bold : FontWeight.w600,
            fontSize: 10.5,
          ),
        ),
      ),
    );
  }

  Widget _buildSlaCard() {
    final sla = widget.sla;
    return Container(
      padding: const EdgeInsets.all(16),
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
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w900, color: AppColors.navy900),
          ),
          const SizedBox(height: 24),
          Center(
            child: SizedBox(
              width: 130,
              height: 130,
              child: Stack(
                children: [
                  PieChart(
                    PieChartData(
                      sectionsSpace: 0,
                      centerSpaceRadius: 45,
                      startDegreeOffset: -90,
                      sections: sla.breakdown.map((item) {
                        return PieChartSectionData(
                          color: Color(int.parse(item.colorHex.replaceFirst('#', 'ff'), radix: 16)),
                          value: item.percentage,
                          title: '',
                          radius: 14,
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
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: AppColors.navy900),
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
          ),
          const SizedBox(height: 24),
          ...sla.breakdown.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
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
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        item.label,
                        style: const TextStyle(color: AppColors.ink600, fontSize: 12, fontWeight: FontWeight.w600),
                      ),
                    ),
                    Text(
                      item.count.toString(),
                      style: const TextStyle(fontWeight: FontWeight.w900, color: AppColors.navy900, fontSize: 12),
                    ),
                    const SizedBox(width: 6),
                    SizedBox(
                      width: 32,
                      child: Text(
                        '${item.percentage.toInt()}%',
                        textAlign: TextAlign.end,
                        style: const TextStyle(color: AppColors.ink400, fontSize: 11, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildSupportModeCard() {
    final dist = widget.summary.supportModeDistribution;
    return _DistributionCard(
      title: 'Support Mode Breakdown',
      items: [
        _DistItem(label: 'Site Visits', count: dist.siteVisits.count, percent: dist.siteVisits.percentage, color: AppColors.navy900),
        _DistItem(label: 'Remote Support', count: dist.remoteSupport.count, percent: dist.remoteSupport.percentage, color: AppColors.blue500),
      ],
    );
  }

  Widget _buildPriorityCard() {
    final p = widget.summary.priorityBreakdown;
    return _DistributionCard(
      title: 'Ticket Priority Distribution',
      items: [
        _DistItem(label: 'Critical', count: p.critical, color: AppColors.red500),
        _DistItem(label: 'High', count: p.high, color: Colors.orange),
        _DistItem(label: 'Medium', count: p.medium, color: AppColors.blue500),
        _DistItem(label: 'Low', count: p.low, color: AppColors.green500),
      ],
    );
  }
}

class _MobileKpiCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _MobileKpiCard({required this.title, required this.value, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
                child: Icon(icon, color: color, size: 14),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(color: AppColors.ink400, fontSize: 10, fontWeight: FontWeight.w700),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(value, style: const TextStyle(color: AppColors.navy900, fontSize: 18, fontWeight: FontWeight.w900)),
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
        Container(width: 7, height: 7, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 5),
        Text(label, style: const TextStyle(color: AppColors.ink600, fontSize: 10.5, fontWeight: FontWeight.w600)),
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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w900, color: AppColors.navy900)),
          const SizedBox(height: 20),
          ...items.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(item.label, style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600, color: AppColors.ink600)),
                        Text(
                          item.percent != null ? '${item.count} (${item.percent!.toInt()}%)' : item.count.toString(),
                          style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w900, color: AppColors.navy900),
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
