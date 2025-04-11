import 'dart:io';
import 'package:flutter/material.dart';
import 'package:workforce_app/services/request_permission.dart';
import 'package:workforce_app/widgets/custom_bar.dart';
import 'package:workforce_app/widgets/custom_conf_msg.dart';
import 'package:workforce_app/widgets/custom_drawer.dart';
import 'package:workforce_app/widgets/banner_slider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    requestLocationPermission();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, Object? result) async {
        bool exitApp = await _showExitConfirmation(context);
        if (exitApp) {
          exit(0);
        } else {
          return;
        }
      },
      child: Scaffold(
        appBar: const CustomBar(),
        drawer: const CustomDrawer(),
        body: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: const BannerSlider(),
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> _showExitConfirmation(BuildContext context) async {
    return await showConfirmationDialog(
      context: context,
      title: "Exit App",
      content: "Are you sure you want to exit?",
      txt: "Yes",
      icon: Icons.exit_to_app,
    );
  }
}
