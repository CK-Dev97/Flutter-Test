import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Full-screen background image
          Image.asset('assets/welcom.jpg', fit: BoxFit.cover),
          // Content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Welcome To ',
                  style: GoogleFonts.breeSerif(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: const Color.fromARGB(255, 66, 2, 66),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 720),
                ElevatedButton(
                  onPressed: () {
                    GoRouter.of(context).go("/login"); // Navigate to Login Page
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 19,
                    ),
                    backgroundColor: const Color.fromARGB(255, 78, 1, 70),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(82),
                    ),
                    elevation: 5,
                  ),
                  child: Text(
                    'Join With Us ',
                    style: GoogleFonts.ibmPlexSans(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
