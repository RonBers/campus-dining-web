import 'package:campus_dining_web/repositories/meal_repository.dart';
import 'package:campus_dining_web/utils/constants/AppStyles.dart';
import 'package:campus_dining_web/services/auth_service.dart';
import 'package:campus_dining_web/widgets/meal_card.dart';
import 'package:flutter/material.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final mealRepository = MealRepository();
    final screenWidth = MediaQuery.of(context).size.width;

    Future<void> signOut(BuildContext context) async {
      final authService = AuthService();
      await authService.signOut(context);
    }

    Future<List<Map<String, dynamic>>> fetchMeals() async {
      try {
        return await mealRepository.fetchMealsAsJson();
      } catch (e) {
        throw Exception('Failed to fetch meals: $e');
      }
    }

    return Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.primaryColor,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Dashboard', style: TextStyle(color: Colors.white)),
              IconButton(
                onPressed: () {
                  signOut(context);
                },
                icon: const Icon(
                  Icons.logout,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
        backgroundColor: Colors.white12,
        body: Center(
          child: FutureBuilder<List<Map<String, dynamic>>>(
            future: fetchMeals(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('Error: ${snapshot.error}'),
                );
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('No meals available.'));
              } else {
                final meals = snapshot.data!;
                return SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height,
                          child: GridView.builder(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: screenWidth > 1000
                                  ? 5
                                  : screenWidth > 600
                                      ? 3
                                      : 1,
                              mainAxisSpacing: 5,
                              crossAxisSpacing: 5,
                              childAspectRatio: 200 / 190,
                            ),
                            itemCount: meals.length,
                            itemBuilder: (context, index) {
                              final meal = meals[index];
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5),
                                child: MealCard(
                                  mealId: meal['id'] as String,
                                  name: meal['name'] as String,
                                  description: meal['description'] as String,
                                  photoUrl: meal['photoUrl'] as String,
                                  price: meal['price'].toString(),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                );
              }
            },
          ),
        ));
  }
}
