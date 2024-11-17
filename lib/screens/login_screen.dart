import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

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
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 20,
              ),
              const TextField(
                decoration: InputDecoration(
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
                    onPressed: () {},
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
                    onPressed: () {},
                    child: const Text(
                      "Sign in with Google",
                      style: TextStyle(color: Colors.black),
                    )),
              ),
              const Divider(
                color: Colors.grey,
                thickness: 1,
                height: 40,
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
                    onPressed: () {},
                    child: const Text(
                      "Access as Guest",
                      style: TextStyle(color: Colors.black),
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
