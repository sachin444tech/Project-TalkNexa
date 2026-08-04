import 'package:flutter/material.dart';

import '../../../../shared/widgets/ai/ai_background.dart';
import '../../../../shared/widgets/app_spacing.dart';
import '../../../../shared/widgets/auth/auth_divider.dart';
import '../../../../shared/widgets/auth/social_button.dart';
import '../../../../shared/widgets/branding/hero_logo.dart';
import '../../../../shared/widgets/buttons/primary_button.dart';
import '../../../../shared/widgets/cards/glass_card.dart';
import '../../../../shared/widgets/textfields/primary_textfield.dart';

class LoginScreen extends StatelessWidget {

  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      body: AIBackground(

        child: SafeArea(

          child: Center(

            child: SingleChildScrollView(

              padding: const EdgeInsets.all(24),

              child: GlassCard(

                child: Column(

                  children: [

                    const HeroLogo(),

                    AppSpacing.h40,

                    const PrimaryTextField(
                      hint: "Email",
                      icon: Icons.email_outlined,
                    ),

                    AppSpacing.h20,

                    const PrimaryTextField(
                      hint: "Password",
                      icon: Icons.lock_outline,
                      obscureText: true,
                    ),

                    AppSpacing.h32,

                    PrimaryButton(
                      title: "Continue",
                      onPressed: () {},
                    ),

                    AppSpacing.h24,

                    const AuthDivider(),

                    AppSpacing.h24,

                    SocialButton(
                      icon: Icons.login,
                      title: "Continue with Google",
                      onPressed: () {},
                    ),

                    AppSpacing.h16,

                    TextButton(
                      onPressed: () {},
                      child: const Text(
                        "Continue as Guest",
                      ),
                    ),

                    TextButton(
                      onPressed: () {},
                      child: const Text(
                        "Create Account",
                      ),
                    ),

                  ],

                ),

              ),

            ),

          ),

        ),

      ),

    );

  }

}