import 'package:flutter/material.dart';
import 'package:workforce_app/theme/color.dart';

class CustomTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color iclr, clr;
  final void Function()? onTap;

  const CustomTile({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
    required this.clr,
    required this.iclr,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color:
                Theme.of(context).brightness == Brightness.dark ? bgrey : grey,
            width: 1,
          ),
        ),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          size: 24,
          color: iclr,
        ),
        title: Text(
          title,
          style: Theme.of(context)
              .textTheme
              .titleMedium!
              .copyWith(fontSize: 18, color: clr),
        ),
        onTap: onTap,
      ),
    );
  }
}
