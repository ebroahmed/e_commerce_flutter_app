import 'package:e_commerce_flutter_app/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class RegisterScreen extends ConsumerWidget {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  RegisterScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onPrimary,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Theme.of(context).colorScheme.surface),
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(
          "Register",
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
                      child: Image.asset('assets/images/icon.png'),
                    ),
                    TextField(
                      controller: emailController,

                      keyboardType: TextInputType.emailAddress,
                      style: TextStyle(
                        decorationColor: Theme.of(context).colorScheme.surface,
                        color: Theme.of(context).colorScheme.primary,
                      ),
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
                              .register(
                                emailController.text,
                                passwordController.text,
                              );

                          // Logout to force login manually
                          await ref.read(authRepositoryProvider).logout();

                          // Navigate back to login screen
                          Navigator.pop(context);

                          //  Show message
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: Theme.of(
                                context,
                              ).colorScheme.primary,
                              content: Text(
                                'Account created! Please login.',
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.surface,
                                ),
                              ),
                            ),
                          );
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: Theme.of(
                                context,
                              ).colorScheme.error,
                              content: Text(
                                'Registration failed: $e',
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.surface,
                                ),
                              ),
                            ),
                          );
                        }
                      },
                      child: Text("Sign Up"),
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
