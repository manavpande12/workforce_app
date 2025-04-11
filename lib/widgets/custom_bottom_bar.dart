import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:workforce_app/theme/color.dart';
import 'package:workforce_app/widgets/profile_avatar.dart';

class CustomBottomBar extends StatelessWidget {
  final int selectedPageIndex;
  final void Function(int)? onTap;

  const CustomBottomBar({
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
          elevation: 5,
          type: BottomNavigationBarType.fixed,
          onTap: onTap,
          currentIndex: selectedPageIndex,
          items: [
            BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.houseFire),
              label: "HOME",
            ),
            BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.solidComment),
              label: "CHAT",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard_customize_rounded),
              label: "CATEGORY",
            ),
            BottomNavigationBarItem(
              icon: SizedBox(
                child: ProfileAvatar(radius: 15, iconSize: 15, oClr: yellow),
              ),
              label: "ME",
            ),
          ],
        ),
      ),
    );
  }
}
