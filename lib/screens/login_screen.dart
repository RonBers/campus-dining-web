import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:campus_dining_web/services/auth_service.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  // Log in with email and password
  Future<void> signInEmailAndPassword(
      BuildContext context, String email, String password) async {
    final authService = AuthService();
    await authService.loginWithEmail(email, password, context);
  }

  @override
  void dispose() {
    _focusNode.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: AuthService().authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.hasData) {
            return const SizedBox.shrink();
          } else {
            return KeyboardListener(
                focusNode: _focusNode,
                autofocus: true,
                onKeyEvent: (event) {
                  if (event is KeyDownEvent &&
                      event.logicalKey == LogicalKeyboardKey.enter) {
                    signInEmailAndPassword(
                      context,
                      emailController.text,
                      passwordController.text,
                    );
                  }
                },
                child: Scaffold(
                  backgroundColor: const Color(0xff2F348F),
                  body: Center(
                    child: Container(
                      width: 400,
                      height: 500,
                      padding: const EdgeInsets.fromLTRB(40, 0, 40, 20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/img/app_logo.png',
                            width: 100,
                          ),
                          Text("AdduEats",
                              style: GoogleFonts.poppins(
                                  fontSize: 40, fontWeight: FontWeight.bold)),
                          const SizedBox(
                            height: 20,
                          ),
                          TextField(
                            controller: emailController,
                            decoration: const InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                focusedBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Color(0xff2F348F))),
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
                            decoration: const InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                focusedBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Color(0xff2F348F))),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey)),
                                prefixIcon: Icon(Icons.key_outlined),
                                prefixIconColor: Colors.grey,
                                hintText: "Password",
                                hintStyle: TextStyle(color: Colors.grey)),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 22),
                                backgroundColor: const Color(0xff2F348F),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                              onPressed: () {
                                signInEmailAndPassword(
                                  context,
                                  emailController.text,
                                  passwordController.text,
                                );
                              },
                              child: const Text(
                                "Log in",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                                backgroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                              onPressed: () {
                                AuthService().signInWithGoogle(context);
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                      'assets/img/g-logo-transparent.png',
                                      height: 35,
                                      fit: BoxFit.contain),
                                  const SizedBox(
                                    width: 4,
                                  ),
                                  const Text(
                                    "Sign in with Google",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ));
          }
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
