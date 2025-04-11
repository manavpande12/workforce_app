import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:workforce_app/constants/string.dart';
import 'package:workforce_app/providers/theme_provider.dart';
import 'package:workforce_app/providers/user_info_provider.dart';
import 'package:workforce_app/services/check_user.dart';
import 'package:workforce_app/theme/color.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workforce_app/widgets/custom_tile.dart';
import 'package:workforce_app/widgets/mode_tile.dart';
import 'package:workforce_app/widgets/profile_avatar.dart';

class CustomDrawer extends ConsumerStatefulWidget {
  const CustomDrawer({
    super.key,
  });

  @override
  ConsumerState<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends ConsumerState<CustomDrawer> {
  final user = FirebaseAuth.instance.currentUser;
  final CheckUser _checkUser = CheckUser();

  @override
  void initState() {
    super.initState();
    _checkUserTerms();
  }

  // Check if user has accepted the terms
  Future<void> _checkUserTerms() async {
    final accepted = await _checkUser.checkTermsAccepted(user!.uid);
    if (!mounted) {
      return;
    } else {
      setState(() {
        _isJoin = accepted;
      });
    }
  }

  var _isJoin = false;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = ref.watch(themeProvider);
    final user = ref.watch(userProvider);

    return Drawer(
      elevation: 10,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.zero,
      ),
      child: Column(
        children: [
          SizedBox(
            height: 250,
            width: double.infinity,
            child: DrawerHeader(
              decoration: BoxDecoration(
                color: yellow,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushNamed(tabs, arguments: 3);
                    },
                    child: ProfileAvatar(
                      radius: 50,
                      iconSize: 40,
                      oClr: grey,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    user?.name.toUpperCase() ?? "Loading...",
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(),
                  ),
                ],
              ),
            ),
          ),
          _isJoin
              ? CustomTile(
                  title: "Edit Profile",
                  icon: FontAwesomeIcons.userPen,
                  clr: Theme.of(context).brightness == Brightness.dark
                      ? white
                      : black,
                  iclr: Theme.of(context).brightness == Brightness.dark
                      ? white
                      : black,
                  onTap: () {
                    Navigator.of(context).pushNamed(
                      join,
                      arguments: {
                        "joined": _isJoin,
                        "title": "Enhance Your Profile",
                      },
                    );
                  })
              : CustomTile(
                  title: "Join WorkForce",
                  icon: Icons.workspace_premium,
                  clr: Theme.of(context).brightness == Brightness.dark
                      ? white
                      : black,
                  iclr: Theme.of(context).brightness == Brightness.dark
                      ? white
                      : black,
                  onTap: () {
                    Navigator.of(context).pushNamed(
                      join,
                      arguments: {
                        "joined": _isJoin,
                        "title": "Join WorkForce",
                      },
                    );
                  }),
          CustomTile(
              title: "WorkForce Tab",
              clr: Theme.of(context).brightness == Brightness.dark
                  ? white
                  : black,
              iclr: Theme.of(context).brightness == Brightness.dark
                  ? white
                  : black,
              icon: Icons.favorite,
              onTap: () {
                Navigator.pushNamed(context, workforce);
              }),
          ModeTile(
            isDarkMode: isDarkMode,
            onChanged: (value) {
              ref.read(themeProvider.notifier).toggleTheme();
            },
          ),
          const Spacer(),
          CustomTile(
              title: "Log Out",
              clr: red,
              iclr: red,
              icon: FontAwesomeIcons.doorOpen,
              onTap: () {
                ref.read(userProvider.notifier).logout();
                Navigator.pushReplacementNamed(context, wrapper);
              }),
          SizedBox(height: 10),
        ],
      ),
    );
  }
}
