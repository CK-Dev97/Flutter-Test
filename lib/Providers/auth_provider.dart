// lib/providers/auth_provider.dart
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseAuth _auth;
  User? _user;
  bool _isLoading = false;
  String? _error;

  AuthProvider({FirebaseAuth? auth}) : _auth = auth ?? FirebaseAuth.instance {
    _user = _auth.currentUser;
    _auth.authStateChanges().listen((User? user) {
      _user = user;
      notifyListeners();
    });
  }

  // Getters
  User? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _user != null;

  Future<void> signUp(String email, String password) async {
    try {
      _setLoading(true);
      await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      _error = null;
    } on FirebaseAuthException catch (e) {
      _error = _getErrorMessage(e.code);
      debugPrint('SignUp error: ${e.code} - ${e.message}');
      rethrow;
    } catch (e) {
      _error = 'An unknown error occurred';
      debugPrint('Unexpected signUp error: $e');
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> login(String email, String password) async {
    try {
      _setLoading(true);
      await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      _error = null;
    } on FirebaseAuthException catch (e) {
      _error = _getErrorMessage(e.code);
      debugPrint('Login error: ${e.code} - ${e.message}');
      rethrow;
    } catch (e) {
      _error = 'An unknown error occurred';
      debugPrint('Unexpected login error: $e');
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> logout() async {
    try {
      await _auth.signOut();
      _user = null;
    } catch (e) {
      debugPrint('Logout error: $e');
      rethrow;
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      _setLoading(true);
      await _auth.sendPasswordResetEmail(email: email.trim());
      _error = null;
    } on FirebaseAuthException catch (e) {
      _error = _getErrorMessage(e.code);
      debugPrint('Password reset error: ${e.code} - ${e.message}');
      rethrow;
    } catch (e) {
      _error = 'An unknown error occurred';
      debugPrint('Unexpected password reset error: $e');
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  String _getErrorMessage(String code) {
    switch (code) {
      case 'invalid-email':
        return 'The email address is not valid';
      case 'user-disabled':
        return 'This user account has been disabled';
      case 'user-not-found':
        return 'No user found with this email address';
      case 'wrong-password':
        return 'Incorrect password. Please try again';
      case 'email-already-in-use':
        return 'This email address is already in use';
      case 'operation-not-allowed':
        return 'Email/password accounts are not enabled';
      case 'weak-password':
        return 'The password is too weak (min 6 characters)';
      case 'too-many-requests':
        return 'Too many requests. Please try again later';
      case 'network-request-failed':
        return 'Network error. Please check your connection';
      case 'requires-recent-login':
        return 'This operation requires recent authentication. Please log in again';
      default:
        return 'An unexpected error occurred. Please try again';
    }
  }
}
