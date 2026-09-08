import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import '../../../../core/network/token_manager.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../injection_container.dart';
import '../../../customer/presentation/widgets/complaints/location_picker_dialog.dart';
import '../widgets/auth_layout.dart';
import '../bloc/auth_cubit.dart';
import '../bloc/auth_state.dart';

enum UserRole { customer, dealer, admin, servicePerson }

class ProfileSetupPage extends StatefulWidget {
  const ProfileSetupPage({super.key});

  @override
  State<ProfileSetupPage> createState() => _ProfileSetupPageState();
}

class _ProfileSetupPageState extends State<ProfileSetupPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();
  UserRole _selectedRole = UserRole.customer;
  AwesomeDialog? _loadingDialog;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  void _showLoading(BuildContext context) {
    _loadingDialog = AwesomeDialog(
      context: context,
      dialogType: DialogType.noHeader,
      animType: AnimType.scale,
      width: 400,
      body: const Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Updating Profile...', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
      dismissOnTouchOutside: false,
      dismissOnBackKeyPress: false,
    )..show();
  }

  void _dismissLoading() {
    _loadingDialog?.dismiss();
    _loadingDialog = null;
  }

  String _getRoleString(UserRole role) {
    switch (role) {
      case UserRole.admin: return 'Admin';
      case UserRole.dealer: return 'Dealer';
      case UserRole.servicePerson: return 'Technician';
      case UserRole.customer: return 'Customer';
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthLoading) {
          _showLoading(context);
        } else {
          _dismissLoading();
        }

        if (state is AuthProfileUpdated) {
          AwesomeDialog(
            context: context,
            dialogType: DialogType.success,
            animType: AnimType.bottomSlide,
            width: 400,
            title: 'Profile Updated',
            desc: 'Welcome to the platform! Your profile is now complete.',
            btnOkOnPress: () {
              final role = state.userData['user']?['role'];
              if (role == 'Admin') {
                context.go(RouteNames.adminDashboard);
              } else if (role == 'Dealer') {
                context.go(RouteNames.dealerDashboard);
              } else if (role == 'Technician') {
                context.go(RouteNames.technicianDashboard);
              } else {
                context.go(RouteNames.customerDashboard);
              }
            },
          ).show();
        }

        if (state is AuthError) {
          AwesomeDialog(
            context: context,
            dialogType: DialogType.error,
            animType: AnimType.bottomSlide,
            width: 400,
            title: 'Error',
            desc: state.message,
            btnOkOnPress: () {},
          ).show();
        }
      },
      builder: (context, state) {
        return AuthLayout(
          title: 'Complete Profile',
          subtitle: 'Just a few more details to get you started',
          illustrationTitle: 'Welcome!',
          illustrationSubtitle: 'Fill in your details to experience the best service management platform.',
          illustrationPath: 'assets/json/welcome.json',
          onBack: () {
            AwesomeDialog(
              context: context,
              dialogType: DialogType.warning,
              animType: AnimType.bottomSlide,
              width: 450,
              title: 'Return to Login?',
              desc: 'Are you sure you want to go back? You will need to login again.',
              btnCancelOnPress: () {},
              btnOkText: 'Yes, Logout',
              btnOkColor: AppColors.navy900,
              btnOkOnPress: () async {
                await sl<TokenManager>().deleteToken();
                if (context.mounted) {
                  context.go(RouteNames.login);
                }
              },
            ).show();
          },
          child: SingleChildScrollView(
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
                  'Address',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.ink400,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _addressController,
                  readOnly: true,
                  onTap: () async {
                    final result = await showDialog<String>(
                      context: context,
                      builder: (context) => LocationPickerDialog(initialLocation: _addressController.text),
                    );
                    if (result != null) {
                      setState(() => _addressController.text = result);
                    }
                  },
                  decoration: InputDecoration(
                    hintText: 'Select your address from map',
                    prefixIcon: const Icon(Icons.location_on_outlined, color: AppColors.ink400),
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
                // const SizedBox(height: 24),
                // const Text(
                //   'Select Role',
                //   style: TextStyle(
                //     fontSize: 14,
                //     color: AppColors.ink400,
                //     fontWeight: FontWeight.w500,
                //   ),
                // ),
                // const SizedBox(height: 8),
                // DropdownButtonFormField<UserRole>(
                //   value: _selectedRole,
                //   decoration: InputDecoration(
                //     prefixIcon: const Icon(Icons.admin_panel_settings_outlined, color: AppColors.ink400),
                //     border: UnderlineInputBorder(
                //       borderSide: BorderSide(color: Colors.grey.shade300),
                //     ),
                //     enabledBorder: UnderlineInputBorder(
                //       borderSide: BorderSide(color: Colors.grey.shade300),
                //     ),
                //     focusedBorder: const UnderlineInputBorder(
                //       borderSide: BorderSide(color: AppColors.navy900),
                //     ),
                //     filled: false,
                //   ),
                //   items: const [
                //     DropdownMenuItem(value: UserRole.customer, child: Text('Customer')),
                //     DropdownMenuItem(value: UserRole.dealer, child: Text('Dealer')),
                //     DropdownMenuItem(value: UserRole.admin, child: Text('Admin')),
                //     DropdownMenuItem(value: UserRole.servicePerson, child: Text('Service Person')),
                //   ],
                //   onChanged: (value) {
                //     setState(() {
                //       _selectedRole = value!;
                //     });
                //   },
                // ),
                const SizedBox(height: 48),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: state is AuthLoading 
                      ? null 
                      : () {
                          if (_nameController.text.isEmpty || _emailController.text.isEmpty) {
                            AwesomeDialog(
                              context: context,
                              dialogType: DialogType.warning,
                              width: 400,
                              title: 'Required Fields',
                              desc: 'Please fill in your name and email.',
                              btnOkOnPress: () {},
                            ).show();
                            return;
                          }
                          context.read<AuthCubit>().profileSetup(
                            name: _nameController.text,
                            email: _emailController.text,
                            address: _addressController.text,
                            role: _getRoleString(_selectedRole),
                          );
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
                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }
}
