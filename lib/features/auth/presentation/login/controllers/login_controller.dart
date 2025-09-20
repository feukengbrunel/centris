import 'package:centris/features/auth/data/models/login_model.dart';
import 'package:centris/features/auth/presentation/signUp/screens/register_screen.dart';
import 'package:centris/navigation/Accueil/accueil.dart';
import 'package:flutter/material.dart';


class LoginController {
  final LoginData _loginData = const LoginData(
    email: '',
    password: '',
    acceptTerms: false,
  );

  LoginData get loginData => _loginData;

  void updateEmail(String email) {
    _loginData.copyWith(email: email);
  }

  void updatePassword(String password) {
    _loginData.copyWith(password: password);
  }

  void toggleAcceptTerms(bool value) {
    _loginData.copyWith(acceptTerms: value);
  }

  void togglePasswordVisibility(ValueNotifier<bool> obscurePassword) {
    obscurePassword.value = !obscurePassword.value;
  }

  void login(BuildContext context, LoginData loginData) {
    // Implémentez la logique de connexion ici
    if (loginData.email.isEmpty || loginData.password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez remplir tous les champs')),
      );
      return;
    }

    if (!loginData.acceptTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez accepter les conditions')),
      );
      return;
    }

    // Simulation de connexion réussie
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Connexion réussie')),
      
    );
    
    // Navigation vers l'écran d'accueil
     Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => WelcomeScreen()));
  }

  void navigateToRegister(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const RegisterScreen()),
    );
  }

  void navigateToForgotPassword(BuildContext context) {
    // Implémentez la navigation vers l'écran de mot de passe oublié
    showDialog(
      barrierColor: Colors.white,
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Mot de passe oublié'),
        content: const Text('Fonctionnalité à implémenter'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}