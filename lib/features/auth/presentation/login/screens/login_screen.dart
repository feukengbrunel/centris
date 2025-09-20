import 'package:centris/features/auth/core/widgets/conditionutilisation.dart';
import 'package:centris/features/auth/core/widgets/divider.dart';
import 'package:centris/features/auth/core/widgets/primary_button.dart';
import 'package:centris/features/auth/core/widgets/socialButton.dart';
import 'package:centris/features/auth/core/widgets/textfiels.dart';
import 'package:centris/features/auth/data/models/login_model.dart';
import 'package:centris/features/auth/presentation/login/controllers/login_controller.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final LoginController _controller = LoginController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final ValueNotifier<bool> _obscurePassword = ValueNotifier<bool>(true);
  final ValueNotifier<bool> _acceptTerms = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_onEmailChanged);
    _passwordController.addListener(_onPasswordChanged);
  }

  void _onEmailChanged() {
    _controller.updateEmail(_emailController.text);
  }

  void _onPasswordChanged() {
    _controller.updatePassword(_passwordController.text);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 350;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(
            height: 1.0,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              border: Border(
                bottom: BorderSide(color: Colors.grey.shade300, width: 1.0),
              ),
            ),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
      ),
      
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: isSmallScreen ? 16.0 : 20.0,
          vertical: 16.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Logo Centris
            Center(
              child: Container(
                margin: EdgeInsets.only(top: isSmallScreen ? 10 : 20),
                child: Image.asset(
                  'assets/images/centris_logo.png',
                  height: isSmallScreen ? 40 : 50,
                  errorBuilder: (context, error, stackTrace) {
                    return RichText(
                      text: const TextSpan(
                        children: [
                          WidgetSpan(
                            child: Icon(
                              Icons.home,
                              size: 32,
                              color: Color(0xFF0B1340),
                            ),
                          ),
                          TextSpan(
                            text: 'centris.',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0B1340),
                            ),
                          ),
                          TextSpan(
                            text: 'ca',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF0B1340),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
            SizedBox(height: isSmallScreen ? 16 : 20),
            
            // Titre "Nouveau? Créer un compte"
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Nouveau? ',
                    style: TextStyle(
                      fontSize: isSmallScreen ? 14 : 16,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF0B1340),
                    ),
                  ),
                  TextButton(
                    onPressed: () => _controller.navigateToRegister(context), 
                    child: Text(
                      'Créer un compte',
                      style: TextStyle(
                        fontSize: isSmallScreen ? 14 : 16,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF0B1340),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: isSmallScreen ? 20 : 30),
            
            // Champ Courriel
            AuthTextField(
              controller: _emailController,
              label: 'Courriel',
              hintText: 'Entrer votre courriel',
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: isSmallScreen ? 12 : 18),
            
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
                      color: const Color.fromARGB(171, 158, 158, 158),
                      size: 20,
                    ),
                    onPressed: () => _controller.togglePasswordVisibility(_obscurePassword),
                  ),
                );
              },
            ),
            SizedBox(height: isSmallScreen ? 16 : 24),
            
            // Bouton de connexion
            SizedBox(
              width: double.infinity,
              height: isSmallScreen ? 46 : 52,
              child: AuthPrimaryButton(
                text: 'Connexion avec mon courriel',
                onPressed: () {
                  final loginData = LoginData(
                    email: _emailController.text,
                    password: _passwordController.text,
                    acceptTerms: _acceptTerms.value,
                  );
                  _controller.login(context, loginData);
                },
              ),
            ),
            SizedBox(height: isSmallScreen ? 12 : 16),
            
            // Lien "Mot de passe oublié"
            Center(
              child: TextButton(
                onPressed: () => _controller.navigateToForgotPassword(context),
                child: Text(
                  'Vous avez oublié votre mot de passe?',
                  style: TextStyle(
                    color: const Color(0xFF0B1340),
                    fontSize: isSmallScreen ? 14 : 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            
            // Spacer pour pousser le contenu vers le haut
            SizedBox(height: isSmallScreen ? 12 : 16),
            
            // Divider et texte "ou connexion via"
            const AuthDivider(text: 'ou connexion via'),
            SizedBox(height: isSmallScreen ? 16 : 24),
            
            // Boutons de connexion sociale
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SocialAuthButton(
                  icon: Icons.facebook,
                  color: const Color(0xFF3B5998),
                  onPressed: () {},
                  size: isSmallScreen ? 50 : 60,
                ),
                SizedBox(width: isSmallScreen ? 12 : 20),
                SocialAuthButton(
                  icon: Icons.g_mobiledata,
                  color: Colors.red,
                  onPressed: () {},
                  size: isSmallScreen ? 50 : 60,
                ),
                SizedBox(width: isSmallScreen ? 12 : 20),
                SocialAuthButton(
                  icon: Icons.apple,
                  color: Colors.black,
                  onPressed: () {},
                  size: isSmallScreen ? 50 : 60,
                ),
              ],
            ),
            SizedBox(height: isSmallScreen ? 16 : 24),
            
            // Conditions d'utilisation avec checkbox
            ValueListenableBuilder<bool>(
              valueListenable: _acceptTerms,
              builder: (context, acceptValue, child) {
                return TermsAndConditions(
                  value: acceptValue,
                  onChanged: (value) {
                    _acceptTerms.value = value;
                    _controller.toggleAcceptTerms(value);
                  },
                );
              },
            ),
            SizedBox(height: isSmallScreen ? 16 : 20),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _obscurePassword.dispose();
    _acceptTerms.dispose();
    super.dispose();
  }
}