import 'package:campus_dining_web/utils/constants/AppStyles.dart';
import 'package:campus_dining_web/services/auth_service.dart';
import 'package:campus_dining_web/widgets/meal_card.dart';
import 'package:flutter/material.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    Future<void> signOut(BuildContext context) async {
      final authService = AuthService();
      await authService.signOut(context);
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Text('App')],
        ),
      ),
      backgroundColor: Colors.white12,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(
              height: 340,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 5,
                itemBuilder: (context, index) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5),
                    child: MealCard(),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            // Logout Button
            SizedBox(
              width: 300,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.fromLTRB(0, 22, 0, 22),
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(color: Colors.grey),
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                onPressed: () {
                  signOut(context);
                },
                child: const Text(
                  'Logout',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
