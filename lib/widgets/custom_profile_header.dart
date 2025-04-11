import 'dart:io';
import 'package:flutter/material.dart';
import 'package:workforce_app/theme/color.dart';
import 'package:image_picker/image_picker.dart';

class CustomProfileHeader extends StatefulWidget {
  final String? imageUrl;
  final String? dpImageUrl;
  final void Function(File pickedProfileImage) onPickProfileImage;
  final void Function(File pickedDesktopImage) onPickDesktopImage;

  const CustomProfileHeader({
    super.key,
    required this.imageUrl,
    required this.dpImageUrl,
    required this.onPickProfileImage,
    required this.onPickDesktopImage,
  });

  @override
  State<CustomProfileHeader> createState() => _CustomProfileHeaderState();
}

class _CustomProfileHeaderState extends State<CustomProfileHeader> {
  File? _pickedImage;
  File? _pickedProfileImage;
  File? _pickedDesktopImage;

  void _pickImage(ImageSource source, bool isProfile) async {
    final pickedImage = await ImagePicker().pickImage(
      source: source,
      imageQuality: 50,
    );

    if (pickedImage == null) return;

    setState(() {
      _pickedImage = File(pickedImage.path);
      if (isProfile) {
        _pickedProfileImage = _pickedImage!;
        widget.onPickProfileImage(_pickedImage!);
      } else {
        _pickedDesktopImage = _pickedImage!;
        widget.onPickDesktopImage(_pickedImage!);
      }
    });
  }

  void _showImageSourceDialog(bool isProfile) {
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
                _pickImage(ImageSource.camera, isProfile);
              },
            ),
            SizedBox(
              height: 10,
            ),
            ListTile(
              tileColor: Theme.of(context).brightness == Brightness.dark
                  ? bgrey
                  : grey,
              iconColor: Theme.of(context).brightness == Brightness.dark
                  ? white
                  : black,
              splashColor: yellow,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              leading: const Icon(Icons.photo_library),
              title: Text("Choose from Gallery",
                  style: Theme.of(context).textTheme.titleSmall!),
              onTap: () {
                Navigator.of(ctx).pop();
                _pickImage(ImageSource.gallery, isProfile);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Background Image
        Container(
          margin: EdgeInsets.only(bottom: 50),
          height: 150,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            image: (_pickedDesktopImage != null)
                ? DecorationImage(
                    image: FileImage(_pickedDesktopImage!),
                    fit: BoxFit.cover,
                  )
                : (widget.dpImageUrl != null && widget.dpImageUrl!.isNotEmpty)
                    ? DecorationImage(
                        image: NetworkImage(widget.dpImageUrl!),
                        fit: BoxFit.cover,
                      )
                    : null,
            gradient: (_pickedDesktopImage == null &&
                    (widget.dpImageUrl == null || widget.dpImageUrl!.isEmpty))
                ? LinearGradient(colors: [grey, grey])
                : null,
          ),
        ),

        // Background Edit Icon
        Positioned(
          top: 10,
          right: 10,
          child: GestureDetector(
            onTap: () => _showImageSourceDialog(false), // Profile picture
            child: CircleAvatar(
              radius: 16,
              backgroundColor: red,
              child: Icon(Icons.edit, color: white, size: 18),
            ),
          ),
        ),

        // Profile Picture
        Positioned(
          bottom: 0,
          left: 0,
          child: Stack(
            alignment: Alignment.center,
            children: [
              CircleAvatar(
                backgroundImage: _pickedProfileImage != null
                    ? FileImage(_pickedProfileImage!)
                    : (widget.imageUrl != null && widget.imageUrl!.isNotEmpty)
                        ? NetworkImage(widget.imageUrl!)
                        : null,
                radius: 50,
                backgroundColor: yellow,
                child: (_pickedProfileImage == null &&
                        (widget.imageUrl == null || widget.imageUrl!.isEmpty))
                    ? Icon(Icons.person, size: 50, color: Colors.white)
                    : null,
              ),

              // Profile Edit Icon
              Positioned(
                bottom: 0,
                right: 0,
                child: GestureDetector(
                  onTap: () => _showImageSourceDialog(true), // Profile picture
                  child: CircleAvatar(
                    radius: 16,
                    backgroundColor: red,
                    child: Icon(Icons.edit, color: white, size: 18),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
