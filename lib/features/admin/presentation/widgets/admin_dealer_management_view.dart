import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../data/models/admin_dealer_model.dart';
import 'admin_stat_card.dart';
import 'add_dealer_dialog.dart';

class AdminDealerManagementView extends StatelessWidget {
  final AdminDealerModel dealers;

  const AdminDealerManagementView({super.key, required this.dealers});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSummaryCards(),
          const SizedBox(height: 24),
          _buildDealersTable(context),
        ],
      ),
    );
  }

  Widget _buildSummaryCards() {
    return Row(
      children: [
        Expanded(
          child: AdminStatCard(
            title: 'Total Dealers',
            value: dealers.summary.totalDealers.toString(),
            trend: 'Authorized partners',
            trendColor: Colors.purple,
            icon: Icons.storefront_outlined,
            iconColor: Colors.purple.shade300,
            iconBgColor: Colors.purple.shade50,
          ),
        ),
        const SizedBox(width: 24),
        Expanded(
          child: AdminStatCard(
            title: 'Total Service Technicians',
            value: dealers.summary.totalTechnicians.toString(),
            trend: 'Managed under dealers',
            trendColor: Colors.orange,
            icon: Icons.people_outline,
            iconColor: Colors.orange.shade300,
            iconBgColor: Colors.orange.shade50,
          ),
        ),
        const SizedBox(width: 24),
        Expanded(
          child: AdminStatCard(
            title: 'Requests Handled',
            value: '312',
            trend: 'Total lifetime volume',
            trendColor: Colors.blue,
            icon: Icons.build_circle_outlined,
            iconColor: Colors.blue.shade300,
            iconBgColor: Colors.blue.shade50,
          ),
        ),
        const SizedBox(width: 24),
        Expanded(
          child: AdminStatCard(
            title: 'Avg Satisfaction',
            value: '${dealers.summary.avgDealerRating} ★',
            trend: 'Consistently high SLA',
            trendColor: Colors.green,
            icon: Icons.sentiment_satisfied_alt,
            iconColor: Colors.teal.shade300,
            iconBgColor: Colors.teal.shade50,
          ),
        ),
      ],
    );
  }

  Widget _buildDealersTable(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'All Registered Dealers',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.navy900,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Service person count updates dynamically as dealers add their field team',
                      style: TextStyle(fontSize: 12, color: AppColors.ink400),
                    ),
                  ],
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => const AddDealerDialog(),
                    );
                  },
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Add Dealer'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.navy900,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ],
            ),
          ),
          _buildTableHeader(),
          const Divider(height: 1),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: dealers.data.length,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final dealer = dealers.data[index];
              return _buildDealerRow(dealer);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTableHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      color: AppColors.bg.withValues(alpha: 0.3),
      child: Row(
        children: const [
          Expanded(flex: 3, child: _HeaderCell('DEALER NAME')),
          Expanded(flex: 2, child: _HeaderCell('REGION')),
          Expanded(flex: 2, child: _HeaderCell('SERVICE PERSONS')),
          Expanded(flex: 2, child: _HeaderCell('REQUESTS HANDLED')),
          Expanded(flex: 1, child: _HeaderCell('SATISFACTION')),
          Expanded(flex: 1, child: _HeaderCell('STATUS')),
          Expanded(flex: 2, child: _HeaderCell('TEAM ROSTER')),
        ],
      ),
    );
  }

  Widget _buildDealerRow(DealerData dealer) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: _getAvatarColor(dealer.name),
                  child: Text(
                    dealer.name.split(' ').map((e) => e[0]).take(2).join(),
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        dealer.name,
                        style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.navy900, fontSize: 13),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Owner: ${dealer.contactPerson.name} · ${dealer.contactPerson.phone}',
                        style: const TextStyle(color: AppColors.ink400, fontSize: 11),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              dealer.region,
              style: const TextStyle(color: AppColors.ink600, fontSize: 12),
            ),
          ),
          Expanded(
            flex: 2,
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.purple.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.person_pin_outlined, size: 14, color: Colors.purple.shade700),
                      const SizedBox(width: 4),
                      Text(
                        '${dealer.techniciansCount} Technicians',
                        style: TextStyle(color: Colors.purple.shade700, fontSize: 11, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              dealer.performance.totalTicketsResolved.toString(),
              style: const TextStyle(color: AppColors.navy900, fontWeight: FontWeight.bold, fontSize: 13),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              '${dealer.performance.rating} ★',
              style: const TextStyle(color: Colors.orange, fontWeight: FontWeight.bold, fontSize: 13),
            ),
          ),
          Expanded(
            flex: 1,
            child: _buildStatusPill(dealer.isActive),
          ),
          Expanded(
            flex: 2,
            child: TextButton(
              onPressed: () {},
              child: Text(
                'View Team (${dealer.techniciansCount}) ›',
                style: const TextStyle(color: AppColors.blue500, fontWeight: FontWeight.bold, fontSize: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusPill(bool isActive) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isActive ? Colors.green.shade50 : Colors.orange.shade50,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        isActive ? 'Active' : 'Under Review',
        style: TextStyle(
          color: isActive ? Colors.green.shade700 : Colors.orange.shade700,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Color _getAvatarColor(String name) {
    if (name.contains('Agri')) return AppColors.navy900;
    if (name.contains('Sunrise')) return Colors.blue.shade700;
    if (name.contains('AgroCare')) return Colors.orange.shade700;
    return Colors.blue.shade500;
  }
}

class _HeaderCell extends StatelessWidget {
  final String label;
  const _HeaderCell(this.label);

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w900,
        color: AppColors.ink400,
        letterSpacing: 0.5,
      ),
    );
  }
}
