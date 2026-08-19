import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:mobile/features/authentication/application/auth_contoller.dart';
import 'package:mobile/features/authentication/application/auth_state.dart';
import 'package:mobile/features/authentication/presentation/widgets/auth_button.dart';
import 'package:mobile/features/authentication/presentation/widgets/auth_footer.dart';
import 'package:mobile/features/authentication/presentation/widgets/auth_hearder.dart';
import 'package:mobile/features/authentication/presentation/widgets/email_field.dart';
import 'package:mobile/features/authentication/presentation/widgets/password_field.dart';
import 'package:mobile/features/authentication/presentation/widgets/social_login_button.dart';
import 'package:mobile/features/home/presentation/screens/home_screen.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();

    ref.listenManual(authControllerProvider, (previous, next) {
      if (!mounted) return;

      if (next.status == AuthStatus.authenticated) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Welcome back to TalkNexa! 👋')),
        );

        // Home navigation will be added here
        if (next.status == AuthStatus.authenticated) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const HomeScreen()),
            (route) => false,
          );
        }
      }

      if (next.status == AuthStatus.error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.errorMessage ?? 'Something went wrong.')),
        );
      }
    });
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();

    super.dispose();
  }

  Future<void> _signIn() async {
    FocusScope.of(context).unfocus();

    final email = emailController.text.trim();
    final password = passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your email and password.')),
      );

      return;
    }

    await ref
        .read(authControllerProvider.notifier)
        .signIn(email: email, password: password);
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,

            children: [
              const SizedBox(height: 40),

              const AuthHeader(),

              const SizedBox(height: 40),

              EmailField(controller: emailController),

              const SizedBox(height: 20),

              PasswordField(controller: passwordController),

              Align(
                alignment: Alignment.centerRight,

                child: TextButton(
                  onPressed: () {},
                  child: const Text('Forgot Password?'),
                ),
              ),

              const SizedBox(height: 10),

              authState.isLoading
                  ? const SizedBox(
                      height: 58,

                      child: Center(child: CircularProgressIndicator()),
                    )
                  : AuthButton(text: 'Sign In', onPressed: _signIn),

              const SizedBox(height: 20),

              const Center(child: Text('OR')),

              const SizedBox(height: 20),

              SocialLoginButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Google Sign-In will be available soon.'),
                    ),
                  );
                },
              ),

              const SizedBox(height: 25),

              const AuthFooter(),
            ],
          ),
        ),
      ),
    );
  }
}
