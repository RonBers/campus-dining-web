import 'package:campus_dining_web/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:campus_dining_web/screens/dashboard_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, auth});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Error"),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  // Log in with Google
  Future<void> signInWithGoogle(BuildContext context) async {
    final authService = AuthService();
    User? user = await authService.signInWithGoogle();
    if (user == null) {
      showErrorDialog(context, "Failed to sign in with Google.");
    }
  }

  // Log in anonymously
  Future<void> signInAnonymously(BuildContext context) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInAnonymously();
      print("Signed in as guest: ${userCredential.user?.uid}");
    } catch (e) {
      showErrorDialog(context, "Failed to sign in as guest.");
    }
  }

  // Log email and password
  Future<void> signInEmailAndPassword(
      BuildContext context, String email, String password) async {
    try {
      final authService = AuthService();
      authService.signUpWithEmail(email, password);
    } catch (e) {
      showErrorDialog(context, "Failed to sign in as guest.");
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Scaffold(
            body: Center(
              child: Container(
                width: screenWidth * .25,
                height: screenHeight * .50,
                padding: const EdgeInsets.all(40),
                decoration:
                    BoxDecoration(border: Border.all(color: Colors.black)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextField(
                      controller: emailController,
                      decoration: const InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: "Username or email",
                        hintStyle: TextStyle(color: Colors.grey),
                      ),
                    ),
                    TextField(
                      obscureText: true,
                      controller: passwordController,
                      decoration: const InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: "Password",
                        hintStyle: TextStyle(color: Colors.grey),
                      ),
                    ),
                    const SizedBox(height: 20),
                    OutlinedButton(
                      onPressed: () {
                        signInEmailAndPassword(context, emailController.text,
                            passwordController.text);
                      },
                      child: const Text("Log in"),
                    ),
                    OutlinedButton(
                      onPressed: () => signInWithGoogle(context),
                      child: const Text("Sign in with Google"),
                    ),
                    const SizedBox(height: 25),
                    OutlinedButton(
                      onPressed: () => signInAnonymously(context),
                      child: const Text("Access as Guest"),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
        return const DashboardScreen();
      },
    );
  }
}
