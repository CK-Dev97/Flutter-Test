// ignore: unused_import
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:myflutter_app/Pages/welcome_page.dart';
import 'package:myflutter_app/Pages/login_page.dart';
import 'package:myflutter_app/Pages/signup_page.dart';
import 'package:myflutter_app/Pages/home_page.dart';

class AppRouter {
  final GoRouter router = GoRouter(
    routes: [
      GoRoute(path: '/', builder: (context, state) => const WelcomePage()),
      GoRoute(path: '/login', builder: (context, state) => const LoginPage()),
      GoRoute(path: '/signup', builder: (context, state) => const SignUpPage()),
      GoRoute(path: '/home', builder: (context, state) => const HomePage()),
    ],
  );
}
