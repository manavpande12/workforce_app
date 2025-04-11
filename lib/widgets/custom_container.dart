import 'package:flutter/material.dart';
import 'package:workforce_app/theme/color.dart';

class CustomContainer extends StatelessWidget {
  final double? height;
  final double? width;
  final String title;
  final List items;
  final Color backgroundColor;
  final bool isScrollable;
  final bool isTitle;
  final String des;
  final IconData? icon;
  final Color? iclr;

  const CustomContainer({
    super.key,
    this.height,
    this.width,
    this.title = "",
    required this.backgroundColor,
    this.isScrollable = false,
    this.isTitle = false,
    this.des = "",
    this.icon,
    this.iclr,
    this.items = const [],
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      height: height,
      width: width ?? double.infinity,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Title
          ...(isTitle
              ? [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        icon,
                        color: iclr,
                      ),
                      SizedBox(width: 10),
                      Text(
                        title,
                        style: Theme.of(context).textTheme.titleMedium!,
                      ),
                    ],
                  ),
                  Divider(color: cream, thickness: 2),
                  const SizedBox(height: 8)
                ]
              : [
                  SizedBox.shrink(),
                ]),
          isScrollable
              ? Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: items
                          .map(
                            (item) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: Text(
                                "▪$item",
                                style: Theme.of(context).textTheme.titleSmall,
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                )
              : Expanded(
                  child: SingleChildScrollView(
                    child: Text(
                      des,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
