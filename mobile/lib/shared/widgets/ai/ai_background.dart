import 'package:flutter/material.dart';
import 'package:mobile/app/theme/app_colors.dart';

class AIBackground extends StatelessWidget {
  final Widget child;

  const AIBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,

          end: Alignment.bottomRight,

          colors: [
            AppColors.darkBackground,

            AppColors.primary,

            AppColors.secondary,
          ],
        ),
      ),

      child: child,
    );
  }
}
