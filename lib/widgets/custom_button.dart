import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final Color fgClr;
  final Color bgClr;
  final String text;
  final IconData? icon;
  final Color? iClr;
  final VoidCallback? onTap;
  final double iSize;
  final double fontSize;

  const CustomButton({
    super.key,
    required this.fgClr,
    required this.bgClr,
    required this.text,
    required this.onTap,
    required this.iClr,
    required this.icon,
    required this.iSize,
    this.fontSize = 12,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: ElevatedButton(
          onPressed: onTap ?? () {},
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            backgroundColor: bgClr,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: iClr,
                size: iSize,
              ),
              SizedBox(width: 8),
              Text(
                text,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: fgClr,
                      fontSize: fontSize,
                    ),
              ),
            ],
          )),
    );
  }
}
