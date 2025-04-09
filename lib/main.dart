// lib/main.dart
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:myflutter_app/Routes/routes.dart';
import 'package:provider/provider.dart';
import 'package:myflutter_app/providers/auth_provider.dart';
import 'package:myflutter_app/providers/home_provider.dart';
import 'package:myflutter_app/service_locator.dart';
import 'firebase_options.dart';

Future<void> main() async {
  // Ensure Flutter binding is initialized
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Initialize Firebase
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    // Set up dependency injection
    await setupLocator();

    runApp(const MyApp());
  } catch (error, stackTrace) {
    // Handle initialization errors
    debugPrint('Initialization error: $error');
    debugPrint('Stack trace: $stackTrace');
    // Consider showing an error screen or fallback UI
    runApp(const InitializationErrorApp());
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => HomeProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        // Add other providers here as needed
      ],
      child: MaterialApp.router(
        routerConfig: AppRouter().router,
        debugShowCheckedModeBanner: false,
        title: 'My Flutter App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          useMaterial3: true,
        ),
        darkTheme: ThemeData.dark(),
        themeMode: ThemeMode.system, // Follow system theme
        restorationScopeId: 'app', // For state restoration
        builder: (context, child) {
          // Add global overlays or dialogs here if needed
          return child ?? const SizedBox.shrink();
        },
      ),
    );
  }
}

class InitializationErrorApp extends StatelessWidget {
  const InitializationErrorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text(
                'Initialization Error',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              const Text(
                'Failed to initialize the app. Please try again later.',
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => main(),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
