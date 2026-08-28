import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/theme/app_theme.dart';
import '../widgets/auth_layout.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _phoneController = TextEditingController();

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AuthLayout(
      title: 'Sign up',
      subtitle: '', // We'll use the child to place the subtitle with RichText if needed, or just pass it.
      illustrationTitle: 'Sign Up',
      illustrationSubtitle: 'Create an account to raise support tickets, track progress, and get faster assistance.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              style: const TextStyle(
                fontSize: 16,
                color: AppColors.ink600,
                fontFamily: 'Inter', // Assuming standard font or default
              ),
              children: [
                const TextSpan(text: 'If you already have an account register\nYou can '),
                TextSpan(
                  text: 'Login here !',
                  style: const TextStyle(
                    color: Colors.blueAccent,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 48),
          const Text(
            'Mobile Number',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.ink400,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _phoneController,
            decoration: InputDecoration(
              hintText: 'Enter your mobile number',
              prefixIcon: const Icon(Icons.phone_outlined, color: AppColors.ink400),
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
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: 48),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: () {
                context.push(RouteNames.otp, extra: _phoneController.text);
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
                'Register',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
