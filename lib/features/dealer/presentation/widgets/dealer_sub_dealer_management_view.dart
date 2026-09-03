import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_theme.dart';
import '../bloc/dealer_dashboard_cubit.dart';
import '../bloc/dealer_dashboard_state.dart';
import '../../data/models/sub_dealer_model.dart';
import 'add_sub_dealer_dialog.dart';

class DealerSubDealerManagementView extends StatelessWidget {
  const DealerSubDealerManagementView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DealerDashboardCubit, DealerDashboardState>(
      builder: (context, state) {
        if (state.isSubDealersLoading && state.subDealers == null) {
          return const Center(child: CircularProgressIndicator());
        }

        final subDealers = state.subDealers ?? [];

        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSummaryHeader(subDealers),
              const SizedBox(height: 24),
              _buildSubDealersList(context, subDealers),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSummaryHeader(List<SubDealer> subDealers) {
    final activeCount = subDealers.where((s) => s.isActive).length;
    final totalTechs = subDealers.fold(0, (sum, item) => sum + item.technicianCount);
    final avgRating = subDealers.isEmpty 
        ? 0.0 
        : subDealers.fold(0.0, (sum, item) => sum + item.rating) / subDealers.length;

    return Row(
      children: [
        Expanded(
          child: _SummaryCard(
            title: 'Sub-Dealer Branches',
            value: subDealers.length.toString(),
            subtitle: '$activeCount Active branches',
            icon: Icons.account_tree_outlined,
            color: Colors.blue,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _SummaryCard(
            title: 'Branch Technicians',
            value: totalTechs.toString(),
            subtitle: 'Managed across branches',
            icon: Icons.engineering_outlined,
            color: Colors.purple,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _SummaryCard(
            title: 'Avg Branch Rating',
            value: '${avgRating.toStringAsFixed(1)} ★',
            subtitle: 'Customer satisfaction',
            icon: Icons.star_outline,
            color: Colors.orange,
          ),
        ),
      ],
    );
  }

  Widget _buildSubDealersList(BuildContext context, List<SubDealer> subDealers) {
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
                      'Branch & Sub-Dealer Management',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.navy900,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Create and monitor your service branches and their performance',
                      style: TextStyle(fontSize: 12, color: AppColors.ink400),
                    ),
                  ],
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (dialogContext) => BlocProvider.value(
                        value: context.read<DealerDashboardCubit>(),
                        child: const AddSubDealerDialog(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Add New Branch'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.navy900,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          _buildTableHeader(),
          const Divider(height: 1),
          if (subDealers.isEmpty)
            const Padding(
              padding: EdgeInsets.all(48.0),
              child: Center(
                child: Text(
                  'No branches found. Start by adding your first sub-dealer.',
                  style: TextStyle(color: AppColors.ink400),
                ),
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: subDealers.length,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) {
                return _buildSubDealerRow(subDealers[index]);
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
          Expanded(flex: 3, child: _HeaderCell('BRANCH NAME')),
          Expanded(flex: 2, child: _HeaderCell('LOCATION')),
          Expanded(flex: 2, child: _HeaderCell('TECHNICIANS')),
          Expanded(flex: 2, child: _HeaderCell('MANAGER')),
          Expanded(flex: 1, child: _HeaderCell('RATING')),
          Expanded(flex: 1, child: _HeaderCell('STATUS')),
        ],
      ),
    );
  }

  Widget _buildSubDealerRow(SubDealer subDealer) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: AppColors.blue100,
                  child: Text(
                    subDealer.branchName.substring(0, 1),
                    style: const TextStyle(color: AppColors.blue500, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      subDealer.branchName,
                      style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.navy900, fontSize: 13),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'ID: ${subDealer.id}',
                      style: const TextStyle(color: AppColors.ink400, fontSize: 11),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              subDealer.location,
              style: const TextStyle(color: AppColors.ink600, fontSize: 12),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              '${subDealer.technicianCount} Personnel',
              style: const TextStyle(color: AppColors.navy900, fontWeight: FontWeight.w600, fontSize: 12),
            ),
          ),
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  subDealer.managerName,
                  style: const TextStyle(color: AppColors.navy900, fontSize: 12, fontWeight: FontWeight.bold),
                ),
                Text(
                  subDealer.contactNumber,
                  style: const TextStyle(color: AppColors.ink400, fontSize: 11),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Row(
              children: [
                const Icon(Icons.star, color: Colors.orange, size: 14),
                const SizedBox(width: 4),
                Text(
                  subDealer.rating.toString(),
                  style: const TextStyle(color: AppColors.navy900, fontWeight: FontWeight.bold, fontSize: 12),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: _buildStatusPill(subDealer.isActive),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusPill(bool isActive) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isActive ? Colors.green.shade50 : Colors.red.shade50,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        isActive ? 'Active' : 'Inactive',
        style: TextStyle(
          color: isActive ? Colors.green.shade700 : Colors.red.shade700,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final IconData icon;
  final Color color;

  const _SummaryCard({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
    required this.color,
  });

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
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(color: AppColors.ink400, fontSize: 12, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(color: AppColors.navy900, fontSize: 20, fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );
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
        fontSize: 10,
        fontWeight: FontWeight.w900,
        color: AppColors.ink400,
        letterSpacing: 0.5,
      ),
    );
  }
}
