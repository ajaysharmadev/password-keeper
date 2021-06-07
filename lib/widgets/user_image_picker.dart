import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  UserImagePicker(this.isLoginForm, this.imagePickFn);
  final void Function(File pickedImage) imagePickFn;
  bool isLoginForm;
  @override
  _UserImagePickerState createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File? _image;
  final picker = ImagePicker();

  Future getImagefromCamera() async {
    final pickedImage = await picker.getImage(
        source: ImageSource.gallery,
        imageQuality: 50,
        maxHeight: 512,
        maxWidth: 512);

    setState(() {
      if (pickedImage != null) {
        _image = File(pickedImage.path);
      } else {
        print('No image selected.');
      }
    });
    widget.imagePickFn(_image!);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        if (!widget.isLoginForm)
          CircleAvatar(
            radius: 50,
            child: _image == null
                ? const Center(child: Text('No image selected.'))
                : null,
            backgroundImage: _image != null ? FileImage(_image!) : null,
          ),
        if (!widget.isLoginForm)
          TextButton.icon(
            style: TextButton.styleFrom(
              primary: Theme.of(context).primaryColor,
            ),
            onPressed: getImagefromCamera,
            icon: const Icon(Icons.image),
            label: const Text('Add Image'),
          ),
      ],
    );
  }
}
