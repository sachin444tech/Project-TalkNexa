import 'package:flutter/material.dart';


import 'package:mobile/features/authentication/presentation/widgets/auth_button.dart';
import 'package:mobile/features/authentication/presentation/widgets/auth_footer.dart';
import 'package:mobile/features/authentication/presentation/widgets/auth_hearder.dart';
import 'package:mobile/features/authentication/presentation/widgets/email_field.dart';
import 'package:mobile/features/authentication/presentation/widgets/password_field.dart';
import 'package:mobile/features/authentication/presentation/widgets/social_login_button.dart';



class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

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
                  child: const Text("Forgot Password?"),
                ),
              ),

              const SizedBox(height: 10),

              AuthButton(
                text: "Sign In",
                onPressed: () {},
              ),

              const SizedBox(height: 20),

              const Center(
                child: Text("OR"),
              ),

              const SizedBox(height: 20),

              SocialLoginButton(
                onPressed: () {},
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