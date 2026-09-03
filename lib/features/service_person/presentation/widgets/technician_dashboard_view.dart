import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/kpi_card.dart';
import '../../../../core/widgets/section_header.dart';
import '../../../../core/widgets/status_pill.dart';
import '../../data/models/technician_model.dart';

class TechnicianDashboardView extends StatelessWidget {
  final TechnicianProfile profile;
  final VoidCallback onOpenQueue;
  final Function(String ticketId) onViewTicket;

  const TechnicianDashboardView({
    super.key,
    required this.profile,
    required this.onOpenQueue,
    required this.onViewTicket,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildProfileHeader(),
          const SizedBox(height: 24),
          _buildMetricsGrid(),
          const SizedBox(height: 24),
          _buildActiveWorkOrders(),
          const SizedBox(height: 24),
          _buildSkillCertifications(),
        ],
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.navy900,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 35,
            backgroundColor: AppColors.amber500,
            child: Text(
              profile.technician.name.split(' ').map((e) => e[0]).join(''),
              style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      profile.technician.name,
                      style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.white.withOpacity(0.3)),
                      ),
                      child: const Text(
                        'Field Technician',
                        style: TextStyle(color: AppColors.green500, fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      profile.technician.dealerName,
                      style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 14),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      '•  ${profile.technician.phone}',
                      style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 14),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      '•  ${profile.technician.email}',
                      style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 14),
                    ),
                  ],
                ),
              ],
            ),
          ),
          _buildStatusSwitcher(),
        ],
      ),
    );
  }

  Widget _buildStatusSwitcher() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.0),
            child: Text('Status:', style: TextStyle(color: Colors.white70, fontSize: 13)),
          ),
          _buildStatusItem('Available', isSelected: profile.technician.availabilityStatus == 'Available'),
          _buildStatusItem('On job', isSelected: profile.technician.availabilityStatus == 'On job'),
          _buildStatusItem('Offline', isSelected: profile.technician.availabilityStatus == 'Offline'),
        ],
      ),
    );
  }

  Widget _buildStatusItem(String label, {bool isSelected = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.green500 : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.white60,
          fontSize: 13,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }

  Widget _buildMetricsGrid() {
    return Row(
      children: [
        Expanded(
          child: KPICard(
            title: 'Active Assignments',
            value: profile.metrics.activeJobsCount.toString(),
            subtitle: '${profile.metrics.criticalJobsCount} high priority',
            subtitleColor: AppColors.amber500,
            icon: Icons.build_outlined,
            iconColor: AppColors.blue500,
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: KPICard(
            title: 'Resolved Overall',
            value: profile.metrics.completedJobsCount.toString(),
            subtitle: '98.2% on-time resolution',
            subtitleColor: AppColors.green500,
            icon: Icons.check_circle_outline,
            iconColor: AppColors.green500,
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: KPICard(
            title: 'Customer Rating',
            value: profile.metrics.averageRating.toString(),
            subtitle: 'Based on recent customer reviews',
            icon: Icons.star_border,
            iconColor: AppColors.amber500,
            showStar: true,
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: KPICard(
            title: 'First-Time Fix Rate',
            value: '${profile.metrics.firstTimeFixRate}%',
            subtitle: 'Zero repeat complaints',
            subtitleColor: AppColors.purple500,
            icon: Icons.workspace_premium_outlined,
            iconColor: AppColors.purple500,
          ),
        ),
      ],
    );
  }

  Widget _buildActiveWorkOrders() {
    return AppCard(
      padding: const EdgeInsets.all(24),
      borderRadius: 16,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(
            title: 'Active Work Orders',
            subtitle: 'Field jobs currently assigned for inspection and repair',
            actions: [
              TextButton.icon(
                onPressed: onOpenQueue,
                icon: const Text('Open Queue'),
                label: const Icon(Icons.chevron_right, size: 18),
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.navy900,
                  textStyle: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          if (profile.assignedJobs.isEmpty)
            _buildEmptyWorkOrders()
          else
            Column(
              children: profile.assignedJobs.map((job) => _buildJobItem(job)).toList(),
            ),
        ],
      ),
    );
  }

  Widget _buildEmptyWorkOrders() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 40),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.line, style: BorderStyle.none),
      ),
      child: const Column(
        children: [
          CircleAvatar(backgroundColor: AppColors.green100, child: Icon(Icons.check, color: AppColors.green500)),
          SizedBox(height: 16),
          Text('All caught up!', style: TextStyle(color: AppColors.ink900, fontSize: 16, fontWeight: FontWeight.bold)),
          SizedBox(height: 4),
          Text('No pending field complaints assigned to you right now.', style: TextStyle(color: AppColors.ink400, fontSize: 13)),
        ],
      ),
    );
  }

  Widget _buildJobItem(AssignedJob job) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.bg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.line),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          StatusPill.priority(job.priority),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(job.ticketNumber, style: const TextStyle(color: AppColors.ink400, fontSize: 12, fontWeight: FontWeight.bold)),
                    Row(
                      children: [
                        if (job.requiredSkillMatch.isNotEmpty) ...[
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(color: AppColors.blue100, borderRadius: BorderRadius.circular(4)),
                            child: Text(job.requiredSkillMatch, style: const TextStyle(color: AppColors.blue500, fontSize: 10, fontWeight: FontWeight.bold)),
                          ),
                          const SizedBox(width: 8),
                        ],
                        Text(job.status, style: const TextStyle(color: AppColors.blue500, fontSize: 12, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(job.title, style: const TextStyle(color: AppColors.ink900, fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(Icons.person_outline, size: 14, color: AppColors.ink400),
                    const SizedBox(width: 6),
                    Text(job.customerName, style: const TextStyle(color: AppColors.ink600, fontSize: 13)),
                    const SizedBox(width: 20),
                    const Icon(Icons.location_on_outlined, size: 14, color: AppColors.ink400),
                    const SizedBox(width: 6),
                    Expanded(child: Text(job.siteLocation, style: const TextStyle(color: AppColors.ink600, fontSize: 13), overflow: TextOverflow.ellipsis)),
                    const SizedBox(width: 20),
                    const Icon(Icons.calendar_today_outlined, size: 14, color: AppColors.ink400),
                    const SizedBox(width: 6),
                    Text('${job.createdAt.day}/${job.createdAt.month}/${job.createdAt.year}', style: const TextStyle(color: AppColors.ink600, fontSize: 13)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 20),
          ElevatedButton(
            onPressed: () => onViewTicket(job.ticketId),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.navy900,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('View Details'),
          ),
        ],
      ),
    );
  }

  Widget _buildSkillCertifications() {
    return AppCard(
      padding: const EdgeInsets.all(24),
      borderRadius: 16,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(
            title: 'Tagged Skill Certifications',
            subtitle: 'Service categories authorized for your technician profile',
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: profile.technician.skills.map((skill) => _buildSkillBadge(skill)).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSkillBadge(String skill) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.bg,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.line),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.check, color: AppColors.navy900, size: 14),
          const SizedBox(width: 8),
          Text(skill, style: const TextStyle(color: AppColors.ink900, fontSize: 13, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
