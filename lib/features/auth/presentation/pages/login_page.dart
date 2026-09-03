import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:country_code_picker/country_code_picker.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/theme/app_theme.dart';
import '../widgets/auth_layout.dart';
import '../bloc/auth_cubit.dart';
import '../bloc/auth_state.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _phoneController = TextEditingController();
  String _countryCode = "+91";
  AwesomeDialog? _loadingDialog;

  @override
  void dispose() {
    _phoneController.dispose();
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
            Text('Sending OTP...', style: TextStyle(fontWeight: FontWeight.bold)),
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

        if (state is AuthOtpSent) {
          AwesomeDialog(
            context: context,
            dialogType: DialogType.success,
            animType: AnimType.bottomSlide,
            width: 400,
            title: 'Success',
            desc: state.message,
            btnOkOnPress: () {
              context.push(RouteNames.otp, extra: "$_countryCode${_phoneController.text}");
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
          title: 'Sign up',
          subtitle: '',
          illustrationTitle: 'Sign Up',
          illustrationSubtitle: 'Create an account to raise support tickets, track progress, and get faster assistance.',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: const TextSpan(
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.ink600,
                    fontFamily: 'Inter',
                  ),
                  children: [
                    TextSpan(text: 'If you already have an account register\nYou can '),
                    TextSpan(
                      text: 'Login here !',
                      style: TextStyle(
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
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  CountryCodePicker(
                    onChanged: (code) {
                      setState(() {
                        _countryCode = code.dialCode ?? "+91";
                      });
                    },
                    initialSelection: 'IN',
                    favorite: const ['+91', 'IN'],
                    showCountryOnly: false,
                    showOnlyCountryWhenClosed: false,
                    alignLeft: false,
                    padding: EdgeInsets.zero,
                    textStyle: const TextStyle(color: AppColors.navy900, fontWeight: FontWeight.bold),
                  ),
                  Expanded(
                    child: TextField(
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
                  ),
                ],
              ),
              const SizedBox(height: 48),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: state is AuthLoading 
                    ? null 
                    : () {
                        if (_phoneController.text.isNotEmpty) {
                          final fullPhone = "$_countryCode${_phoneController.text}";
                          context.read<AuthCubit>().sendOtp(fullPhone);
                        } else {
                          AwesomeDialog(
                            context: context,
                            dialogType: DialogType.warning,
                            width: 400,
                            title: 'Input Required',
                            desc: 'Please enter your mobile number.',
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
                    'Register',
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
