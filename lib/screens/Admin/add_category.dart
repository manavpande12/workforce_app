import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:workforce_app/services/get_category_data.dart';
import 'package:workforce_app/theme/color.dart';
import 'package:workforce_app/widgets/custom_button.dart';
import 'package:workforce_app/widgets/custom_dropdown.dart';
import 'package:workforce_app/widgets/custom_error.dart';
import 'package:workforce_app/widgets/custom_input.dart';

class AddCategory {
  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      enableDrag: false,
      backgroundColor:
          Theme.of(context).brightness == Brightness.dark ? black : white,
      builder: (context) {
        return const AddCategoryScreen();
      },
    );
  }
}

class AddCategoryScreen extends StatefulWidget {
  const AddCategoryScreen({super.key});

  @override
  State<AddCategoryScreen> createState() => _AddCategoryScreenState();
}

class _AddCategoryScreenState extends State<AddCategoryScreen> {
  final user = FirebaseAuth.instance.currentUser;
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  String? _selectedCategory;
  final TextEditingController _titleController = TextEditingController();
  File? _selectedIcon;
  String? errorMsg;
  bool? isError;

  void _pickImage() async {
    final pickedImage = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
      maxHeight: 512,
      maxWidth: 512,
    );
    if (pickedImage == null) {
      return;
    } else {}
    setState(() {
      _selectedIcon = File(pickedImage.path);
    });
  }

  void _addCategory() async {
    FocusScope.of(context).unfocus();
    if (user == null) {
      setState(() {
        errorMsg = 'User is not logged in.';
        isError = true;
      });
      return;
    }
    final isValid = _formKey.currentState!.validate();
    if (!isValid || _selectedIcon == null) {
      setState(() {
        errorMsg = 'Please fill all the fields.';
        isError = true;
      });
      return;
    }
    _formKey.currentState!.save();
    try {
      setState(() {
        isLoading = true;
      });
      String? iconUrl;
      if (_selectedIcon != null) {
        final storageRef = FirebaseStorage.instance
            .ref()
            .child('category_icons')
            .child('${_titleController.text}.png');
        await storageRef.putFile(_selectedIcon!);
        iconUrl = await storageRef.getDownloadURL();
      }

      await FirebaseFirestore.instance
          .collection('category')
          .doc(_titleController.text)
          .set({
        'category': _selectedCategory,
        'title': _titleController.text,
        'iconUrl': iconUrl,
      });
      setState(() {
        errorMsg = 'Category added Successfully';
        isError = false;
      });
    } on FirebaseAuthException catch (error) {
      log(error.message ?? 'Adding Failed');
    } catch (e) {
      log(e.toString());
    } finally {
      setState(() {
        isLoading = false;
        _titleController.clear();
        _selectedCategory = "";
        _selectedIcon = null;
      });
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 48, 16, 16),
      child: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, size: 30),
                      onPressed: () => Navigator.pop(context),
                    ),
                    Text(
                      "Add Category",
                      style: Theme.of(context).textTheme.titleMedium!,
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        CustomDropdownInput(
                          labelText: "Select Category",
                          options: categoryNames,
                          selectedValue: _selectedCategory,
                          defaultIcon: const Icon(Icons.dashboard_customize),
                          onSaved: (value) => _selectedCategory = value!,
                        ),
                        SizedBox(height: 20),
                        CustomInput(
                          defaultIcon: const Icon(Icons.title),
                          labelText: "Title",
                          kType: TextInputType.text,
                          validationType: ValidationType.none,
                          maxLength: 25,
                          controller: _titleController,
                        ),
                        SizedBox(height: 20),
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              height: 200,
                              width: 200,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? bgrey
                                    : grey,
                                image: _selectedIcon != null
                                    ? DecorationImage(
                                        image: FileImage(_selectedIcon!),
                                        fit: BoxFit.cover,
                                      )
                                    : null,
                              ),
                              child: _selectedIcon == null
                                  ? Icon(
                                      Icons.image,
                                      color: black.withValues(alpha: 0.6),
                                      size: 50,
                                    )
                                  : null,
                            ),

                            // Background Edit Icon
                            Positioned(
                              top: 10,
                              right: 10,
                              child: GestureDetector(
                                onTap: _pickImage,
                                child: CircleAvatar(
                                  radius: 16,
                                  backgroundColor: red,
                                  child:
                                      Icon(Icons.edit, color: white, size: 18),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        if (errorMsg != null)
                          CustomError(msg: errorMsg!, isError: isError!),
                        SizedBox(height: 20),
                        CustomButton(
                          fgClr: black,
                          bgClr: yellow,
                          text: "Add",
                          onTap: _addCategory,
                          iClr: black,
                          icon: Icons.add,
                          iSize: 30,
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
