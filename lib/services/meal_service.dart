import 'package:campus_dining_web/repositories/meal_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

Future<void> setMealVisibility(
    String mealId, String mealName, bool isHidden) async {
  try {
    final mealRepository = MealRepository();

    await mealRepository.updateMeal(mealId, {
      'isHidden': isHidden,
      'dateUpdated': FieldValue.serverTimestamp(),
    });

    toastification.show(
        type: ToastificationType.info,
        title: const Text("Information"),
        description: Text(
            '$mealName has been ${isHidden ? 'hidden' : 'made visible'} successfully.'),
        style: ToastificationStyle.minimal,
        autoCloseDuration: const Duration(seconds: 5));
  } catch (e) {
    toastification.show(
        type: ToastificationType.error,
        title: const Text("Oops"),
        description: const Text("Something went wrong!"),
        style: ToastificationStyle.minimal,
        autoCloseDuration: const Duration(seconds: 5));
  }
}
