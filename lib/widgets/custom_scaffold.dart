import 'package:flutter/material.dart';
import 'package:workforce_app/theme/color.dart';

extension CustomScaffold on BuildContext {
  void showSnackBar(
    String msg, {
    bool isError = false,
    String? actionLabel,
    VoidCallback? onActionPressed,
  }) {
    ScaffoldMessenger.of(this).clearSnackBars();

    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              isError ? Icons.cancel : Icons.check_circle,
              color: isError ? red : Colors.green,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                msg,
                style: Theme.of(this).textTheme.titleSmall,
              ),
            ),
          ],
        ),
        backgroundColor:
            Theme.of(this).brightness == Brightness.dark ? bgrey : white,
        duration: const Duration(seconds: 5),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
        elevation: 6,
        action: (actionLabel != null && onActionPressed != null)
            ? SnackBarAction(
                label: actionLabel,
                textColor: Theme.of(this).brightness == Brightness.dark
                    ? white
                    : black,
                backgroundColor: Theme.of(this).brightness == Brightness.dark
                    ? bgrey
                    : white,
                onPressed: onActionPressed,
              )
            : null,
      ),
    );
  }
}
