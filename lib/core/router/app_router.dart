import 'package:go_router/go_router.dart';
import '../../features/customer/presentation/pages/customer_dashboard_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/otp_page.dart';
import '../../features/auth/presentation/pages/profile_setup_page.dart';
import '../../features/admin/presentation/pages/admin_dashboard_page.dart';
import '../../features/dealer/presentation/pages/dealer_dashboard_page.dart';
import 'route_names.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: RouteNames.login,
    routes: [
      GoRoute(
        path: RouteNames.login,
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: RouteNames.otp,
        builder: (context, state) {
          final phoneNumber = state.extra as String? ?? '';
          return OtpPage(phoneNumber: phoneNumber);
        },
      ),
      GoRoute(
        path: RouteNames.profileSetup,
        builder: (context, state) => const ProfileSetupPage(),
      ),
      GoRoute(
        path: RouteNames.customerDashboard,
        builder: (context, state) => const CustomerDashboardPage(),
      ),
      GoRoute(
        path: RouteNames.adminDashboard,
        builder: (context, state) => const AdminDashboardPage(),
      ),
      GoRoute(
        path: RouteNames.dealerDashboard,
        builder: (context, state) => const DealerDashboardPage(),
      ),
    ],
  );
}
