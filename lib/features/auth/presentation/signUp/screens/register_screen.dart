import 'package:centris/features/auth/core/widgets/appbar.dart';
import 'package:centris/features/auth/core/widgets/conditionutilisation.dart';
import 'package:centris/features/auth/core/widgets/divider.dart';
import 'package:centris/features/auth/core/widgets/primary_button.dart';
import 'package:centris/features/auth/core/widgets/socialButton.dart';
import 'package:centris/features/auth/core/widgets/textfiels.dart';
import 'package:centris/features/auth/data/models/login_model.dart';
import 'package:centris/features/auth/data/models/register_data.dart';
import 'package:centris/features/auth/data/repositories/register_controller.dart';
import 'package:centris/features/auth/presentation/login/controllers/login_controller.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final RegisterController _controller = RegisterController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final ValueNotifier<bool> _obscurePassword = ValueNotifier<bool>(true);
  final ValueNotifier<bool> _obscureConfirmPassword = ValueNotifier<bool>(true);
  final ValueNotifier<bool> _acceptTerms = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_onEmailChanged);
    _passwordController.addListener(_onPasswordChanged);
    _confirmPasswordController.addListener(_onConfirmPasswordChanged);
  }

  void _onEmailChanged() {
    _controller.updateEmail(_emailController.text);
  }

  void _onPasswordChanged() {
    _controller.updatePassword(_passwordController.text);
  }

  void _onConfirmPasswordChanged() {
    _controller.updateConfirmPassword(_confirmPasswordController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AuthAppBar(
        title: 'Inscription',
        onBackPressed: () => Navigator.pop(context),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 25),
                  
                  // Champ Courriel
                  AuthTextField(
                    controller: _emailController,
                    label: 'Courriel',
                    hintText: 'Entrer votre courriel',
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 18),
                  
                  // Champ Mot de passe
                  ValueListenableBuilder<bool>(
                    valueListenable: _obscurePassword,
                    builder: (context, obscureValue, child) {
                      return AuthTextField(
                        controller: _passwordController,
                        label: 'Mot de passe',
                        hintText: 'Entrer votre mot de passe',
                        obscureText: obscureValue,
                        suffixIcon: IconButton(
                          icon: Icon(
                            obscureValue ? Icons.visibility_off_outlined : Icons.visibility_outlined, 
                            color: const Color.fromARGB(171, 158, 158, 158)
                          ),
                          onPressed: () => _controller.togglePasswordVisibility(_obscurePassword),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 18),
                  
                  // Champ Confirmer Mot de passe
                  ValueListenableBuilder<bool>(
                    valueListenable: _obscureConfirmPassword,
                    builder: (context, obscureValue, child) {
                      return AuthTextField(
                        controller: _confirmPasswordController,
                        label: 'Répéter votre mot de passe',
                        hintText: 'Entrer votre mot de passe',
                        obscureText: obscureValue,
                        suffixIcon: IconButton(
                          icon: Icon(
                            obscureValue ? Icons.visibility_off_outlined : Icons.visibility_outlined, 
                            color: const Color.fromARGB(171, 158, 158, 158)
                          ),
                          onPressed: () => _controller.toggleConfirmPasswordVisibility(_obscureConfirmPassword),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                  
                  // Checkbox conditions d'utilisation
                  ValueListenableBuilder<bool>(
                    valueListenable: _acceptTerms,
                    builder: (context, acceptValue, child) {
                      return TermsAndConditions(
                        value: acceptValue,
                        onChanged: (value) {
                          _acceptTerms.value = value;
                          _controller.toggleAcceptTerms(value);
                        },
                       // onTermsTap: () => _controller.navigateToTerms(context),
                        //onPrivacyTap: () => _controller.navigateToPrivacyPolicy(context),
                      );
                    },
                  ),
                  const SizedBox(height: 30),
                  
                  // Divider et texte "ou inscription via"
                  const AuthDivider(text: 'ou inscription via'),
                  const SizedBox(height: 24),
                  
                  // Boutons de connexion sociale
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SocialAuthButton(
                        icon: Icons.facebook,
                        color: const Color(0xFF3B5998),
                        onPressed: () {},
                      ),
                      const SizedBox(width: 20),
                      SocialAuthButton(
                        icon: Icons.g_mobiledata,
                        color: Colors.red,
                        onPressed: () {},
                      ),
                      const SizedBox(width: 20),
                      SocialAuthButton(
                        icon: Icons.apple,
                        color: Colors.black,
                        onPressed: () {},
                      ),
                    ],
                  ),
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
          
          // Bouton Créer mon compte (fixe en bas)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: ValueListenableBuilder<bool>(
              valueListenable: _acceptTerms,
              builder: (context, acceptValue, child) {
                final registerData = RegisterData(
                  email: _emailController.text,
                  password: _passwordController.text,
                  confirmPassword: _confirmPasswordController.text,
                  acceptTerms: acceptValue,
                );
                
                return AuthPrimaryButton(
                  text: 'Créer mon compte',
                  onPressed: () => _controller.register(context, registerData),
                 
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _obscurePassword.dispose();
    _obscureConfirmPassword.dispose();
    _acceptTerms.dispose();
    super.dispose();
  }
}