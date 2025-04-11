import 'package:flutter/material.dart';
import 'package:workforce_app/theme/color.dart';

class AdminBar extends StatelessWidget {
  final int selectedPageIndex;
  final void Function(int)? onTap;

  const AdminBar({
    super.key,
    required this.onTap,
    this.selectedPageIndex = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        color: white,
        boxShadow: [
          BoxShadow(
            color: black.withValues(alpha: 0.3),
            blurRadius: 6.0,
            spreadRadius: 1.0,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(25), // Ensure rounded corners
        child: BottomNavigationBar(
          showUnselectedLabels: false,
          showSelectedLabels: false,
          selectedItemColor: yellow,
          enableFeedback: true,
          iconSize: 30,
          type: BottomNavigationBarType.fixed,
          onTap: onTap,
          elevation: 5,
          currentIndex: selectedPageIndex,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.add_task_sharp),
              label: "USER",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard_customize_rounded),
              label: "CATEGORY",
            ),
          ],
        ),
      ),
    );
  }
}
