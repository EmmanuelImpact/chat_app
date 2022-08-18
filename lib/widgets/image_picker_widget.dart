import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';

class ImagePickerWidget extends StatefulWidget {
  const ImagePickerWidget({
    super.key,
  });

  @override
  State<ImagePickerWidget> createState() => _ImagePickerWidgetState();
}

class _ImagePickerWidgetState extends State<ImagePickerWidget> {
  File? pickedImage;

  Future _pickImage() async {
    final ImagePicker pick = ImagePicker();

    /* await Permission.camera.request();
    var permissionStatus = await Permission.camera.status; */

    final pickedImageFile = await pick.pickImage(
      source: ImageSource.camera,
    );
    //final bytes = File(pickedImageFile!.path).readAsBytesSync();

    setState(() {
      // ignore: unnecessary_null_comparison

      pickedImage = File(pickedImageFile!.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 50,
          backgroundColor: Colors.grey,
          backgroundImage: pickedImage != null
              ? FileImage(
                  pickedImage!,
                )
              : null,
          child: pickedImage == null
              ? const Icon(
                  Icons.image_outlined,
                  color: Colors.white,
                )
              : null,
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
