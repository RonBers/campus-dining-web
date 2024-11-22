import 'package:campus_dining_web/models/meal_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MealRepository {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final CollectionReference mealsCollection =
      FirebaseFirestore.instance.collection('items');

  Future<List<Map<String, dynamic>>> fetchMealsAsJson() async {
    try {
      final querySnapshot = await mealsCollection.get();
      return querySnapshot.docs.map((doc) {
        final meal = Meal.fromMap(doc.data() as Map<String, dynamic>, doc.id);
        return meal.toJson();
      }).toList();
    } catch (e) {
      throw Exception('Failed to fetch meals: $e');
    }
  }

  Future<Map<String, dynamic>> fetchMealByIdAsJson(String id) async {
    try {
      final docSnapshot = await mealsCollection.doc(id).get();
      if (docSnapshot.exists) {
        final meal = Meal.fromMap(
            docSnapshot.data() as Map<String, dynamic>, docSnapshot.id);
        return meal.toJson();
      } else {
        throw Exception('Meal not found');
      }
    } catch (e) {
      throw Exception('Failed to fetch meal: $e');
    }
  }

//Other Func for future use
  // Future<void> addMeal(Map<String, dynamic> mealJson) async {
  //   try {
  //     await mealsCollection.add(mealJson);
  //   } catch (e) {
  //     throw Exception('Failed to add meal: $e');
  //   }
  // }

  // Future<void> updateMeal(
  //     String id, Map<String, dynamic> updatedMealJson) async {
  //   try {
  //     await mealsCollection.doc(id).update(updatedMealJson);
  //   } catch (e) {
  //     throw Exception('Failed to update meal: $e');
  //   }
  // }

  // Future<void> deleteMeal(String id) async {
  //   try {
  //     await mealsCollection.doc(id).delete();
  //   } catch (e) {
  //     throw Exception('Failed to delete meal: $e');
  //   }
  // }
}
