import 'package:campus_dining_web/repositories/meal_repository.dart';
import 'package:campus_dining_web/utils/constants/AppStyles.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class AddMealScreen extends StatelessWidget {
  const AddMealScreen({super.key});

  Future<Map<String, dynamic>> fetchMealById(String mealId) async {
    final mealRepository = MealRepository();
    return await mealRepository.fetchMealByIdAsJson(mealId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white12,
        appBar: AppBar(
          centerTitle: false,
          title: Text(
            'Add meal',
            style: GoogleFonts.poppins(fontSize: 20),
          ),
        ),
        body: Container());
  }
}
