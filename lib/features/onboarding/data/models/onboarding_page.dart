import 'package:flutter/material.dart';

class OnboardingPage {
  final String title;
  final String description;
  final String imageAsset;
  final IconData fallbackIcon;

  const OnboardingPage({
    required this.title,
    required this.description,
    required this.imageAsset,
    required this.fallbackIcon,
  });
}