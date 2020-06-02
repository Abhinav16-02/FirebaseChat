import 'dart:io';
import 'dart:async';
import 'package:image_picker/image_picker.dart';

class CommonImagePicker {
  final picker = ImagePicker();

  Future<File> getImageFromGallery() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    return File(pickedFile.path);
  }

  Future<File> getImagefromCamera() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);
    return File(pickedFile.path);
  }
}
