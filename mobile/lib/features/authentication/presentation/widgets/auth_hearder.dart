import 'package:flutter/material.dart';
import 'package:mobile/core/constants/app_assets.dart';
import 'package:mobile/core/constants/app_strings.dart';


class AuthHeader extends StatelessWidget {
  const AuthHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [

        Image.asset(
          AppAssets.logo,
          height: 90,
        ),

        const SizedBox(height: 20),

        const Text(
          AppStrings.appName,
          style: TextStyle(
            fontSize: 34,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 8),

        const Text(
          AppStrings.tagline,
          textAlign: TextAlign.center,
        ),

        const SizedBox(height: 24),

        const Text(
          "Welcome Back!",
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 12),

        const Text(
          "Continue your journey to confident English speaking.",
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}