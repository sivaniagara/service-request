import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../core/widgets/kpi_card.dart';
import '../../../data/models/dashboard_models.dart';
import '../../bloc/dashboard_cubit.dart';
import 'report_history_table.dart';
import 'requests_over_time_chart.dart';

class ReportsView extends StatelessWidget {
  final CustomerReport report;

  const ReportsView({super.key, required this.report});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final isMobile = MediaQuery.of(context).size.width < 600;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(isMobile ? 16 : 24),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.line),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context, textTheme, isMobile),
                const SizedBox(height: 24),
                _buildSummaryCards(isMobile),
                const SizedBox(height: 32),
                RequestsOverTimeChart(data: report.requestsOverTime),
                const SizedBox(height: 32),
                ReportHistoryTable(history: report.requestHistorySummary),
              ],
            ),
          ),
          const SizedBox(height: 24),
          _buildCategoryBreakdown(textTheme, isMobile),
          const SizedBox(height: 24),
          _buildServiceHistory(textTheme, isMobile, context),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, TextTheme textTheme, bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'My Service Request Report',
                    style: textTheme.headlineMedium?.copyWith(fontSize: 18, fontWeight: FontWeight.w900),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'A summary of the service requests you\'ve raised and their resolution turnaround',
                    style: textTheme.bodyMedium?.copyWith(color: AppColors.ink400, fontSize: 12),
                  ),
                ],
              ),
            ),
            if (!isMobile) _buildDownloadBtn(context),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                _TimeframeButton(label: '3M', timeframe: '3M', isActive: report.timeframe == '3M'),
                const SizedBox(width: 8),
                _TimeframeButton(label: '6M', timeframe: '6M', isActive: report.timeframe == '6M'),
                const SizedBox(width: 8),
                _TimeframeButton(label: '1Y', timeframe: '1Y', isActive: report.timeframe == '1Y'),
              ],
            ),
            if (isMobile) _buildDownloadBtn(context),
          ],
        ),
      ],
    );
  }

  Widget _buildDownloadBtn(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () => _handleDownload(context),
      icon: const Icon(Icons.file_download_outlined, size: 16),
      label: const Text('Download PDF'),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.navy900,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
      ),
    );
  }

  void _handleDownload(BuildContext context) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.info,
      animType: AnimType.bottomSlide,
      title: 'Preparing Download',
      desc: 'Your report PDF is being generated. It will start downloading automatically.',
      btnOkOnPress: () {},
      width: 400,
    ).show();
  }

  Widget _buildSummaryCards(bool isMobile) {
    final summary = report.summary;
    final cards = [
      KPICard(
        title: 'Total Requests',
        value: summary.totalServiceRequests.toString(),
        icon: Icons.confirmation_number_outlined,
        iconColor: AppColors.blue500,
        iconBgColor: AppColors.blue100,
      ),
      KPICard(
        title: 'First Visit Resolved',
        value: summary.firstVisitResolvedRate,
        icon: Icons.verified_outlined,
        iconColor: AppColors.green500,
        iconBgColor: AppColors.green100,
      ),
      KPICard(
        title: 'Avg Turnaround',
        value: '${summary.averageTurnaroundHours}h',
        icon: Icons.timer_outlined,
        iconColor: AppColors.orange500,
        iconBgColor: AppColors.orange100,
      ),
      KPICard(
        title: 'Satisfaction',
        value: summary.averageSatisfactionScore.toStringAsFixed(1),
        showStar: true,
        icon: Icons.sentiment_satisfied_alt,
        iconColor: Colors.purple.shade500,
        iconBgColor: Colors.purple.shade50,
      ),
    ];

    if (isMobile) {
      return GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 1.4,
        children: cards,
      );
    }

    return Row(
      children: cards.map((c) => Expanded(child: Padding(padding: const EdgeInsets.only(right: 16), child: c))).toList(),
    );
  }

  Widget _buildCategoryBreakdown(TextTheme textTheme, bool isMobile) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Request Category Breakdown',
            style: textTheme.titleMedium?.copyWith(fontSize: 16, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 20),
          if (isMobile)
            Column(
              children: report.categoryBreakdown.map((e) => _buildCategoryItem(e)).toList(),
            )
          else
            Wrap(
              spacing: 32,
              runSpacing: 20,
              children: report.categoryBreakdown.map((e) => SizedBox(width: 200, child: _buildCategoryItem(e))).toList(),
            ),
        ],
      ),
    );
  }

  Widget _buildCategoryItem(CategoryBreakdown item) {
    final color = Color(int.parse(item.color.replaceFirst('#', '0xFF')));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(item.category, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.navy900)),
            Text('${item.percentage.toInt()}%', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.ink600)),
          ],
        ),
        const SizedBox(height: 8),
        Stack(
          children: [
            Container(height: 6, decoration: BoxDecoration(color: AppColors.line, borderRadius: BorderRadius.circular(3))),
            FractionallySizedBox(
              widthFactor: item.percentage / 100,
              child: Container(height: 6, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(3))),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text('${item.count} Requests', style: const TextStyle(fontSize: 11, color: AppColors.ink400)),
      ],
    );
  }

  Widget _buildServiceHistory(TextTheme textTheme, bool isMobile, BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Detailed Service History',
            style: textTheme.titleMedium?.copyWith(fontSize: 16, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 20),
          if (isMobile)
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: report.serviceHistory.length,
              separatorBuilder: (context, index) => const Divider(height: 32),
              itemBuilder: (context, index) => _buildServiceHistoryMobileCard(report.serviceHistory[index], context),
            )
          else
            _buildServiceHistoryTable(context),
        ],
      ),
    );
  }

  Widget _buildServiceHistoryTable(BuildContext context) {
    return Table(
      columnWidths: const {
        0: FlexColumnWidth(1),
        1: FlexColumnWidth(1.5),
        2: FlexColumnWidth(1),
        3: FlexColumnWidth(1),
        4: FlexColumnWidth(1),
        5: FlexColumnWidth(1.2),
        6: FlexColumnWidth(0.8),
        7: FlexColumnWidth(0.5),
      },
      children: [
        TableRow(
          decoration: BoxDecoration(color: AppColors.bg.withValues(alpha: 0.5)),
          children: const [
            _HistoryHeader('TICKET'),
            _HistoryHeader('PRODUCT'),
            _HistoryHeader('RESOLVED'),
            _HistoryHeader('TAT'),
            _HistoryHeader('TECH'),
            _HistoryHeader('DEALER'),
            _HistoryHeader('RATING'),
            _HistoryHeader(''),
          ],
        ),
        ...report.serviceHistory.map((item) => TableRow(
              children: [
                _HistoryCell('#${item.ticketNumber}', isBold: true),
                _HistoryCell(item.product),
                _HistoryCell(item.resolvedDate),
                _HistoryCell(item.turnaroundTime),
                _HistoryCell(item.technicianName),
                _HistoryCell(item.dealerName),
                _RatingCell(rating: item.ratingGiven),
                IconButton(
                  onPressed: () => _handleDownload(context),
                  icon: const Icon(Icons.file_download_outlined, size: 18, color: AppColors.blue500),
                ),
              ],
            )),
      ],
    );
  }

  Widget _buildServiceHistoryMobileCard(ServiceHistoryItem item, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('#${item.ticketNumber}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.navy900)),
            IconButton(
              onPressed: () => _handleDownload(context),
              icon: const Icon(Icons.file_download_outlined, size: 20, color: AppColors.blue500),
            ),
          ],
        ),
        const SizedBox(height: 8),
        _mobileInfoRow('Product', item.product),
        _mobileInfoRow('Resolved', item.resolvedDate),
        _mobileInfoRow('Turnaround', item.turnaroundTime),
        _mobileInfoRow('Technician', item.technicianName),
        _mobileInfoRow('Dealer', item.dealerName),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Rating Given', style: TextStyle(color: AppColors.ink400, fontSize: 12)),
            Row(
              children: List.generate(5, (i) => Icon(Icons.star, size: 14, color: i < item.ratingGiven ? Colors.orange : AppColors.line)),
            ),
          ],
        ),
      ],
    );
  }

  Widget _mobileInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: AppColors.ink400, fontSize: 12)),
          Text(value, style: const TextStyle(color: AppColors.navy900, fontWeight: FontWeight.bold, fontSize: 12)),
        ],
      ),
    );
  }
}

class _HistoryHeader extends StatelessWidget {
  final String label;
  const _HistoryHeader(this.label);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      child: Text(label, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: AppColors.ink400, letterSpacing: 0.5)),
    );
  }
}

class _HistoryCell extends StatelessWidget {
  final String text;
  final bool isBold;
  const _HistoryCell(this.text, {this.isBold = false});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      child: Text(text, style: TextStyle(fontSize: 12, color: isBold ? AppColors.navy900 : AppColors.ink600, fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
    );
  }
}

class _RatingCell extends StatelessWidget {
  final int rating;
  const _RatingCell({required this.rating});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      child: Row(
        children: List.generate(5, (i) => Icon(Icons.star, size: 12, color: i < rating ? Colors.orange : AppColors.line)),
      ),
    );
  }
}

class _TimeframeButton extends StatelessWidget {
  final String label;
  final String timeframe;
  final bool isActive;
  const _TimeframeButton({required this.label, required this.timeframe, required this.isActive});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.read<DashboardCubit>().loadReport(timeframe: timeframe),
      borderRadius: BorderRadius.circular(6),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: isActive ? AppColors.blue100 : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isActive ? AppColors.blue500 : AppColors.ink600,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}
