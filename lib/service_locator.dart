import 'package:get_it/get_it.dart';
import 'package:myflutter_app/services/api_service.dart';
import 'package:myflutter_app/services/auth_service.dart';
import 'package:flutter/foundation.dart';

final GetIt locator = GetIt.instance;

Future<void> setupLocator() async {
  try {
    debugPrint('Initializing service locator...');

    // Reset if already registered (for hot reload)
    if (locator.isRegistered<AuthService>()) {
      await locator.unregister<AuthService>();
    }
    if (locator.isRegistered<ApiService>()) {
      await locator.unregister<ApiService>();
    }

    // Register services
    locator.registerLazySingleton<AuthService>(() {
      debugPrint('Registering AuthService');
      return AuthService();
    });

    locator.registerLazySingleton<ApiService>(() {
      debugPrint('Registering ApiService');
      return ApiService();
    });

    // Verify registrations
    if (!locator.isRegistered<AuthService>()) {
      throw Exception('AuthService registration failed');
    }
    if (!locator.isRegistered<ApiService>()) {
      throw Exception('ApiService registration failed');
    }

    debugPrint('Service locator setup complete');
  } catch (e, stack) {
    debugPrint('Service locator error: $e');
    debugPrint(stack.toString());
    rethrow;
  }
}
