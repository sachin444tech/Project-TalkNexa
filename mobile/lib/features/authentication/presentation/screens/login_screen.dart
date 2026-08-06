import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:mobile/features/authentication/application/auth_contoller.dart';
import 'package:mobile/features/authentication/application/auth_state.dart';
import 'package:mobile/shared/widgets/ai/ai_background.dart';

import '../../../../shared/widgets/branding/hero_logo.dart';
import '../../../../shared/widgets/auth/email_text_field.dart';
import '../../../../shared/widgets/auth/password_text_field.dart';
import '../../../../shared/widgets/buttons/primary_button.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() =>
      _LoginScreenState();
}

class _LoginScreenState
    extends ConsumerState<LoginScreen> {
  final emailController =
      TextEditingController();

  final passwordController =
      TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
  super.initState();

  Future.microtask(() {
    ref.listenManual<AuthState>(
      authControllerProvider,
      (previous, next) {
        if (!mounted) return;

        if (next.status == AuthStatus.error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                next.message!,
              ),
            ),
          );
        }
      },
    );
  });
}

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(authControllerProvider);

    return Scaffold(
      body: AIBackground(
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding:
                  const EdgeInsets.all(24),
              child: Card(
                elevation: 12,
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(30),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize:
                        MainAxisSize.min,
                    children: [
                      const HeroLogo(),
                      const SizedBox(height: 32),

                      EmailTextField(
                        controller:
                            emailController,
                      ),

                      const SizedBox(height: 20),

                      PasswordTextField(
                        controller:
                            passwordController,
                      ),

                      const SizedBox(height: 32),

                      PrimaryButton(
                        title: "Continue",
                        
                        isLoading: state.status == AuthStatus.loading,

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

                      const SizedBox(height: 20),

                      TextButton(
                        onPressed: () {},
                        child: const Text(
                          "Forgot Password?",
                        ),
                      ),

                      const Divider(),

                      OutlinedButton.icon(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.g_mobiledata,
                        ),
                        label: const Text(
                          "Continue with Google",
                        ),
                      ),

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
      ),
    );
  }
}