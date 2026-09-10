import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/filter_chip_item.dart';
import '../../../../core/widgets/kpi_card.dart';
import '../../../../core/widgets/status_pill.dart';
import '../../data/models/technician_report_model.dart';

class TechnicianReportsView extends StatelessWidget {
  final TechnicianReportData reportData;
  final List<TechnicianHistoryItem> history;

  const TechnicianReportsView({
    super.key,
    required this.reportData,
    required this.history,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isNarrow = constraints.maxWidth < 700;
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(isNarrow),
              const SizedBox(height: 24),
              _buildKPIsRow(isNarrow),
              const SizedBox(height: 24),
              if (isNarrow)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildServiceCategories(),
                    const SizedBox(height: 24),
                    _buildCustomerFeedback(),
                  ],
                )
              else
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 1, child: _buildServiceCategories()),
                    const SizedBox(width: 24),
                    Expanded(flex: 1, child: _buildCustomerFeedback()),
                  ],
                ),
              const SizedBox(height: 24),
              isNarrow ? _buildHistoryCards() : _buildHistoryTable(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader(bool isNarrow) {
    final titleBlock = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Field Technician Performance & Reports',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.navy900),
        ),
        const SizedBox(height: 4),
        Text(
          'Verified work history and benchmarks for ${reportData.technician.name}.',
          style: const TextStyle(fontSize: 12.5, color: AppColors.ink600),
        ),
      ],
    );

    final filterChips = SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: const [
          FilterChipItem(label: 'This Month', isActive: true),
          FilterChipItem(label: 'Last Month'),
          FilterChipItem(label: 'Q3 2026'),
        ],
      ),
    );

    final actionButtons = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        OutlinedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.download_outlined, size: 16),
          label: const Text('CSV', style: TextStyle(fontSize: 12)),
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.navy900,
            side: const BorderSide(color: AppColors.line),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
        ),
        const SizedBox(width: 8),
        ElevatedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.picture_as_pdf_outlined, size: 16),
          label: const Text('PDF', style: TextStyle(fontSize: 12)),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.navy900,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
        ),
      ],
    );

    if (isNarrow) {
      // Title + filter chips + two action buttons all in one Row
      // overflow well before phone width — stack them instead.
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          titleBlock,
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(child: filterChips),
              const SizedBox(width: 10),
              actionButtons,
            ],
          ),
        ],
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(child: titleBlock),
        Row(
          children: [
            filterChips,
            const SizedBox(width: 12),
            actionButtons,
          ],
        ),
      ],
    );
  }

  Widget _buildKPIsRow(bool isNarrow) {
    final cards = [
      KPICard(
        title: 'Total Resolved',
        value: reportData.kpis.totalJobsResolved.toString(),
        subtitle: '↗ +14% vs prev.',
        subtitleColor: AppColors.green500,
      ),
      KPICard(
        title: 'Avg. Turnaround',
        value: '${reportData.kpis.averageResolutionTimeHours} hrs',
        subtitle: 'Faster than target',
        subtitleColor: AppColors.green500,
      ),
      KPICard(
        title: 'CSAT Score',
        value: reportData.kpis.averageRating.toString(),
        subtitle: 'Based on ${reportData.kpis.totalReviewsCount} surveys',
        showStar: true,
      ),
      KPICard(
        title: 'First-Visit Resolution',
        value: '${reportData.kpis.firstTimeFixRatePercentage}%',
        subtitle: 'Benchmark: 82%',
        subtitleColor: AppColors.purple500,
      ),
    ];

    if (isNarrow) {
      return Column(
        children: [
          Row(
            children: [
              Expanded(child: cards[0]),
              const SizedBox(width: 12),
              Expanded(child: cards[1]),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: cards[2]),
              const SizedBox(width: 12),
              Expanded(child: cards[3]),
            ],
          ),
        ],
      );
    }

    return Row(
      children: [
        Expanded(child: cards[0]),
        const SizedBox(width: 16),
        Expanded(child: cards[1]),
        const SizedBox(width: 16),
        Expanded(child: cards[2]),
        const SizedBox(width: 16),
        Expanded(child: cards[3]),
      ],
    );
  }

  Widget _buildServiceCategories() {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Categories Handled', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.navy900)),
          const SizedBox(height: 16),
          _buildCategoryProgress('Valves & Hydraulic Actuators', 42, 18, AppColors.green500),
          const SizedBox(height: 12),
          _buildCategoryProgress('Fertigation Dosing & Flow Meters', 28, 12, AppColors.blue500),
          const SizedBox(height: 12),
          _buildCategoryProgress('Submersible Pump & Mechanical Drive', 18, 8, AppColors.orange500),
          const SizedBox(height: 12),
          _buildCategoryProgress('IoT Soil Sensors & Telemetry Hub', 12, 5, AppColors.purple500),
        ],
      ),
    );
  }

  Widget _buildCategoryProgress(String label, int percentage, int count, Color color) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.navy900)),
            Text('$percentage% ($count)', style: const TextStyle(fontSize: 11, color: AppColors.ink600)),
          ],
        ),
        const SizedBox(height: 6),
        LinearProgressIndicator(
          value: percentage / 100,
          backgroundColor: AppColors.bg,
          valueColor: AlwaysStoppedAnimation<Color>(color),
          minHeight: 6,
          borderRadius: BorderRadius.circular(3),
        ),
      ],
    );
  }

  Widget _buildCustomerFeedback() {
    final feedbackHistory = history.where((h) => h.feedbackComment != null).toList();
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Recent Feedback', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.navy900)),
          const SizedBox(height: 16),
          if (feedbackHistory.isEmpty)
            const Center(child: Text('No feedback yet.', style: TextStyle(fontSize: 12)))
          else
            ...feedbackHistory.take(2).map((item) => _buildFeedbackItem(item)).toList(),
        ],
      ),
    );
  }

  Widget _buildFeedbackItem(TechnicianHistoryItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.bg.withOpacity(0.3),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(item.customerName, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.navy900)),
              Row(
                children: List.generate(5, (index) => Icon(Icons.star, size: 12, color: index < item.rating ? Colors.orange : Colors.grey.shade300)),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            '"${item.feedbackComment}"',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 11, color: AppColors.ink600, fontStyle: FontStyle.italic),
          ),
          const SizedBox(height: 6),
          Text('Ticket #${item.ticketNumber}', style: const TextStyle(fontSize: 10, color: AppColors.ink400)),
        ],
      ),
    );
  }

  Widget _buildHistoryCards() {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Work Order History', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.navy900)),
          const SizedBox(height: 16),
          if (history.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Text('No completed work orders yet.', style: TextStyle(color: AppColors.ink400, fontSize: 12)),
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: history.length,
              separatorBuilder: (context, index) => const SizedBox(height: 10),
              itemBuilder: (context, index) => _buildHistoryCard(history[index]),
            ),
        ],
      ),
    );
  }

  Widget _buildHistoryCard(TechnicianHistoryItem item) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.bg.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  '#${item.ticketNumber}',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12.5, color: AppColors.navy900),
                ),
              ),
              StatusPill.ticketStatus(item.status),
            ],
          ),
          const SizedBox(height: 8),
          Text(item.product, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.navy900)),
          const SizedBox(height: 4),
          Text(
            item.customerName,
            style: const TextStyle(fontSize: 11.5, color: AppColors.ink600, fontWeight: FontWeight.w600),
          ),
          Text(
            item.siteLocation,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 10.5, color: AppColors.ink400),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(color: AppColors.bg, borderRadius: BorderRadius.circular(6)),
                child: Text(
                  item.supportMode.toUpperCase(),
                  style: const TextStyle(fontSize: 9.5, fontWeight: FontWeight.bold, color: AppColors.ink600),
                ),
              ),
              const Spacer(),
              Text(item.rating.toString(), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
              const Icon(Icons.star, size: 12, color: Colors.orange),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryTable() {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Work Order History', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.navy900)),
          const SizedBox(height: 16),
          Table(
            columnWidths: const {
              0: FlexColumnWidth(1),
              1: FlexColumnWidth(2),
              2: FlexColumnWidth(1.5),
              3: FlexColumnWidth(1),
              4: FlexColumnWidth(1),
              5: FlexColumnWidth(0.8),
            },
            children: [
              TableRow(
                decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: AppColors.line))),
                children: [
                  _buildTableHeaderCell('TICKET'),
                  _buildTableHeaderCell('CUSTOMER'),
                  _buildTableHeaderCell('PRODUCT'),
                  _buildTableHeaderCell('MODE'),
                  _buildTableHeaderCell('STATUS'),
                  _buildTableHeaderCell('RATE'),
                ],
              ),
              ...history.map((item) => TableRow(
                decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: AppColors.line))),
                children: [
                  _buildTableCell(Text('#${item?.ticketNumber}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11))),
                  _buildTableCell(Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item.customerName, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 11)),
                      Text(item.siteLocation, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 9, color: AppColors.ink400)),
                    ],
                  )),
                  _buildTableCell(Text(item.product, style: const TextStyle(fontSize: 11))),
                  _buildTableCell(Text(item.supportMode.toUpperCase(), style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold))),
                  _buildTableCell(StatusPill.ticketStatus(item.status)),
                  _buildTableCell(Row(
                    children: [
                      Text(item.rating.toString(), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11)),
                      const Icon(Icons.star, size: 10, color: Colors.orange),
                    ],
                  )),
                ],
              )),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTableHeaderCell(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Text(
        label,
        style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: AppColors.ink400, letterSpacing: 0.5),
      ),
    );
  }

  Widget _buildTableCell(Widget child) {
    return Padding(padding: const EdgeInsets.symmetric(vertical: 12.0), child: child);
  }
}