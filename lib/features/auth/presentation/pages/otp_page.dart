import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/theme/app_theme.dart';
import '../widgets/auth_layout.dart';
import '../bloc/auth_cubit.dart';
import '../bloc/auth_state.dart';

class OtpPage extends StatefulWidget {
  final String phoneNumber;
  const OtpPage({super.key, required this.phoneNumber});

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  final _otpController = TextEditingController();
  AwesomeDialog? _loadingDialog;

  @override
  void dispose() {
    _otpController.dispose();
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
            Text('Verifying OTP...', style: TextStyle(fontWeight: FontWeight.bold)),
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

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthLoading) {
          _showLoading(context);
        } else {
          _dismissLoading();
        }

        if (state is AuthVerified) {
          AwesomeDialog(
            context: context,
            dialogType: DialogType.success,
            animType: AnimType.bottomSlide,
            width: 400,
            title: 'Verified',
            desc: 'Your mobile number has been verified successfully.',
            btnOkOnPress: () {
              // Based on profile completeness, navigate to dashboard or setup
              final isComplete = state.userData['user']?['isProfileComplete'] ?? false;
              if (isComplete) {
                // Determine role and navigate
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
              } else {
                context.push(RouteNames.profileSetup);
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
          title: 'Verify OTP',
          subtitle: 'Enter the code sent to ${widget.phoneNumber}',
          illustrationTitle: 'Verify Account',
          illustrationSubtitle: 'Security is our top priority. Please verify your mobile number to continue.',
          onBack: () => context.pop(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'OTP Code',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.ink400,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _otpController,
                decoration: InputDecoration(
                  hintText: 'Enter 6-digit code',
                  prefixIcon: const Icon(Icons.lock_outline, color: AppColors.ink400),
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
                keyboardType: TextInputType.number,
                maxLength: 6,
              ),
              const SizedBox(height: 48),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: state is AuthLoading
                    ? null
                    : () {
                        if (_otpController.text.length == 6) {
                          context.read<AuthCubit>().verifyOtp(widget.phoneNumber, _otpController.text);
                        } else {
                          AwesomeDialog(
                            context: context,
                            dialogType: DialogType.warning,
                            width: 400,
                            title: 'Invalid Input',
                            desc: 'Please enter a 6-digit OTP code.',
                            btnOkOnPress: () {},
                          ).show();
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
                    'Verify OTP',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
