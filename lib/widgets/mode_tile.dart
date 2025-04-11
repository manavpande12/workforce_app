import 'package:flutter/material.dart';
import 'package:workforce_app/theme/color.dart';

class ModeTile extends StatelessWidget {
  final bool isDarkMode;
  final Function(bool) onChanged;

  const ModeTile({
    super.key,
    required this.isDarkMode,
    required this.onChanged,
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
          isDarkMode ? Icons.nights_stay : Icons.wb_sunny,
          size: 24,
          color:
              Theme.of(context).brightness == Brightness.dark ? white : black,
        ),
        title: Text(
          isDarkMode ? 'Dark Mode' : 'Light Mode',
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
                fontSize: 18,
              ),
        ),
        trailing: Switch(
          value: isDarkMode,
          onChanged: onChanged,
          activeColor: white,
          activeTrackColor: Colors.green,
          inactiveThumbColor: white,
          inactiveTrackColor: grey,
          trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
        ),
      ),
    );
  }
}
