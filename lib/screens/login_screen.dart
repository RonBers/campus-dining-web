import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Center(
        child: Container(
          width: screenWidth * .25,
          height: screenHeight * .50,
          padding: const EdgeInsets.all(40),
          decoration: BoxDecoration(border: Border.all(color: Colors.black)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const TextField(
                decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: "Username or email",
                    hintStyle: TextStyle(color: Colors.grey)),
              ),
              const TextField(
                decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: "Password",
                    hintStyle: TextStyle(color: Colors.grey)),
              ),
              OutlinedButton(onPressed: () {}, child: const Text("Log in")),
              OutlinedButton(
                  onPressed: () {}, child: const Text("Sign in with Google")),
              const SizedBox(
                height: 25,
              ),
              OutlinedButton(
                  onPressed: () {}, child: const Text("Access as Guest")),
            ],
          ),
        ),
      ),
    );
  }
}
