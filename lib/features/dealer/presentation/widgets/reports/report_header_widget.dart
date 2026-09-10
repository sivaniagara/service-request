import 'package:flutter/material.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../data/models/dealer_report_model.dart';

class ReportHeaderWidget extends StatelessWidget {
  final ReportHeader header;

  const ReportHeaderWidget({
    super.key,
    required this.header,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isNarrow = constraints.maxWidth < 480;

        final titleBlock = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              header.title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.navy900,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              header.subtitle,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.ink600,
              ),
            ),
          ],
        );

        final timeframeSelector = Container(
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            color: AppColors.bg,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: header.availableTimeframes.map((timeframe) {
              final isActive = timeframe == header.selectedTimeframe;
              return GestureDetector(
                onTap: () {},
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: isActive ? Colors.white : Colors.transparent,
                    borderRadius: BorderRadius.circular(6),
                    boxShadow: isActive
                        ? [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      )
                    ]
                        : null,
                  ),
                  child: Text(
                    timeframe,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
                      color: isActive ? AppColors.navy900 : AppColors.ink400,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        );

        final exportButton = ElevatedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.file_download_outlined, size: 16),
          label: const Text('Export'),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.navy900,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            elevation: 0,
          ),
        );

        if (isNarrow) {
          // Timeframe pills + Export button next to a title Column
          // overflow well before 480px — stack everything instead.
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              titleBlock,
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(child: SingleChildScrollView(scrollDirection: Axis.horizontal, child: timeframeSelector)),
                  const SizedBox(width: 10),
                  exportButton,
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
                timeframeSelector,
                const SizedBox(width: 12),
                exportButton,
              ],
            ),
          ],
        );
      },
    );
  }
}