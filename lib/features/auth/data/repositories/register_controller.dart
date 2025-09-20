import 'package:flutter/material.dart';
import '../models/register_data.dart';

class RegisterController {
  final RegisterData _registerData = const RegisterData(
    email: '',
    password: '',
    confirmPassword: '',
    acceptTerms: false,
  );

  RegisterData get registerData => _registerData;

  void updateEmail(String email) {
    _registerData.copyWith(email: email);
  }

  void updatePassword(String password) {
    _registerData.copyWith(password: password);
  }

  void updateConfirmPassword(String confirmPassword) {
    _registerData.copyWith(confirmPassword: confirmPassword);
  }

  void toggleAcceptTerms(bool value) {
    _registerData.copyWith(acceptTerms: value);
  }

  void togglePasswordVisibility(ValueNotifier<bool> obscurePassword) {
    obscurePassword.value = !obscurePassword.value;
  }

  void toggleConfirmPasswordVisibility(ValueNotifier<bool> obscureConfirmPassword) {
    obscureConfirmPassword.value = !obscureConfirmPassword.value;
  }

  void register(BuildContext context, RegisterData registerData) {
    // Implémentez la logique d'inscription ici
    if (registerData.email.isEmpty || registerData.password.isEmpty || registerData.confirmPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez remplir tous les champs')),
      );
      return;
    }

    if (!registerData.passwordsMatch) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Les mots de passe ne correspondent pas')),
      );
      return;
    }

    if (!registerData.acceptTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez accepter les conditions')),
      );
      return;
    }

    // Simulation d'inscription réussie
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Inscription réussie')),
    );
    
    // Navigation vers l'écran d'accueil ou de connexion
    Navigator.pop(context);
  }

  void navigateToLogin(BuildContext context) {
    Navigator.pop(context);
  }

  void navigateToTerms(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Conditions d\'utilisation'),
        content: const Text('Conditions d\'utilisation à implémenter'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fermer'),
          ),
        ],
      ),
    );
  }

  void navigateToPrivacyPolicy(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Politique de confidentialité'),
        content: const Text('Politique de confidentialité à implémenter'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fermer'),
          ),
        ],
      ),
    );
  }
}