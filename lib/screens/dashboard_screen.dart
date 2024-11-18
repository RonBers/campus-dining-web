import 'package:campus_dining_web/services/auth_service.dart';
import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Future<void> signOut(BuildContext context) async {
      final authService = AuthService();
      await authService.signOut();
    }

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Text('Hello'),
            ElevatedButton(
                onPressed: () {
                  signOut(context);
                },
                child: const Text('Logout'))
          ],
        ),
      ),
      body: const Center(
        child: Text("Dashboard"),
      ),
    );
  }
}
