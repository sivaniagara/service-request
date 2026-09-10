import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_theme.dart';
import '../../data/models/admin_dealer_model.dart';
import '../bloc/admin_dashboard_cubit.dart';
import 'admin_stat_card.dart';
import 'add_dealer_dialog.dart';
import 'package:flutter/material.dart';

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
    final totalDealers = dealers.summary?.totalDealers ?? dealers.data.length;
    final totalTechnicians = dealers.summary?.totalTechnicians ?? 0;
    final avgRating = dealers.summary?.avgDealerRating ?? 
        (dealers.data.isEmpty ? 0.0 : dealers.data.map((d) => d.performance.rating).reduce((a, b) => a + b) / dealers.data.length);

    return Row(
      children: [
        Expanded(
          child: AdminStatCard(
            title: 'Total Dealers',
            value: totalDealers.toString(),
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
            value: totalTechnicians > 0 ? totalTechnicians.toString() : 'N/A',
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
            value: dealers.data.map((d) => d.performance.totalTicketsResolved).fold(0, (a, b) => a + b).toString(),
            trend: 'Total platform volume',
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
            value: '${avgRating.toStringAsFixed(1)} ★',
            trend: 'Platform-wide rating',
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
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'All Registered Dealers',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.navy900,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Service person count updates dynamically',
                      style: TextStyle(fontSize: 11, color: AppColors.ink400),
                    ),
                  ],
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (innerContext) => BlocProvider.value(
                        value: context.read<AdminDashboardCubit>(),
                        child: const AddDealerDialog(),
                      ),
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
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      color: AppColors.bg.withValues(alpha: 0.3),
      child: Row(
        children: const [
          Expanded(flex: 3, child: _HeaderCell('DEALER NAME')),
          Expanded(flex: 2, child: _HeaderCell('REGION')),
          Expanded(flex: 3, child: _HeaderCell('CAPACITY & UTILIZATION')),
          Expanded(flex: 2, child: _HeaderCell('REQUESTS HANDLED')),
          Expanded(flex: 1, child: _HeaderCell('SATISFACTION')),
          Expanded(flex: 1, child: _HeaderCell('STATUS')),
          Expanded(flex: 2, child: _HeaderCell('OFFICE ADDRESS')),
        ],
      ),
    );
  }

  Widget _buildDealerRow(DealerData dealer) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
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
                        dealer.phone,
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
            flex: 3,
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getCapacityColor(dealer.capacity.capacityStatus).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.pie_chart_outline, size: 14, color: _getCapacityColor(dealer.capacity.capacityStatus)),
                      const SizedBox(width: 4),
                      Text(
                        '${dealer.capacity.activeAssignedTickets}/${dealer.capacity.maxConcurrentTickets} (${dealer.capacity.utilizationPercentage.toInt()}%)',
                        style: TextStyle(
                          color: _getCapacityColor(dealer.capacity.capacityStatus),
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
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
              '${dealer.performance.rating.toStringAsFixed(1)} ★',
              style: const TextStyle(color: Colors.orange, fontWeight: FontWeight.bold, fontSize: 13),
            ),
          ),
          Expanded(
            flex: 1,
            child: _buildStatusPill(dealer.isActive),
          ),
          Expanded(
            flex: 2,
            child: Text(
              dealer.officeAddress,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: AppColors.ink600, fontSize: 11),
            ),
          ),
        ],
      ),
    );
  }

  Color _getCapacityColor(String status) {
    switch (status.toLowerCase()) {
      case 'available':
        return Colors.green;
      case 'near capacity':
        return Colors.orange;
      case 'full':
        return Colors.red;
      default:
        return AppColors.ink600;
    }
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
