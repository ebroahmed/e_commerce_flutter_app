import 'package:e_commerce_flutter_app/providers/auth_provider.dart';
import 'package:e_commerce_flutter_app/screens/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends ConsumerWidget {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(
          "Login",
          style: GoogleFonts.spectralSc(
            color: Theme.of(context).colorScheme.surface,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.only(top: 30, bottom: 20, left: 20, right: 20),
              width: 200,
              child: Image.asset('assets/images/ecommerce2.png'),
            ),
            TextField(
              keyboardType: TextInputType.emailAddress,
              style: TextStyle(color: Theme.of(context).colorScheme.primary),
              controller: emailController,
              decoration: InputDecoration(
                labelText: "Email",
                labelStyle: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
            TextField(
              controller: passwordController,
              style: TextStyle(color: Theme.of(context).colorScheme.primary),
              decoration: InputDecoration(
                labelText: "Password",
                labelStyle: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              obscureText: true,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.surface,
                backgroundColor: Theme.of(context).colorScheme.primary,
              ),
              onPressed: () async {
                try {
                  await ref
                      .read(authRepositoryProvider)
                      .signIn(emailController.text, passwordController.text);
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      content: Text(
                        "Login failed: $e",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.surface,
                        ),
                      ),
                    ),
                  );
                }
              },
              child: Text("Login"),
            ),
            SizedBox(height: 10),
            TextButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => RegisterScreen()),
              ),
              child: Text("Don't have an account? Register"),
            ),
          ],
        ),
      ),
    );
  }
}
