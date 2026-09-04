import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../features/customer/presentation/pages/customer_dashboard_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/otp_page.dart';
import '../../features/auth/presentation/pages/profile_setup_page.dart';
import '../../features/admin/presentation/pages/admin_dashboard_page.dart';
import '../../features/dealer/presentation/pages/dealer_dashboard_page.dart';
import '../../features/service_person/presentation/pages/technician_dashboard_page.dart';
import '../../features/auth/presentation/bloc/auth_cubit.dart';
import '../../injection_container.dart';
import 'route_names.dart';

import '../../core/network/token_manager.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: RouteNames.login,
    redirect: (context, state) {
      final tokenManager = sl<TokenManager>();
      final bool loggedIn = tokenManager.hasToken();
      final bool isAuthPath = state.matchedLocation == RouteNames.login || 
                             state.matchedLocation == RouteNames.otp ||
                             state.matchedLocation == RouteNames.profileSetup;

      if (!loggedIn) {
        return isAuthPath ? null : RouteNames.login;
      }

      // If logged in but profile not complete, redirect to profile setup
      if (!tokenManager.isProfileComplete() && state.matchedLocation != RouteNames.profileSetup) {
        return RouteNames.profileSetup;
      }

      // If logged in and profile complete, but on an auth page, redirect to correct dashboard
      if (isAuthPath && state.matchedLocation != RouteNames.profileSetup) {
        final role = tokenManager.getRole();
        print("role : $role");
        if (role == 'Admin') {
          return RouteNames.adminDashboard;
        } else if (role == 'Dealer') {
          return RouteNames.dealerDashboard;
        } else if (role == 'Sub Dealer') {
          return RouteNames.dealerDashboard;
        } else if (role == 'Technician') {
          return RouteNames.technicianDashboard;
        } else {
          return RouteNames.customerDashboard;
        }
      }

      return null;
    },
    routes: [
      GoRoute(
        path: RouteNames.login,
        builder: (context, state) => BlocProvider(
          create: (context) => sl<AuthCubit>(),
          child: const LoginPage(),
        ),
      ),
      GoRoute(
        path: RouteNames.otp,
        builder: (context, state) {
          final phoneNumber = state.extra as String? ?? '';
          return BlocProvider(
            create: (context) => sl<AuthCubit>(),
            child: OtpPage(phoneNumber: phoneNumber),
          );
        },
      ),
      GoRoute(
        path: RouteNames.profileSetup,
        builder: (context, state) => BlocProvider(
          create: (context) => sl<AuthCubit>(),
          child: const ProfileSetupPage(),
        ),
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
      GoRoute(
        path: RouteNames.technicianDashboard,
        builder: (context, state) => const TechnicianDashboardPage(),
      ),
    ],
  );
}
