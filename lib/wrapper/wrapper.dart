import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:workforce_app/screens/Admin/admin.dart';
import 'package:workforce_app/screens/auth.dart';
import 'package:workforce_app/screens/splash.dart';
import 'package:workforce_app/screens/tabs.dart';
import 'package:workforce_app/widgets/custom_scaffold.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (ctx, authSnapshot) {
        if (authSnapshot.connectionState == ConnectionState.waiting) {
          return const SplashScreen();
        }
        if (authSnapshot.hasError) {
          Future.microtask(() {
            if (context.mounted) {
              context.showSnackBar(
                "Authentication error: ${authSnapshot.error}",
                isError: true,
              );
            }
          });
          return const AuthScreen();
        }

        if (authSnapshot.hasData) {
          // Check if logged-in user is the admin
          if (authSnapshot.data!.email == "admin@gmail.com") {
            Future.microtask(() {
              if (context.mounted) {
                context.showSnackBar(
                  "Welcome back! Admin logged in successfully",
                  isError: false,
                );
              }
            });
            return const AdminScreen();
          }
          Future.microtask(() {
            if (context.mounted) {
              context.showSnackBar(
                "Welcome back! User logged in successfully",
                isError: false,
              );
            }
          });

          return const Tabs(initialPageIndex: 0);
        }

        return const AuthScreen();
      },
    );
  }
}
