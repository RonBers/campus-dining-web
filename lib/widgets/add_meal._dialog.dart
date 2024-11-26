import 'package:campus_dining_web/utils/functions/uploadImage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:campus_dining_web/repositories/meal_repository.dart';

class AddMealDialog extends StatefulWidget {
  final String? mealId; // Optional, only used for editing
  final String? name;
  final String? description;
  final String? price;
  final String? photoUrl;

  const AddMealDialog({
    super.key,
    this.mealId, // Optional for editing
    this.name,
    this.description,
    this.price,
    this.photoUrl,
  });

  @override
  State<AddMealDialog> createState() => _AddMealDialogState();
}

class _AddMealDialogState extends State<AddMealDialog> {
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final priceController = TextEditingController();
  Uint8List? _imageBytes;

  @override
  void initState() {
    super.initState();

    // If editing, populate the form with existing data
    if (widget.name != null) {
      nameController.text = widget.name!;
    }
    if (widget.description != null) {
      descriptionController.text = widget.description!;
    }
    if (widget.price != null) {
      priceController.text = widget.price!;
    }
  }

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
    if (_imageBytes != null || widget.photoUrl != null) {
      try {
        String? downloadUrl;

        if (_imageBytes != null) {
          final storageRef = FirebaseStorage.instance
              .ref()
              .child('uploads/${DateTime.now().millisecondsSinceEpoch}.jpg');
          final uploadTask = storageRef.putData(
            _imageBytes!,
            SettableMetadata(contentType: 'image/jpeg'),
          );

          final snapshot = await uploadTask;
          downloadUrl = await snapshot.ref.getDownloadURL();
        } else {
          downloadUrl = widget
              .photoUrl; // Keep the existing image if not uploading a new one
        }

        final timestamp = FieldValue.serverTimestamp();

        final mealJson = {
          'name': nameController.text,
          'description': descriptionController.text,
          'price': double.tryParse(priceController.text) ?? 0.0,
          'photoUrl': downloadUrl,
          'dateCreated': timestamp,
        };

        MealRepository mealRepository = MealRepository();

        if (widget.mealId != null) {
          // Editing: Update the existing meal
          await mealRepository.updateMeal(widget.mealId!, mealJson);
        } else {
          // Adding new meal
          await mealRepository.addMeal(mealJson);
        }

        Navigator.of(context).pop(); // Close the dialog
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
      title: Text(widget.mealId == null ? "Add Meal" : "Edit Meal"),
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
          onPressed: _saveMeal,
          child: const Text("Save"),
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
