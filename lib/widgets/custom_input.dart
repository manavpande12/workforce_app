import 'package:flutter/material.dart';
import 'package:workforce_app/theme/color.dart';

enum ValidationType {
  name,
  email,
  password,
  contact,
  experience,
  age,
  none,
}

class CustomInput extends StatelessWidget {
  final String labelText;
  final ValidationType validationType;
  final void Function(String?)? onSaved;
  final bool obscureText;
  final bool enableSuggestions;
  final TextInputType kType;
  final int maxLines;
  final int maxLength;
  final bool readOnly;
  final Icon? defaultIcon;
  final TextEditingController controller; // ✅ New Controller

  const CustomInput({
    super.key,
    required this.labelText,
    this.validationType = ValidationType.none,
    this.onSaved,
    this.obscureText = false,
    required this.kType,
    this.maxLines = 1,
    required this.maxLength,
    this.readOnly = false,
    this.defaultIcon,
    this.enableSuggestions = false,
    required this.controller, // ✅ Required Controller
  });

  String? _validateInput(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'This field cannot be empty!';
    }

    switch (validationType) {
      case ValidationType.name:
        if (value.trim().length < 5) {
          return 'Please enter a valid full name!';
        }
        break;
      case ValidationType.email:
        if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
          return 'Please enter a valid email!';
        }
        break;
      case ValidationType.password:
        if (value.length < 6) {
          return 'Password must be at least 6 characters long!';
        }
        break;
      case ValidationType.contact:
        if (!RegExp(r'^[6-9]\d{9}$').hasMatch(value)) {
          return 'Please enter a valid 10-digit Indian phone number!';
        }
        break;
      case ValidationType.experience:
      case ValidationType.age:
        if (!RegExp(r'^[0-9]{1,2}$').hasMatch(value)) {
          return 'Please enter a valid number (0-99)!';
        }
        break;
      case ValidationType.none:
        return null;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        filled: true,
        fillColor:
            Theme.of(context).brightness == Brightness.dark ? bgrey : grey,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        hintText: labelText,
        hintStyle: Theme.of(context).textTheme.titleSmall,
        prefixIcon: defaultIcon,
        prefixIconColor:
            Theme.of(context).brightness == Brightness.dark ? white : black,
        errorStyle:
            Theme.of(context).textTheme.titleSmall!.copyWith(color: red),
      ),
      readOnly: readOnly,
      enableSuggestions: enableSuggestions,
      obscureText: obscureText,
      validator: _validateInput,
      onSaved: onSaved,
      maxLength: maxLength,
      buildCounter: (context,
              {required currentLength, required isFocused, maxLength}) =>
          null,
      style: Theme.of(context).textTheme.titleSmall,
      keyboardType: kType,
      maxLines: maxLines,
    );
  }
}
