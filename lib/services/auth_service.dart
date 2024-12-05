import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:toastification/toastification.dart';

class AuthService {
  final FirebaseAuth auth = FirebaseAuth.instance;

  Stream<User?> get authStateChanges =>
      FirebaseAuth.instance.authStateChanges();

  bool isAuthenticated() {
    return auth.currentUser != null;
  }

  // Google
  Future<User?> signInWithGoogle(BuildContext context) async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn(
        clientId:
            '813218655539-aa1vuuvg8d7lnfqpd7s2jpse82utthpq.apps.googleusercontent.com',
      );
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        return null;
      }
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential =
          await auth.signInWithCredential(credential);

      if (context.mounted) {
        toastification.show(
          type: ToastificationType.success,
          title: const Text("Welcome back"),
          description: Text(userCredential.user?.email ?? ""),
          style: ToastificationStyle.minimal,
          autoCloseDuration: const Duration(seconds: 5),
        );
        context.go('/dashboard');
      }
      return null;
    } catch (e) {
      toastification.show(
        type: ToastificationType.success,
        title: const Text("Oops! Something went wrong!"),
        description: Text('Google Sign-In Error: $e'),
        style: ToastificationStyle.minimal,
        autoCloseDuration: const Duration(seconds: 5),
      );
      return null;
    }
  }

// Register Email and Password
  Future<User?> signUpWithEmail(
      String email, String password, BuildContext context) async {
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (context.mounted) {
        toastification.show(
          type: ToastificationType.success,
          title: const Text("Welcome"),
          description: Text(email),
          style: ToastificationStyle.minimal,
          autoCloseDuration: const Duration(seconds: 5),
        );

        context.go('/dashboard');
      }
    } on FirebaseAuthException catch (e) {
      toastification.show(
        type: ToastificationType.success,
        title: const Text("Oops! Something went wrong!"),
        description: Text('$e'),
        style: ToastificationStyle.minimal,
        autoCloseDuration: const Duration(seconds: 5),
      );
      return null;
    }
  }

  // Login email password
  Future<User?> loginWithEmail(
      String email, String password, BuildContext context) async {
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      if (context.mounted) {
        toastification.show(
          type: ToastificationType.success,
          title: const Text("Welcome back"),
          description: Text(email),
          style: ToastificationStyle.minimal,
          autoCloseDuration: const Duration(seconds: 5),
        );

        context.go('/dashboard');
      }
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      String message = '';
      if (e.code == 'invalid-credential') {
        message = "Invalid email or password. Please try again.";
      } else {
        message = "Something went wrong. Please try again.";
      }
      toastification.show(
          type: ToastificationType.error,
          title: const Text("Oops"),
          description: Text(message),
          style: ToastificationStyle.minimal,
          autoCloseDuration: const Duration(seconds: 5));
    }
  }

  //Anonymous
  Future<User?> signInAnonymously() async {
    try {
      final userCredential = await FirebaseAuth.instance.signInAnonymously();
      print("Signed in with temporary account: ${userCredential.user?.uid}");
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "operation-not-allowed":
          print("Anonymous auth hasn't been enabled for this project.");
          break;
        default:
          print("Unknown error: ${e.message}");
      }
      return null;
    }
  }

  Future<void> signOut(BuildContext context) async {
    await auth.signOut();
    if (context.mounted) {
      context.go('/login');
    }
  }
}
