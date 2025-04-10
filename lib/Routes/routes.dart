// lib/routes/app_router.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:myflutter_app/pages/splash_page.dart';
import 'package:myflutter_app/pages/welcome_page.dart';
import 'package:myflutter_app/pages/login_page.dart';
import 'package:myflutter_app/pages/signup_page.dart';
import 'package:myflutter_app/pages/home_page.dart';

class AppRouter {
  final GoRouter router = GoRouter(
    // Set splash screen as initial route
    initialLocation: '/splash',
    routes: [
      // Splash Screen Route (initial route)
      GoRoute(
        path: '/splash',
        name: 'splash',
        pageBuilder:
            (context, state) => buildPageWithDefaultTransition(
              context: context,
              state: state,
              child: const SplashPage(),
            ),
      ),

      // Welcome Route
      GoRoute(
        path: '/',
        name: 'welcome',
        pageBuilder:
            (context, state) => buildPageWithDefaultTransition(
              context: context,
              state: state,
              child: const WelcomePage(),
            ),
      ),

      // Login Route
      GoRoute(
        path: '/login',
        name: 'login',
        pageBuilder:
            (context, state) => buildPageWithDefaultTransition(
              context: context,
              state: state,
              child: const LoginPage(),
            ),
      ),

      // Signup Route
      GoRoute(
        path: '/signup',
        name: 'signup',
        pageBuilder:
            (context, state) => buildPageWithDefaultTransition(
              context: context,
              state: state,
              child: const SignUpPage(),
            ),
      ),

      // Home Route
      GoRoute(
        path: '/home',
        name: 'home',
        pageBuilder:
            (context, state) => buildPageWithDefaultTransition(
              context: context,
              state: state,
              child: const HomePage(),
            ),
      ),
    ],

    // Add error page
    errorPageBuilder:
        (context, state) => MaterialPage<void>(
          key: state.pageKey,
          child: Scaffold(
            body: Center(child: Text('Page not found: ${state.error}')),
          ),
        ),
  );

  // Helper method for consistent page transitions
  static CustomTransitionPage buildPageWithDefaultTransition({
    required BuildContext context,
    required GoRouterState state,
    required Widget child,
  }) {
    return CustomTransitionPage<void>(
      key: state.pageKey,
      child: child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(opacity: animation, child: child);
      },
    );
  }
}
