import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:workforce_app/theme/color.dart';

class UserImagePicker extends StatefulWidget {
  const UserImagePicker({super.key, required this.onPickImage});
  final void Function(File pickedImage) onPickImage;

  @override
  State<UserImagePicker> createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File? _pickedImageFile;

  void _pickImage(ImageSource source) async {
    final pickedImage = await ImagePicker().pickImage(
      source: source,
      imageQuality: 50,
    );

    if (pickedImage == null) {
      return;
    }
    setState(() {
      _pickedImageFile = File(pickedImage.path);
    });

    widget.onPickImage(_pickedImageFile!);
  }

  void _showImageSourceDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor:
            Theme.of(context).brightness == Brightness.dark ? black : white,
        title: Text(
          "Select Image Source",
          style: Theme.of(context).textTheme.titleMedium!,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              iconColor: Theme.of(context).brightness == Brightness.dark
                  ? white
                  : black,
              tileColor: Theme.of(context).brightness == Brightness.dark
                  ? bgrey
                  : grey,
              splashColor: yellow,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              leading: const Icon(Icons.camera),
              title: Text(
                "Take a Picture",
                style: Theme.of(context).textTheme.titleSmall!,
              ),
              onTap: () {
                Navigator.of(ctx).pop();
                _pickImage(ImageSource.camera);
              },
            ),
            SizedBox(height: 10),
            ListTile(
              iconColor: Theme.of(context).brightness == Brightness.dark
                  ? white
                  : black,
              tileColor: Theme.of(context).brightness == Brightness.dark
                  ? bgrey
                  : grey,
              splashColor: yellow,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              leading: const Icon(Icons.photo_library),
              title: Text(
                "Choose from Gallery",
                style: Theme.of(context).textTheme.titleSmall!,
              ),
              onTap: () {
                Navigator.of(ctx).pop();
                _pickImage(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 10),
        GestureDetector(
          onTap: _showImageSourceDialog,
          child: CircleAvatar(
            radius: 50,
            backgroundColor:
                Theme.of(context).brightness == Brightness.dark ? bgrey : grey,
            foregroundImage:
                _pickedImageFile != null ? FileImage(_pickedImageFile!) : null,
            child: _pickedImageFile == null
                ? Icon(Icons.person,
                    size: 60, color: yellow.withValues(alpha: 2))
                : null,
          ),
        ),
        const SizedBox(height: 10),
        ...(_pickedImageFile == null
            ? [
                Text(
                  'Choose Image',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 10),
              ]
            : []),
        const SizedBox(height: 10),
      ],
    );
  }
}
