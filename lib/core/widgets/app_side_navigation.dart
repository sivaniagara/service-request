import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class NavItem {
  final IconData icon;
  final String label;
  final String? badge;
  final bool isActive;
  final VoidCallback onTap;

  NavItem({
    required this.icon,
    required this.label,
    this.badge,
    required this.isActive,
    required this.onTap,
  });
}

class AppSideNavigation extends StatelessWidget {
  final String brandName;
  final String? brandSubtext;
  final List<NavItem> items;
  final VoidCallback onProfileTap;
  final VoidCallback onLogoutTap;

  const AppSideNavigation({
    super.key,
    required this.brandName,
    this.brandSubtext,
    required this.items,
    required this.onProfileTap,
    required this.onLogoutTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      color: Colors.white,
      child: Column(
        children: [
          _buildHeader(),
          const Divider(height: 1, color: AppColors.line),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              itemCount: items.length,
              separatorBuilder: (context, index) => const SizedBox(height: 8),
              itemBuilder: (context, index) => _buildNavItem(items[index]),
            ),
          ),
          _buildFooter(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.navy900,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.bolt, color: Colors.white, size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  brandName,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.navy900,
                  ),
                ),
              ),
            ],
          ),
          if (brandSubtext != null) ...[
            const SizedBox(height: 8),
            Text(
              brandSubtext!,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.ink400,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildNavItem(NavItem item) {
    return InkWell(
      onTap: item.onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: item.isActive ? AppColors.navy900 : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(
              item.icon,
              size: 22,
              color: item.isActive ? Colors.white : AppColors.ink600,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                item.label,
                style: TextStyle(
                  color: item.isActive ? Colors.white : AppColors.ink600,
                  fontSize: 15,
                  fontWeight: item.isActive ? FontWeight.w600 : FontWeight.w500,
                ),
              ),
            ),
            if (item.badge != null)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: item.isActive ? Colors.white.withOpacity(0.2) : AppColors.blue100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  item.badge!,
                  style: TextStyle(
                    color: item.isActive ? Colors.white : AppColors.blue500,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: AppColors.line)),
      ),
      child: Column(
        children: [
          _buildFooterItem(
            icon: Icons.person_outline,
            label: 'My Profile',
            onTap: onProfileTap,
          ),
          const SizedBox(height: 4),
          _buildFooterItem(
            icon: Icons.logout_rounded,
            label: 'Logout',
            onTap: onLogoutTap,
            isDestructive: true,
          ),
        ],
      ),
    );
  }

  Widget _buildFooterItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Icon(
              icon,
              size: 20,
              color: isDestructive ? AppColors.red500 : AppColors.ink600,
            ),
            const SizedBox(width: 16),
            Text(
              label,
              style: TextStyle(
                color: isDestructive ? AppColors.red500 : AppColors.ink600,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
