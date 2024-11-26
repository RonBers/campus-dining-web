import 'package:campus_dining_web/utils/functions/uploadImage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:campus_dining_web/repositories/meal_repository.dart';

class AddMealDialog extends StatefulWidget {
  const AddMealDialog({super.key});

  @override
  State<AddMealDialog> createState() => _AddMealDialogState();
}

class _AddMealDialogState extends State<AddMealDialog> {
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final priceController = TextEditingController();

  Uint8List? _imageBytes;

  Future<void> _uploadImage() async {
    final Uint8List? pickedImage = await pickImageAsBytes();
    if (pickedImage != null) {
      setState(() {
        _imageBytes = pickedImage;
      });
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("No image selected")));
    }
  }

  Future<void> _saveMeal() async {
    if (_imageBytes != null) {
      try {
        final storageRef = FirebaseStorage.instance
            .ref()
            .child('uploads/${DateTime.now().millisecondsSinceEpoch}.jpg');
        final uploadTask = storageRef.putData(
          _imageBytes!,
          SettableMetadata(contentType: 'image/jpeg'),
        );

        final snapshot = await uploadTask;
        final downloadUrl = await snapshot.ref.getDownloadURL();

        final timestamp = FieldValue.serverTimestamp();

        final mealJson = {
          'name': nameController.text,
          'description': descriptionController.text,
          'price': double.tryParse(priceController.text) ?? 0.0,
          'photoUrl': downloadUrl,
          'dateCreated': timestamp,
        };

        print(mealJson);

        MealRepository mealRepository = MealRepository();
        await mealRepository.addMeal(mealJson);
      } catch (e) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please upload an image")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Add Meal"),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xff2F348F))),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey)),
                  hintText: "Name",
                  hintStyle: TextStyle(color: Colors.grey)),
            ),
            TextField(
              controller: descriptionController,
              minLines: 4,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              decoration: const InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xff2F348F))),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey)),
                  hintText: "Description",
                  hintStyle: TextStyle(color: Colors.grey)),
            ),
            TextField(
              keyboardType: TextInputType.number,
              controller: priceController,
              decoration: const InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xff2F348F))),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey)),
                  hintText: "Price",
                  hintStyle: TextStyle(color: Colors.grey)),
            ),
            OutlinedButton(
              onPressed: () {
                _uploadImage();
              },
              child: const Text("Upload Image"),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            _saveMeal();
          },
          child: const Text("Add"),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text("Cancel"),
        ),
      ],
    );
  }
}
