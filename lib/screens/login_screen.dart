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
      authService.loginOrSignUpWithEmail(email, password);
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
            backgroundColor: const Color(0xff2F348F),
            body: Center(
              child: Container(
                // width: screenWidth * .21,
                // height: screenHeight * .51,
                width: 400,
                height: 500,
                padding: const EdgeInsets.fromLTRB(40, 0, 40, 0),
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(6)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Campus Dining App",
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextField(
                      controller: emailController,
                      decoration: const InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xff2F348F))),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey)),
                          prefixIcon: Icon(Icons.person_outline),
                          prefixIconColor: Colors.grey,
                          hintText: "Username or email",
                          hintStyle: TextStyle(color: Colors.grey)),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextField(
                      obscureText: true,
                      controller: passwordController,
                      decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xff2F348F))),
                          enabledBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey)),
                          prefixIcon: const Icon(Icons.key_outlined),
                          prefixIconColor: Colors.grey,
                          suffixIcon: IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.remove_red_eye_outlined)),
                          suffixIconColor: Colors.grey,
                          hintText: "Password",
                          hintStyle: const TextStyle(color: Colors.grey)),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      width: screenWidth,
                      child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.fromLTRB(0, 22, 0, 22),
                            backgroundColor: const Color(0xff2F348F),
                            shape: RoundedRectangleBorder(
                              side: const BorderSide(color: Color(0xff2F348F)),
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                          onPressed: () {
                            signInEmailAndPassword(context,
                                emailController.text, passwordController.text);
                          },
                          child: const Text(
                            "Log in",
                            style: TextStyle(color: Colors.white),
                          )),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      width: screenWidth,
                      child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.fromLTRB(0, 22, 0, 22),
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              side: const BorderSide(color: Colors.grey),
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                          onPressed: () => signInWithGoogle(context),
                          child: const Text(
                            "Sign in with Google",
                            style: TextStyle(color: Colors.black),
                          )),
                    ),
                    // const Divider(
                    //   color: Colors.grey,
                    //   thickness: 1,
                    //   height: 40,
                    // ),
                    // SizedBox(
                    //   width: screenWidth,
                    //   child: OutlinedButton(
                    //       style: OutlinedButton.styleFrom(
                    //         padding: const EdgeInsets.fromLTRB(0, 22, 0, 22),
                    //         backgroundColor: Colors.white,
                    //         shape: RoundedRectangleBorder(
                    //           side: const BorderSide(color: Colors.grey),
                    //           borderRadius: BorderRadius.circular(5),
                    //         ),
                    //       ),
                    //       onPressed: () => signInAnonymously(context),
                    //       child: const Text(
                    //         "Access as Guest",
                    //         style: TextStyle(color: Colors.black),
                    //       )),
                    // ),
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
