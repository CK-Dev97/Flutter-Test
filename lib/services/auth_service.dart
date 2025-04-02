import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> signUp(String email, String password) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      debugPrint('SignUp error: ${e.code} - ${e.message}');
      throw AuthException.fromCode(e.code);
    } catch (e) {
      debugPrint('Unexpected signUp error: $e');
      throw const AuthException();
    }
  }

  Future<User?> login(String email, String password) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      debugPrint('Login error: ${e.code} - ${e.message}');
      throw AuthException.fromCode(e.code);
    } catch (e) {
      debugPrint('Unexpected login error: $e');
      throw const AuthException();
    }
  }

  Future<void> logout() async {
    try {
      await _auth.signOut();
    } catch (e) {
      debugPrint('Logout error: $e');
      rethrow;
    }
  }

  User? getCurrentUser() {
    return _auth.currentUser;
  }
}

class AuthException implements Exception {
  final String message;

  const AuthException([this.message = 'An unknown error occurred']);

  factory AuthException.fromCode(String code) {
    switch (code) {
      case 'invalid-email':
        return const AuthException('Email is not valid');
      case 'user-disabled':
        return const AuthException('This user has been disabled');
      case 'user-not-found':
        return const AuthException('No user found with this email');
      case 'wrong-password':
        return const AuthException('Incorrect password');
      case 'email-already-in-use':
        return const AuthException('Email already in use');
      case 'weak-password':
        return const AuthException('Password is too weak');
      default:
        return const AuthException();
    }
  }
}
