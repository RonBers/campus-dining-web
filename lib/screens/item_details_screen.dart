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
        title: const Text(
          'Meal Details',
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primaryColor),
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
            return LayoutBuilder(
              builder: (context, constraints) {
                return Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1200),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Flexible(
                          flex: 2,
                          child: Image.network(
                            meal['photoUrl'] ?? '',
                            height: 350,
                            fit: BoxFit.contain,
                          ),
                        ),
                        // const SizedBox(width: 20),
                        Flexible(
                          flex: 3,
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
                                softWrap: true,
                                overflow: TextOverflow.clip,
                              ),
                              const SizedBox(height: 20),
                              OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  padding:
                                      const EdgeInsets.fromLTRB(50, 15, 50, 15),
                                  backgroundColor: AppColors.primaryColor,
                                  side: const BorderSide(
                                      color: AppColors.primaryColor),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                ),
                                onPressed: null,
                                child: Text(
                                  '₱ ${(meal['price'] ?? 0).toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              Text(
                                meal['description'] ?? 'No Description',
                                style: const TextStyle(fontSize: 20),
                                softWrap: true,
                                overflow: TextOverflow.clip,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
