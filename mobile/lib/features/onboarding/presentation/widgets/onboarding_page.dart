import 'package:flutter/material.dart';
import 'package:mobile/features/onboarding/presentation/models/onboarding_model.dart';


class OnboardingPage extends StatelessWidget {
  final OnboardingModel page;

  const OnboardingPage({
    super.key,
    required this.page,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          Image.asset(
            page.image,
            height: 260,
          ),

          const SizedBox(height: 40),

          Text(
            page.title,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 20),

          Text(
            page.description,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}