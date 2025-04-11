import 'package:flutter/material.dart';
import 'package:workforce_app/theme/color.dart';

class MessageInputBox extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback? onSend;
  final String hintText;

  const MessageInputBox({
    super.key,
    required this.controller,
    this.onSend,
    this.hintText = "Type a message...",
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20),
      constraints: BoxConstraints(
        maxHeight: 160, // Maximum height limit
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.multiline,
        minLines: 1,
        maxLines: 5,
        maxLength: 120,
        buildCounter: (context,
                {required currentLength, required isFocused, maxLength}) =>
            null,
        enableSuggestions: true,
        autocorrect: false,
        style: Theme.of(context).textTheme.titleSmall,
        textAlignVertical: TextAlignVertical.center,
        decoration: InputDecoration(
          filled: true,
          fillColor:
              Theme.of(context).brightness == Brightness.dark ? bgrey : grey,
          hintText: hintText,
          hintStyle: Theme.of(context).textTheme.titleSmall,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 15,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(40),
            borderSide: BorderSide.none,
          ),
          suffixIcon: Container(
            margin: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: yellow,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              onPressed: onSend,
              icon: Icon(
                Icons.arrow_forward,
                size: 26,
                color: black.withValues(alpha: 0.6),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
