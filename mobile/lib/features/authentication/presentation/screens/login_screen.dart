import 'package:flutter/material.dart';
import 'package:mobile/features/authentication/presentation/widgets/auth_button.dart';
import 'package:mobile/features/authentication/presentation/widgets/auth_hearder.dart';
import 'package:mobile/features/authentication/presentation/widgets/auth_text_fields.dart';


class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [

              const SizedBox(height: 40),

              const AuthHeader(),

              const SizedBox(height: 40),

              const AuthTextField(
                hint: "Email",
                icon: Icons.email_outlined,
              ),

              const SizedBox(height: 20),

              const AuthTextField(
                hint: "Password",
                icon: Icons.lock_outline,
                obscureText: true,
              ),

              const SizedBox(height: 30),

              AuthButton(
                text: "Continue",
                onPressed: () {},
              ),

              const SizedBox(height: 24),

              TextButton(
                onPressed: () {},
                child: const Text("Forgot Password?"),
              ),

              const Divider(height: 40),

              OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.login),
                label: const Text("Continue with Google"),
              ),

              TextButton(
                onPressed: () {},
                child: const Text("Continue as Guest"),
              ),

              TextButton(
                onPressed: () {},
                child: const Text("Create Account"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}