import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/theme/app_theme.dart';
import '../widgets/auth_layout.dart';

enum UserRole { customer, dealer, admin }

class ProfileSetupPage extends StatefulWidget {
  const ProfileSetupPage({super.key});

  @override
  State<ProfileSetupPage> createState() => _ProfileSetupPageState();
}

class _ProfileSetupPageState extends State<ProfileSetupPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  UserRole _selectedRole = UserRole.customer;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AuthLayout(
      title: 'Complete Profile',
      subtitle: 'Just a few more details to get you started',
      illustrationTitle: 'Welcome!',
      illustrationSubtitle: 'Fill in your details to experience the best service management platform.',
      illustrationPath: 'assets/json/welcome.json',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Full Name',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.ink400,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _nameController,
            decoration: InputDecoration(
              hintText: 'Enter your full name',
              prefixIcon: const Icon(Icons.person_outline, color: AppColors.ink400),
              border: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: AppColors.navy900),
              ),
              filled: false,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Email Address',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.ink400,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _emailController,
            decoration: InputDecoration(
              hintText: 'Enter your email id',
              prefixIcon: const Icon(Icons.email_outlined, color: AppColors.ink400),
              border: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: AppColors.navy900),
              ),
              filled: false,
            ),
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 24),
          const Text(
            'Select Role',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.ink400,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<UserRole>(
            value: _selectedRole,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.admin_panel_settings_outlined, color: AppColors.ink400),
              border: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: AppColors.navy900),
              ),
              filled: false,
            ),
            items: const [
              DropdownMenuItem(value: UserRole.customer, child: Text('Customer')),
              DropdownMenuItem(value: UserRole.dealer, child: Text('Dealer')),
              DropdownMenuItem(value: UserRole.admin, child: Text('Admin')),
            ],
            onChanged: (value) {
              setState(() {
                _selectedRole = value!;
              });
            },
          ),
          const SizedBox(height: 48),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: () {
                switch (_selectedRole) {
                  case UserRole.admin:
                    context.go(RouteNames.adminDashboard);
                    break;
                  case UserRole.dealer:
                    context.go(RouteNames.dealerDashboard);
                    break;
                  case UserRole.customer:
                    context.go(RouteNames.customerDashboard);
                    break;
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.navy900,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28),
                ),
                elevation: 0,
              ),
              child: const Text(
                'Complete Registration',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
