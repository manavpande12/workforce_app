import 'package:flutter/material.dart';
import 'package:workforce_app/theme/color.dart';
import 'package:workforce_app/widgets/custom_button.dart';

Future<bool> showConfirmationDialog({
  required BuildContext context,
  required String title,
  required String content,
  String txt = "Delete",
  IconData icon = Icons.delete,
}) async {
  return await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor:
                Theme.of(context).brightness == Brightness.dark ? black : white,
            title: Text(
              title,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            content: Text(
              content,
              style: Theme.of(context).textTheme.titleSmall,
            ),
            actions: [
              SizedBox(
                width:
                    MediaQuery.of(context).size.width * 0.8, // Prevent overflow
                child: Row(
                  children: [
                    Expanded(
                      child: CustomButton(
                        icon: Icons.cancel_outlined,
                        iClr: Theme.of(context).brightness == Brightness.dark
                            ? white
                            : black,
                        iSize: 22, // Reduce icon size
                        bgClr: Theme.of(context).brightness == Brightness.dark
                            ? bgrey
                            : grey,
                        fgClr: Theme.of(context).brightness == Brightness.dark
                            ? white
                            : black,
                        text: "Cancel",
                        fontSize: 10,
                        onTap: () => Navigator.of(context).pop(false),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: CustomButton(
                        icon: icon,
                        iClr: white,
                        iSize: 22,
                        bgClr: red,
                        fgClr: white,
                        text: txt,
                        fontSize: 10,
                        onTap: () => Navigator.of(context).pop(true),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ) ??
      false;
}
