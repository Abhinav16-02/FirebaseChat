import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'imagePickerDialog.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerHandler {
  ImagePickerDialog imagePicker;
  AnimationController _controller;
  ImagePickerListener _listener;
  dynamic _pickImageError;
  final picker = ImagePicker();
  ImagePickerHandler(this._listener, this._controller);

  openCamera() async {
    imagePicker.dismissDialog();
    try {
    var image = await picker.getImage(source: ImageSource.camera);
    cropImage(image);
    } catch (e) {
          _pickImageError = e;
     }
  }

  openGallery() async {
    imagePicker.dismissDialog();
     try {
    var image = await picker.getImage(source: ImageSource.gallery);//pickImage(source: ImageSource.gallery);
    cropImage(image);
     } catch (e) {
          _pickImageError = e;
     }
  }

  void init() {
    imagePicker = new ImagePickerDialog(this, _controller);
    imagePicker.initState();
  }

  Future cropImage(PickedFile image) async {
    File croppedFile = await ImageCropper.cropImage(
      sourcePath: image.path,
      aspectRatio: CropAspectRatio(ratioX: 1,ratioY: 1),
      maxWidth: 512,
      maxHeight: 512,
    );
    _listener.userImage(croppedFile);
  }

  showDialog(BuildContext context) {
    imagePicker.getImage(context);
  }
}

abstract class ImagePickerListener {
  userImage(File _image);
}
