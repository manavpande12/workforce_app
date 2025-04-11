import 'package:flutter/material.dart';
import 'package:workforce_app/constants/string.dart';
import 'package:workforce_app/theme/color.dart';

class CustomBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  final Size preferredSize; // Required for PreferredSizeWidget

  const CustomBar({super.key}) : preferredSize = const Size.fromHeight(120);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
            icon: Icon(
              Icons.account_circle_rounded,
              size: 44,
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'WorkForce',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Emergency? ',
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          color: red,
                        ),
                  ),
                  Text(
                    'Get Instant Help!',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                logoNoName,
                height: 50,
              ),
            ],
          )
        ],
      ),
    );
  }
}
