import 'package:flutter/material.dart';
import 'package:workforce_app/theme/color.dart';

class CustomError extends StatelessWidget {
  final String msg;
  final bool isError;

  const CustomError({
    super.key,
    required this.msg,
    required this.isError,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: isError
            ? red.withValues(alpha: 0.15)
            : Colors.green.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isError ? red : Colors.green,
          width: 1.5,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isError ? Icons.error_outline : Icons.check_circle_outline,
            color: isError ? red : Colors.green,
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              msg,
              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                    color: isError ? red : Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
