import 'package:flutter/material.dart';
import 'package:mobile/core/constants/app_assets.dart';
import 'package:mobile/core/constants/app_strings.dart';


class HeroLogo extends StatelessWidget {
  const HeroLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: "talknexa_logo",

      child: Column(
        children: [

          Image.asset(
            AppAssets.logo,
            height: 90,
          ),

          const SizedBox(height: 18),

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

        ],
      ),
    );
  }
}