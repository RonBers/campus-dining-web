import 'dart:typed_data';
import 'package:image_picker_web/image_picker_web.dart';

Future<Uint8List?> pickImageAsBytes() async {
  try {
    Uint8List? imageFile = await ImagePickerWeb.getImageAsBytes();

    if (imageFile != null) {
      print(imageFile);
      return imageFile;
    } else {
      return null;
    }
  } catch (e) {
    print('Error picking image: $e');
    return null;
  }
}
