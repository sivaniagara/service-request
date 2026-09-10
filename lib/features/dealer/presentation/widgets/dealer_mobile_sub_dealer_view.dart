import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_theme.dart';
import '../bloc/dealer_dashboard_cubit.dart';
import '../bloc/dealer_dashboard_state.dart';
import '../../data/models/sub_dealer_model.dart';

/// Mobile-native version of [DealerSubDealerManagementView], replacing
/// the 5-column desktop table (BRANCH NAME / LOCATION / TECHNICIANS /
/// RATING / STATUS) with a compact stat strip and branch cards.
class DealerMobileSubDealerView extends StatelessWidget {
  const DealerMobileSubDealerView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DealerDashboardCubit, DealerDashboardState>(
      builder: (context, state) {
        if (state.isSubDealersLoading && state.subDealerData == null) {
          return const Center(child: CircularProgressIndicator());
        }

        final data = state.subDealerData;
        final summary = data?.summary;
        final branches = data?.branches ?? [];

        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 6),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.line),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: _SummaryCell(
                        icon: Icons.account_tree_outlined,
                        value: (summary?.totalSubDealerBranches ?? branches.length).toString(),
                        label: 'Branches',
                        color: Colors.blue,
                      ),
                    ),
                    _divider(),
                    Expanded(
                      child: _SummaryCell(
                        icon: Icons.engineering_outlined,
                        value: (summary?.totalBranchTechnicians ?? 0).toString(),
                        label: 'Technicians',
                        color: Colors.purple,
                      ),
                    ),
                    _divider(),
                    Expanded(
                      child: _SummaryCell(
                        icon: Icons.star_outline,
                        value: summary != null ? '${summary.avgBranchRating.toStringAsFixed(1)}★' : '- ★',
                        label: 'Avg. Rating',
                        color: Colors.orange,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Branch & Sub-Dealer Management',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w900, color: AppColors.navy900),
              ),
              const SizedBox(height: 4),
              const Text(
                'Create and monitor your service branches',
                style: TextStyle(fontSize: 11.5, color: AppColors.ink400),
              ),
              const SizedBox(height: 16),
              if (branches.isEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(28),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.line),
                  ),
                  child: const Center(
                    child: Text(
                      'No branches found. Tap "Add Branch" to create your first sub-dealer.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: AppColors.ink400, fontSize: 12.5),
                    ),
                  ),
                )
              else
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: branches.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 12),
                  itemBuilder: (context, index) => _BranchCard(branch: branches[index]),
                ),
              const SizedBox(height: 80),
            ],
          ),
        );
      },
    );
  }

  Widget _divider() => Container(width: 1, height: 36, color: AppColors.line);
}

class _BranchCard extends StatelessWidget {
  final SubDealerBranch branch;
  const _BranchCard({required this.branch});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.line),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: AppColors.blue100,
                child: Text(
                  branch.branchName.isNotEmpty ? branch.branchName.substring(0, 1) : '?',
                  style: const TextStyle(color: AppColors.blue500, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      branch.branchName,
                      style: const TextStyle(fontWeight: FontWeight.w900, color: AppColors.navy900, fontSize: 14),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      'Code: ${branch.dealerCode}',
                      style: const TextStyle(color: AppColors.ink400, fontSize: 11),
                    ),
                  ],
                ),
              ),
              _StatusPill(isActive: branch.isActive),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.location_on_outlined, size: 13, color: AppColors.ink400),
              const SizedBox(width: 5),
              Expanded(
                child: Text(
                  branch.location,
                  style: const TextStyle(color: AppColors.ink600, fontSize: 12),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 12),
              const Icon(Icons.phone_android_outlined, size: 13, color: AppColors.ink400),
              const SizedBox(width: 5),
              Text(
                branch.managerPhone,
                style: const TextStyle(color: AppColors.ink600, fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    const Icon(Icons.engineering_outlined, size: 13, color: AppColors.navy900),
                    const SizedBox(width: 5),
                    Text(
                      '${branch.techniciansCount} Personnel',
                      style: const TextStyle(color: AppColors.navy900, fontWeight: FontWeight.w700, fontSize: 12),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  const Icon(Icons.star, color: Colors.orange, size: 14),
                  const SizedBox(width: 4),
                  Text(
                    branch.rating.toString(),
                    style: const TextStyle(color: AppColors.navy900, fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  final bool isActive;
  const _StatusPill({required this.isActive});

  @override
  Widget build(BuildContext context) {
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
          fontSize: 9.5,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _SummaryCell extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;

  const _SummaryCell({required this.icon, required this.value, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(height: 6),
        Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: AppColors.navy900)),
        const SizedBox(height: 2),
        Text(label, style: const TextStyle(fontSize: 9, color: AppColors.ink400, fontWeight: FontWeight.w700)),
      ],
    );
  }
}