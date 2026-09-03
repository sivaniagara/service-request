import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/kpi_card.dart';
import '../../../../core/widgets/section_header.dart';
import '../../../../core/widgets/status_pill.dart';
import '../../data/models/dealer_technician_model.dart';
import 'add_technician_dialog.dart';

class DealerTeamView extends StatelessWidget {
  final DealerServiceTeamModel? data;
  const DealerTeamView({super.key, this.data});

  @override
  Widget build(BuildContext context) {
    if (data == null) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildStatCards(),
        const SizedBox(height: 24),
        _buildTeamTable(context),
      ],
    );
  }

  Widget _buildStatCards() {
    final summary = data!.summary;
    return Row(
      children: [
        Expanded(
          child: KPICard(
            title: 'Total Service Persons',
            value: summary.totalServicePersons.toString(),
            subtitle: 'In Green Sprout Agro',
            subtitleColor: AppColors.purple500,
            icon: Icons.person_outline,
            iconColor: AppColors.purple500,
            iconBgColor: AppColors.purple100,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: KPICard(
            title: 'Requests Handled',
            value: summary.requestsHandled.toString(),
            subtitle: 'This month',
            icon: Icons.build_circle_outlined,
            iconColor: AppColors.blue500,
            iconBgColor: AppColors.blue100,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: KPICard(
            title: 'Currently Assigned',
            value: summary.currentlyAssigned.toString(),
            subtitle: 'Active on field',
            subtitleColor: AppColors.orange500,
            icon: Icons.folder_open_outlined,
            iconColor: AppColors.orange500,
            iconBgColor: AppColors.orange100,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: KPICard(
            title: 'Avg Tech Rating',
            value: '${summary.avgTechRating}★',
            subtitle: 'High performance',
            subtitleColor: AppColors.green500,
            icon: Icons.sentiment_satisfied_alt,
            iconColor: AppColors.green500,
            iconBgColor: AppColors.green100,
          ),
        ),
      ],
    );
  }

  Widget _buildTeamTable(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(24),
      borderRadius: 16,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(
            title: 'Your Service Team',
            subtitle: 'Manage field technicians, skill tags, and track active assignments',
            actions: [
              ElevatedButton.icon(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => const AddTechnicianDialog(),
                  );
                },
                icon: const Icon(Icons.add, size: 16),
                label: const Text('Add Service Person'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.navy900,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  textStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          _buildTableHeader(),
          const Divider(height: 1),
          ...data!.technicians.map((tech) => _buildTechRow(context, tech)),
        ],
      ),
    );
  }

  Widget _buildTableHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: AppColors.bg.withValues(alpha: 0.3),
      child: Row(
        children: const [
          Expanded(flex: 3, child: _HeaderCell('SERVICE PERSON')),
          Expanded(flex: 3, child: _HeaderCell('TAGGED SKILLS')),
          Expanded(flex: 2, child: _HeaderCell('REQUESTS HANDLED')),
          Expanded(flex: 2, child: _HeaderCell('CURRENTLY ASSIGNED')),
          Expanded(flex: 1, child: _HeaderCell('RATING')),
          Expanded(flex: 1, child: _HeaderCell('STATUS')),
        ],
      ),
    );
  }

  Widget _buildTechRow(BuildContext context, DealerTechnician tech) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.line)),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: AppColors.navy900,
                  child: Text(
                    _getInitials(tech.name),
                    style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tech.name,
                      style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.navy900, fontSize: 13),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      tech.phone,
                      style: const TextStyle(color: AppColors.ink400, fontSize: 11),
                    ),
                    if (tech.travelDistance != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        '${tech.travelDistance} • ${tech.estimatedEta ?? "N/A"}',
                        style: const TextStyle(color: AppColors.blue500, fontSize: 10, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            flex: 3,
            child: Wrap(
              spacing: 6,
              runSpacing: 4,
              children: tech.skills.map((s) => _buildSkillChip(s)).toList(),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              tech.totalResolved.toString(),
              style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.navy900, fontSize: 13),
            ),
          ),
          Expanded(
            flex: 2,
            child: tech.currentlyAssignedCount > 0
                ? Text(
                    '${tech.currentlyAssignedCount} active',
                    style: const TextStyle(color: AppColors.amber500, fontWeight: FontWeight.bold, fontSize: 13),
                  )
                : const Text(
                    '0',
                    style: TextStyle(color: AppColors.ink400, fontSize: 13),
                  ),
          ),
          Expanded(
            flex: 1,
            child: Row(
              children: [
                Text(
                  '${tech.rating}',
                  style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.amber500, fontSize: 13),
                ),
                const Icon(Icons.star, color: AppColors.amber500, size: 12),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: StatusPill(
              label: tech.availabilityStatus,
              color: tech.availabilityStatus.toLowerCase() == 'available' ? AppColors.green500 : tech.availabilityStatus.toLowerCase() == 'on job' ? AppColors.blue500 : AppColors.ink600,
              backgroundColor: tech.availabilityStatus.toLowerCase() == 'available' ? AppColors.green100 : tech.availabilityStatus.toLowerCase() == 'on job' ? AppColors.blue100 : AppColors.bg,
              borderRadius: 6,
              fontSize: 10,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            ),
          ),
        ],
      ),
    );
  }

  String _getInitials(String name) {
    final parts = name.split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return parts[0][0].toUpperCase();
  }

  Widget _buildSkillChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.blue100.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.blue100),
      ),
      child: Text(
        label,
        style: const TextStyle(fontSize: 10, color: AppColors.blue500, fontWeight: FontWeight.w600),
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
        fontSize: 11,
        fontWeight: FontWeight.w900,
        color: AppColors.ink400,
        letterSpacing: 0.5,
      ),
    );
  }
}