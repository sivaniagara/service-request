import 'package:flutter/material.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../core/utils/color_utils.dart';
import '../../../data/models/dealer_report_model.dart';

class CategoryBreakdownSection extends StatelessWidget {
  final RequestsByCategory breakdown;

  const CategoryBreakdownSection({
    super.key,
    required this.breakdown,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          breakdown.title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: AppColors.navy900,
          ),
        ),
        const SizedBox(height: 16),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: breakdown.categories.length,
          separatorBuilder: (context, index) => const SizedBox(height: 16),
          itemBuilder: (context, index) {
            final category = breakdown.categories[index];
            return Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        category.name,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: AppColors.navy900,
                        ),
                      ),
                      Text(
                        category.subtitle,
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.ink400,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: Stack(
                    children: [
                      Container(
                        height: 6,
                        decoration: BoxDecoration(
                          color: AppColors.line,
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                      FractionallySizedBox(
                        widthFactor: category.count / breakdown.maxCount,
                        child: Container(
                          height: 6,
                          decoration: BoxDecoration(
                            color: ColorUtils.fromHex(category.colorHex),
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                SizedBox(
                  width: 24,
                  child: Text(
                    category.count.toString(),
                    textAlign: TextAlign.right,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: AppColors.navy900,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}
