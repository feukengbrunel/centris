import 'package:centris/features/auth/data/models/login_model.dart';

abstract class AuthRepository {
  Future<void> loginWithEmail(LoginData loginData);
  Future<void> loginWithFacebook();
  Future<void> loginWithGoogle();
  Future<void> loginWithApple();
  Future<void> resetPassword(String email);
}

class MockAuthRepository implements AuthRepository {
  @override
  Future<void> loginWithEmail(LoginData loginData) async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));
    
    // In a real app, this would make an actual API call
    if (loginData.email.isEmpty || loginData.password.isEmpty) {
      throw Exception('Email and password are required');
    }
    
    // Mock successful login
    return;
  }

  @override
  Future<void> loginWithFacebook() async {
    await Future.delayed(const Duration(seconds: 2));
    // Implement Facebook login logic
  }

  @override
  Future<void> loginWithGoogle() async {
    await Future.delayed(const Duration(seconds: 2));
    // Implement Google login logic
  }

  @override
  Future<void> loginWithApple() async {
    await Future.delayed(const Duration(seconds: 2));
    // Implement Apple login logic
  }

  @override
  Future<void> resetPassword(String email) async {
    await Future.delayed(const Duration(seconds: 2));
    if (email.isEmpty) {
      throw Exception('Email is required');
    }
    // Mock password reset
    return;
  }
}