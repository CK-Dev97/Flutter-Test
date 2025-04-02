import '../Services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  get child => null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  'assets/trtr.jpg',
                ), // Change to your image path
                fit: BoxFit.cover, // Cover the full screen
              ),
            ),
          ),

          // Dark overlay for better contrast (Optional)
          Container(
            // ignore: deprecated_member_use
            color: Colors.black.withOpacity(0.4), // Adjust opacity as needed
          ),

          // Login Form
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Login',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 20),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            filled: true,
                            // ignore: deprecated_member_use
                            fillColor: Colors.white.withOpacity(
                              0.8,
                            ), // Transparent input background
                            labelText: 'Email',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                          controller: _passwordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            filled: true,
                            // ignore: deprecated_member_use
                            fillColor: Colors.white.withOpacity(0.8),
                            labelText: 'Password',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState?.validate() ?? false) {
                              User? user = await AuthService().login(
                                _emailController.text.trim(),
                                _passwordController.text.trim(),
                              );
                              if (user != null) {
                                // ignore: use_build_context_synchronously
                                GoRouter.of(context).go("/home");
                              } else {
                                // ignore: use_build_context_synchronously
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Login failed. Please check your credentials.',
                                    ),
                                  ),
                                );
                              }
                            }
                          },
                          child: Text('Login'),
                        ),

                        SizedBox(height: 10),
                        TextButton(
                          onPressed: () {
                            GoRouter.of(context).go("/signup");
                          },
                          child: Text(
                            'Don\'t have an account? Sign up',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
