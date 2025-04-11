import 'package:flutter/material.dart';
import 'package:workforce_app/screens/Admin/admin_bar.dart';
import 'package:workforce_app/screens/Admin/manage_category.dart';
import 'package:workforce_app/screens/Admin/manage_user.dart';
import 'package:workforce_app/widgets/custom_drawer.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  int _selectedPageIndex = 0;

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

    Widget activePage = const ManageUserScreen();
    if (_selectedPageIndex == 1) {
      activePage = const ManageCategoryScreen();
    }

    return Scaffold(
      key: scaffoldKey, // Assigning key to Scaffold
      drawer: const CustomDrawer(),
      appBar: AppBar(
        title: const Text(
          "Admin Screen",
        ),
        leading: IconButton(
          onPressed: () {
            scaffoldKey.currentState?.openDrawer();
          },
          icon: Icon(
            Icons.account_circle_rounded,
            size: 40,
          ),
        ),
        centerTitle: true,
      ),
      body: activePage,

      bottomNavigationBar:
          AdminBar(onTap: _selectPage, selectedPageIndex: _selectedPageIndex),
    );
  }
}
