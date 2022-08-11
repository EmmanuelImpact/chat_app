import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cross_file_image/cross_file_image.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cross_file/cross_file.dart';

class ImagePickerWidget extends StatefulWidget {
  const ImagePickerWidget({
    super.key,
  });

  @override
  State<ImagePickerWidget> createState() => _ImagePickerWidgetState();
}

class _ImagePickerWidgetState extends State<ImagePickerWidget> {
  File? _pickedImage;

  Future _pickImage() async {
    final pick = ImagePicker();
    final pickedImageFile = await pick.pickImage(
      source: ImageSource.camera,
    );
    if (pickedImageFile != null) {
      setState(() {
        _pickedImage = File(pickedImageFile);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundImage: FileImage(_pickedImage!),
        ),
        // ignore: deprecated_member_use
        FlatButton.icon(
          icon: const Icon(
            Icons.image,
            color: Colors.pink,
          ),
          onPressed: _pickImage,
          label: const Text(
            'Take picture',
          ),
          textColor: Theme.of(context).primaryColor,
        )
      ],
    );
  }
}
