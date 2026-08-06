import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/features/authentication/application/auth_contoller.dart';

import '../../application/auth_state.dart';

import '../../../../shared/widgets/ai/ai_background.dart';
import '../../../../shared/widgets/app_spacing.dart';
import '../../../../shared/widgets/auth/auth_divider.dart';
import '../../../../shared/widgets/auth/social_button.dart';
import '../../../../shared/widgets/branding/hero_logo.dart';
import '../../../../shared/widgets/buttons/primary_button.dart';
import '../../../../shared/widgets/cards/glass_card.dart';
import '../../../../shared/widgets/textfields/primary_textfield.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(authControllerProvider);

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

                    PrimaryTextField(
                      controller: emailController,
                      hint: "Email",
                      icon: Icons.email_outlined,
                    ),

                    AppSpacing.h20,

                    PrimaryTextField(
                      controller: passwordController,
                      hint: "Password",
                      icon: Icons.lock_outline,
                      obscureText: true,
                    ),

                    AppSpacing.h32,

                    PrimaryButton(
                      title: state.status == AuthStatus.loading
                          ? "Signing In..."
                          : "Continue",
                      onPressed: state.status == AuthStatus.loading
                          ? null
                          : () {
                              ref
                                  .read(authControllerProvider.notifier)
                                  .login(
                                    email: emailController.text.trim(),
                                    password: passwordController.text,
                                  );
                            },
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