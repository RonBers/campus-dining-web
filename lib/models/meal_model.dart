import 'package:cloud_firestore/cloud_firestore.dart';

class Meal {
  final String id;
  final String name;
  final String description;
  final String photoUrl;
  final double price;
  final DateTime dateCreated;
  final bool isHidden;

  Meal({
    required this.id,
    required this.name,
    required this.description,
    required this.photoUrl,
    required this.price,
    required this.dateCreated,
    required this.isHidden,
  });

  factory Meal.fromMap(Map<String, dynamic> map, String documentId) {
    return Meal(
        id: documentId,
        name: map['name'] as String,
        description: map['description'] as String,
        photoUrl: map['photoUrl'] as String,
        price: (map['price'] as num).toDouble(),
        dateCreated: (map['dateCreated'] as Timestamp).toDate(),
        isHidden: map['isHidden']);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'photoUrl': photoUrl,
      'price': price,
      'dateCreated': dateCreated.toIso8601String(),
      'isHidden': isHidden,
    };
  }
}
