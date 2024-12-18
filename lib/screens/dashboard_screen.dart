import 'package:campus_dining_web/repositories/meal_repository.dart';
import 'package:campus_dining_web/utils/constants/AppStyles.dart';
import 'package:campus_dining_web/widgets/add_meal_dialog.dart';
import 'package:campus_dining_web/widgets/meal_card.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
      backgroundColor: Colors.white12,
      body: FutureBuilder<List<Map<String, dynamic>>>(
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Dashboard',
                            style: GoogleFonts.poppins(
                                fontSize: 18, color: AppColors.primaryColor)),
                        SizedBox(
                          width: 110,
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 18),
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
                                    onMealSaved: refreshDashBoard,
                                  );
                                },
                              );
                            },
                            child: const Text(
                              "Add Meal",
                              style: TextStyle(color: AppColors.primaryColor),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: screenWidth > 1000
                            ? 5
                            : screenWidth > 600
                                ? 3
                                : 1,
                        mainAxisSpacing: 5,
                        crossAxisSpacing: 5,
                        childAspectRatio: 200 / 190,
                      ),
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: meals.length,
                      itemBuilder: (context, index) {
                        final meal = meals[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: MealCard(
                            mealId: meal['id'] as String,
                            name: meal['name'] as String,
                            description: meal['description'] as String,
                            photoUrl: meal['photoUrl'] as String,
                            price: meal['price'].toString(),
                            isHidden: meal['isHidden'],
                            onMealUpdated: refreshDashBoard,
                          ),
                        );
                      },
                    ),
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
