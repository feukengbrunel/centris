import 'package:centris/features/auth/presentation/login/screens/login_screen.dart';
import 'package:centris/features/auth/presentation/signUp/screens/register_screen.dart';
import 'package:centris/features/onboarding/data/models/onboarding_page.dart';
import 'package:centris/features/onboarding/onboarding_controller.dart';
import 'package:centris/features/onboarding/presentation/widgets/onboarding_content.dart';
import 'package:centris/features/onboarding/presentation/widgets/onboarding_indicator.dart';
import 'package:centris/features/onboarding/presentation/widgets/onboarding_navigation.dart';
import 'package:centris/navigation/Accueil/accueil.dart';
import 'package:flutter/material.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final OnboardingController _controller = OnboardingController();
  final List<OnboardingPage> _pages = const [
    OnboardingPage(
      title: 'Toute l\'information au même endroit',
      description: 'Consultez la fiche d\'une propriété pour découvrir ses caractéristiques, ses détails financiers, et même en savoir plus sur le quartier!',
      imageAsset: 'assets/images/property_image.jpg',
      fallbackIcon: Icons.home,
    ),
    OnboardingPage(
      title: 'Des alertes pour ne rien manquer',
      description: 'Recevez des notifications quand il y a du nouveau dans les recherches que vous avez sauvegardées.',
      imageAsset: 'assets/images/search_alert.jpg',
      fallbackIcon: Icons.notifications,
    ),
    OnboardingPage(
      title: 'Un moteur de recherche puissant',
      description: 'Cherchez dans plus d\'une municipalité ou tracez votre propre périmètre, puis affinez votre recherche avec nos filtres ultra-précis.',
      imageAsset: 'assets/images/search_engine.jpg',
      fallbackIcon: Icons.search,
    ),
    OnboardingPage(
      title: 'Sauvegardez vos recherches',
      description: 'Enregistrez vos critères de recherche pour y accéder rapidement et recevoir des alertes lorsque de nouvelles propriétés correspondantes sont disponibles.',
      imageAsset: 'assets/images/saved_search.jpg',
      fallbackIcon: Icons.bookmark,
    ),
  ];

  void _navigateToHome() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const WelcomeScreen())
    );
  }
  void _navigateToRegister() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const LoginScreen())
    );
  }

  @override
  void initState() {
    super.initState();
    _controller.pageController.addListener(() {
      _controller.currentPage.value = _controller.pageController.page?.round() ?? 0;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: PageView(
                controller: _controller.pageController,
                onPageChanged: (int page) {
                  _controller.currentPage.value = page;
                },
                children: _pages.map((page) => OnboardingContent(page: page)).toList(),
              ),
            ),
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Bienvenue chez Centris!',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0B1340),
            ),
          ),
          TextButton(
            onPressed: _navigateToHome,
            child: const Text(
              'Passer',
              style: TextStyle(
                color: Colors.blue,
                fontSize: 15,
                decoration: TextDecoration.underline,
                decorationColor: Colors.blue,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          ValueListenableBuilder<int>(
            valueListenable: _controller.currentPage,
            builder: (context, currentPage, child) {
              return Column(
                children: [
                  OnboardingIndicator(
                    currentPage: currentPage,
                    totalPages: _pages.length,
                  ),
                  const SizedBox(height: 20),
                  OnboardingNavigation(
                    currentPage: currentPage,
                    totalPages: _pages.length,
                    onPrevious: _controller.previousPage,
                    onNext: _controller.nextPage,
                    onSkip: _navigateToRegister,
                    onStart: _navigateToRegister,
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}