import 'package:campus_dining_web/repositories/meal_repository.dart';
import 'package:campus_dining_web/utils/constants/AppStyles.dart';
import 'package:campus_dining_web/services/auth_service.dart';
import 'package:campus_dining_web/widgets/add_meal_dialog.dart';
import 'package:campus_dining_web/widgets/meal_card.dart';
import 'package:flutter/material.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    final mealRepository = MealRepository();
    final screenWidth = MediaQuery.of(context).size.width;

    Future<List<Map<String, dynamic>>> fetchMeals() async {
      try {
        return await mealRepository.fetchMealsAsJson();
      } catch (e) {
        throw Exception('Failed to fetch meals: $e');
      }
    }

    void refreshDashBoard() {
      setState(() {});
    }

    return Scaffold(
        appBar: AppBar(
          // backgroundColor: AppColors.primaryColor,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Dashboard', style: TextStyle(color: Colors.black)),
              Row(
                children: [
                  SizedBox(
                    width: 110,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        // backgroundColor: ,
                        side: const BorderSide(
                            color: AppColors.primaryColor, width: 2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100),
                        ),
                      ),
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AddMealDialog(
                                  onMealSaved: refreshDashBoard);
                            });
                      },
                      child: const Text(
                        "Add Meal",
                        style: TextStyle(color: AppColors.primaryColor),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 25,
                  ),
                ],
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
                                    isHidden: meal['isHidden'],
                                    onMealUpdated: refreshDashBoard),
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
