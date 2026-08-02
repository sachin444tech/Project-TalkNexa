import 'package:flutter/material.dart';
import 'package:mobile/features/onboarding/presentaion/models/onboarding_model.dart';

class OnboardingScreen extends StatelessWidget {
  OnboardingScreen({super.key});

  final pages = [
  OnboardingModel(
    title: "Practice Every Day",
    description:
        "Speak English daily with AI and real learners.",
    image: "assets/images/onboarding_1.png",
  ),
  OnboardingModel(
    title: "AI Speaking Coach",
    description:
        "Improve pronunciation with instant AI feedback.",
    image: "assets/images/onboarding_2.png",
  ),
  OnboardingModel(
    title: "Speak with Confidence",
    description:
        "Join live conversations and become fluent.",
    image: "assets/images/onboarding_3.png",
  ),
];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: PageView.builder(
          itemCount: pages.length,
          itemBuilder: (context, index){
            final page = pages[index];

            return Center( child: Text(page.title)
            );
          }
        ),
      ),
    );
  }
}