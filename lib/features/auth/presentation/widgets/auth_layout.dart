import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import '../../../../core/theme/app_theme.dart';

class AuthLayout extends StatelessWidget {
  final Widget child;
  final String title;
  final String subtitle;
  final String illustrationTitle;
  final String illustrationSubtitle;
  final String illustrationPath;
  final VoidCallback? onBack;

  const AuthLayout({
    super.key,
    required this.child,
    required this.title,
    required this.subtitle,
    required this.illustrationTitle,
    required this.illustrationSubtitle,
    this.illustrationPath = 'assets/images/png/login_avatar.png',
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final bool isMobile = constraints.maxWidth < 800;

          if (isMobile) {
            return Stack(
              children: [
                if (onBack != null)
                  Positioned(
                    top: 20,
                    left: 20,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: onBack,
                    ),
                  ),
                Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: AppColors.ink900,
                          ),
                        ),
                        if (subtitle.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          Text(
                            subtitle,
                            style: const TextStyle(
                              fontSize: 14,
                              color: AppColors.ink600,
                            ),
                          ),
                        ],
                        const SizedBox(height: 32),
                        child,
                      ],
                    ),
                  ),
                ),
              ],
            );
          }

          return Row(
            children: [
              // Left side: Form
              Expanded(
                flex: 1,
                child: Stack(
                  children: [
                    if (onBack != null)
                      Positioned(
                        top: 40,
                        left: 40,
                        child: IconButton(
                          icon: const Icon(Icons.arrow_back),
                          onPressed: onBack,
                        ),
                      ),
                    Center(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(horizontal: 80.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              style: const TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: AppColors.ink900,
                              ),
                            ),
                            if (subtitle.isNotEmpty) ...[
                              const SizedBox(height: 16),
                              Text(
                                subtitle,
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: AppColors.ink600,
                                ),
                              ),
                            ],
                            const SizedBox(height: 48),
                            child,
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Right side: Illustration
              Expanded(
                flex: 1,
                child: Container(
                  margin: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppColors.navy900,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Column(
                    children: [
                      Expanded(
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(48.0),
                            child: _buildIllustration(),
                          ),
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(40.0), // Increased padding to match design better
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              illustrationTitle,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              illustrationSubtitle,
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildIllustration() {
    if (illustrationPath.endsWith('.json')) {
      return Lottie.asset(
        illustrationPath,
        fit: BoxFit.contain,
      );
    } else if (illustrationPath.endsWith('.svg')) {
      return SvgPicture.asset(
        illustrationPath,
        fit: BoxFit.contain,
      );
    } else {
      return Image.asset(
        illustrationPath,
        fit: BoxFit.contain,
      );
    }
  }
}
