import 'package:campus_dining_web/utils/constants/AppStyles.dart';
import 'package:campus_dining_web/utils/functions/uploadImage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:campus_dining_web/repositories/meal_repository.dart';
import 'package:toastification/toastification.dart';

class AddMealDialog extends StatefulWidget {
  final String? mealId;
  final String? name;
  final String? description;
  final String? price;
  final String? photoUrl;
  final bool? isHidden;

  const AddMealDialog({
    super.key,
    this.mealId,
    this.name,
    this.description,
    this.price,
    this.photoUrl,
    this.isHidden,
  });

  @override
  State<AddMealDialog> createState() => _AddMealDialogState();
}

class _AddMealDialogState extends State<AddMealDialog> {
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final priceController = TextEditingController();
  bool isHidden = false;
  Uint8List? _imageBytes;

  @override
  void initState() {
    super.initState();

    if (widget.name != null) {
      nameController.text = widget.name!;
    }
    if (widget.description != null) {
      descriptionController.text = widget.description!;
    }
    if (widget.price != null) {
      priceController.text = widget.price!;
    }

    isHidden = widget.isHidden ?? false;
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
          downloadUrl = widget.photoUrl;
        }

        final timestamp = FieldValue.serverTimestamp();

        final mealJson = {
          'name': nameController.text,
          'description': descriptionController.text,
          'price': double.tryParse(priceController.text) ?? 0.0,
          'photoUrl': downloadUrl,
          'dateCreated': timestamp,
          'isHidden': isHidden,
        };

        MealRepository mealRepository = MealRepository();

        if (widget.mealId != null) {
          await mealRepository.updateMeal(widget.mealId!, mealJson);
        } else {
          await mealRepository.addMeal(mealJson);
        }
        toastification.show(
            type: ToastificationType.success,
            title: const Text("Success"),
            description:
                const Text('Your meal details have been updated successfully!'),
            style: ToastificationStyle.flatColored,
            autoCloseDuration: const Duration(seconds: 5));

        Navigator.of(context).pop();
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
    final screenWidth = MediaQuery.of(context).size.width;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Container(
        width: screenWidth > 600 ? 500 : screenWidth * 0.9,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(
                color: AppColors.primaryColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8),
                  topRight: Radius.circular(8),
                ),
              ),
              child: Center(
                child: Text(
                  widget.mealId == null ? "Add Meal" : "Edit Meal",
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
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
                      hintStyle: TextStyle(color: Colors.grey),
                    ),
                  ),
                  const SizedBox(height: 10),
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
                      hintStyle: TextStyle(color: Colors.grey),
                    ),
                  ),
                  const SizedBox(height: 10),
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
                      hintStyle: TextStyle(color: Colors.grey),
                    ),
                  ),
                  const SizedBox(height: 10),
                  if (_imageBytes != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Image.memory(
                        _imageBytes!,
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                    ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      OutlinedButton(
                        onPressed: _uploadImage,
                        child: const Text("Upload Image"),
                      ),
                      Row(
                        children: [
                          const Text("Hide Meal"),
                          Switch(
                            value: isHidden,
                            onChanged: (value) {
                              setState(() {
                                isHidden = value;
                              });
                            },
                          ),
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: _saveMeal,
                  child: const Text(
                    "Save",
                    style: TextStyle(color: AppColors.primaryColor),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    "Cancel",
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            )
          ],
        ),
      ),
    );
  }
}
