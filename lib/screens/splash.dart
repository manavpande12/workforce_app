import 'package:flutter/material.dart';
import 'package:workforce_app/constants/string.dart';
import 'package:workforce_app/theme/color.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        Navigator.pushReplacementNamed(context, wrapper);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Theme.of(context).brightness == Brightness.dark ? black : white,
      body: Center(
        child: Hero(
          tag: 'splash',
          child: Image.asset(
            logo,
            width: 500,
          ),
        ),
      ),
    );
  }
}
