import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../data/models/admin_ticket_detail_model.dart';

class AdminServiceHandlerInfo extends StatelessWidget {
  final List<AssignedDealerDetail> dealers;

  const AdminServiceHandlerInfo({super.key, required this.dealers});

  @override
  Widget build(BuildContext context) {
    if (dealers.isEmpty) return const SizedBox.shrink();

    return Column(
      children: dealers.map((dealer) => _buildDealerCard(context, dealer)).toList(),
    );
  }

  Widget _buildDealerCard(BuildContext context, AssignedDealerDetail dealer) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.line, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const CircleAvatar(
                backgroundColor: AppColors.navy900,
                child: Icon(Icons.storefront, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      dealer.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.navy900,
                      ),
                    ),
                    Text(
                      'Regional Dealer • ${dealer.region}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.ink400,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.phone_outlined, color: AppColors.blue500),
              ),
            ],
          ),
          if (dealer.assignedTechnician.isNotEmpty) ...[
            const SizedBox(height: 20),
            const Divider(),
            const SizedBox(height: 20),
            ...dealer.assignedTechnician.map((tech) => _buildTechnicianRow(context, tech)),
          ],
        ],
      ),
    );
  }

  Widget _buildTechnicianRow(BuildContext context, AssignedTechnicianDetail tech) {
    return Row(
      children: [
        const CircleAvatar(
          radius: 20,
          backgroundColor: AppColors.bg,
          child: Icon(Icons.engineering_outlined, color: AppColors.ink600, size: 20),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                tech.name,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.navy900,
                ),
              ),
              Row(
                children: [
                  const Icon(Icons.star, size: 12, color: Colors.orange),
                  const SizedBox(width: 4),
                  Text(
                    '${tech.rating} • ${tech.totalResolved} Resolved',
                    style: const TextStyle(fontSize: 11, color: AppColors.ink400),
                  ),
                ],
              ),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              tech.estimatedEta,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppColors.green500,
              ),
            ),
            Text(
              tech.travelDistance,
              style: const TextStyle(fontSize: 11, color: AppColors.ink400),
            ),
          ],
        ),
      ],
    );
  }
}
