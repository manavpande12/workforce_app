import 'package:flutter/material.dart';
import 'package:workforce_app/theme/color.dart';

class SearchBarWidget extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSearch;
  final String hintText;

  const SearchBarWidget({
    super.key,
    required this.controller,
    required this.onSearch,
    this.hintText = "Search...",
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark ? bgrey : grey,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(horizontal: 15),
                border: InputBorder.none,
                hintText: hintText,
                hintStyle: Theme.of(context)
                    .textTheme
                    .titleSmall
                    ?.copyWith(fontSize: 14),
              ),
              style: Theme.of(context)
                  .textTheme
                  .titleSmall
                  ?.copyWith(fontSize: 14),
              maxLength: 18,
              buildCounter: (context,
                      {required int currentLength,
                      required bool isFocused,
                      required int? maxLength}) =>
                  null,
            ),
          ),
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: yellow,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(10),
                bottomRight: Radius.circular(10),
              ),
            ),
            child: IconButton(
              icon: Icon(Icons.search, size: 30, color: black),
              onPressed: onSearch,
            ),
          ),
        ],
      ),
    );
  }
}
