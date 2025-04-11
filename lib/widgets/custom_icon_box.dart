import 'package:flutter/material.dart';
import 'package:workforce_app/theme/color.dart';

class CustomIconBox extends StatelessWidget {
  final IconData icon;
  final Color bgColor;
  final String text;

  const CustomIconBox({
    super.key,
    required this.icon,
    required this.bgColor,
    required this.text,
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
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              size: 30,
              color: white,
            ),
          ),
          SizedBox(
            width: 60,
            child: Text(
              text,
              style: Theme.of(context).textTheme.titleSmall,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
