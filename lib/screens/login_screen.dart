import 'package:e_commerce_flutter_app/providers/auth_provider.dart';
import 'package:e_commerce_flutter_app/screens/register_screen.dart';
import 'package:e_commerce_flutter_app/services/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends ConsumerWidget {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final _notificationService = NotificationService();

  LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onPrimary,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(
          "Login",
          style: GoogleFonts.spectralSc(
            color: Theme.of(context).colorScheme.surface,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight:
                    MediaQuery.of(context).size.height -
                    MediaQuery.of(context).viewInsets.bottom,
              ),
              child: IntrinsicHeight(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: EdgeInsets.only(
                        top: 30,
                        bottom: 20,
                        left: 20,
                        right: 20,
                      ),
                      width: 200,
                      child: Image.asset('assets/images/ecommerce2.png'),
                    ),
                    // SizedBox(height: 30),
                    TextField(
                      keyboardType: TextInputType.emailAddress,
                      style: TextStyle(
                        decorationColor: Theme.of(context).colorScheme.surface,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      controller: emailController,
                      decoration: InputDecoration(
                        labelText: "Email",
                        labelStyle: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                    Consumer(
                      builder: (context, ref, _) {
                        final isHidden = ref.watch(passwordVisibilityProvider);

                        return TextField(
                          controller: passwordController,
                          obscureText: isHidden,
                          style: TextStyle(
                            decorationColor: Theme.of(
                              context,
                            ).colorScheme.surface,
                            color: Theme.of(context).colorScheme.primary,
                            decoration: TextDecoration.none,
                          ),
                          decoration: InputDecoration(
                            labelText: "Password",
                            labelStyle: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                isHidden
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              onPressed: () {
                                ref
                                        .read(
                                          passwordVisibilityProvider.notifier,
                                        )
                                        .state =
                                    !isHidden;
                              },
                            ),
                          ),
                        );
                      },
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
                              .signIn(
                                emailController.text,
                                passwordController.text,
                              );

                          // Call the welcome notification
                          await _notificationService
                              .showWelcomeNotificationIfFirstTime();
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: Theme.of(
                                context,
                              ).colorScheme.error,
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
            ),
          ),
        ),
      ),
    );
  }
}
