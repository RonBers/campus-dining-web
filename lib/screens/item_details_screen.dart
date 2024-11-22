import 'package:campus_dining_web/repositories/meal_repository.dart';
import 'package:campus_dining_web/utils/constants/AppStyles.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ItemDetailsScreen extends StatelessWidget {
  final String mealId;

  const ItemDetailsScreen({super.key, required this.mealId});

  Future<Map<String, dynamic>> fetchMealById(String mealId) async {
    final mealRepository = MealRepository();
    return await mealRepository.fetchMealByIdAsJson(mealId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white12,
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        title:
            const Text('Meal Details', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            if (Navigator.canPop(context)) {
              context.pop();
            } else {
              context.go('/dashboard');
            }
          },
        ),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: fetchMealById(mealId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData) {
            return const Center(child: Text('Meal not found.'));
          } else {
            final meal = snapshot.data!;
            return Center(
              child: Container(
                height: 700,
                width: 1200,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Image.network(
                      meal['photoUrl'] ?? '',
                      height: 350,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(width: 50),
                    SizedBox(
                      width: 500,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            meal['name'] ?? 'No Name',
                            style: const TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            meal['description'] ?? 'No Description',
                            style: const TextStyle(fontSize: 20),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            'Php ${(meal['price'] ?? 0).toString()}',
                            style: const TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
