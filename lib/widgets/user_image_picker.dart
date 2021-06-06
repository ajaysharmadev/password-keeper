import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
///not working
class UserImagePicker extends StatefulWidget {
  UserImagePicker(this.isLoginForm);
  bool isLoginForm;
  @override
  _UserImagePickerState createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File? _image;
  final picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        if(!widget.isLoginForm) CircleAvatar(
                radius: 50,
                child: _image == null
            ? const Text('No image selected.')
            : Image.file(_image!),
                // backgroundImage: NetworkImage('https://cdn.iconscout.com/icon/premium/png-256-thumb/profile-1506810-1278719.png'),//Image.asset('assests/icon/default_profile_icon.png'),
              ),
              if(!widget.isLoginForm)
              TextButton.icon(
                style: TextButton.styleFrom(
                  primary: Theme.of(context).primaryColor,
                ), 
                onPressed: getImage,
                icon: const Icon(Icons.image),
                label: const Text('Add Image'),
              ),
      ],
    );
  }
}
