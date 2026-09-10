import 'package:flutter/material.dart';
import '../../../../../core/theme/app_theme.dart';

import '../../../data/models/dashboard_models.dart';

class ReportHistoryTable extends StatelessWidget {
  final List<RequestHistorySummaryItem> history;
  const ReportHistoryTable({super.key, required this.history});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Request History Summary',
          style: textTheme.titleMedium?.copyWith(color: AppColors.ink900, fontSize: 12),
        ),
        const SizedBox(height: 12),
        Table(
          columnWidths: const {
            0: FlexColumnWidth(1.2),
            1: FlexColumnWidth(1.5),
            2: FlexColumnWidth(1),
            3: FlexColumnWidth(1.5),
          },
          children: [
            TableRow(
              children: [
                _HeaderCell(label: 'TICKET'),
                _HeaderCell(label: 'CATEGORY'),
                _HeaderCell(label: 'RAISED'),
                _HeaderCell(label: 'STATUS'),
              ],
            ),
            ...history.map((item) => _buildRow(item)),
          ],
        ),
      ],
    );
  }

  TableRow _buildRow(RequestHistorySummaryItem item) {
    return TableRow(
      children: [
        _DataCell(text: '#${item.ticketNumber}', isBold: true),
        _DataCell(
          text: item.issueCategory.isNotEmpty ? item.issueCategory.first : 'General',
          isBold: false,
        ),
        _DataCell(text: item.raised),
        _StatusCell(status: item.status),
      ],
    );
  }
}

class _HeaderCell extends StatelessWidget {
  final String label;
  const _HeaderCell({required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: AppColors.ink400,
              fontSize: 9,
              letterSpacing: 0.5,
            ),
      ),
    );
  }
}

class _DataCell extends StatelessWidget {
  final String text;
  final bool isBold;
  const _DataCell({required this.text, this.isBold = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: isBold ? AppColors.ink900 : AppColors.ink600,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              fontSize: 11,
            ),
      ),
    );
  }
}

class _StatusCell extends StatelessWidget {
  final String status;
  const _StatusCell({required this.status});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: _getBgColor(status),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            status,
            style: TextStyle(
              color: _getTextColor(status),
              fontSize: 8,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Color _getBgColor(String status) {
    switch (status.toLowerCase()) {
      case 'closed':
        return AppColors.green100;
      default:
        return AppColors.blue100;
    }
  }

  Color _getTextColor(String status) {
    switch (status.toLowerCase()) {
      case 'closed':
        return AppColors.green500;
      default:
        return AppColors.blue500;
    }
  }
}
