import 'package:flutter/material.dart';
import 'package:workforce_app/screens/profile.dart';
import 'package:workforce_app/screens/Chat/chat.dart';
import 'package:workforce_app/screens/category.dart';
import 'package:workforce_app/screens/home.dart';
import 'package:workforce_app/widgets/custom_bottom_bar.dart';

class Tabs extends StatefulWidget {
  const Tabs({super.key, required this.initialPageIndex});
  final int initialPageIndex;

  @override
  State<Tabs> createState() => _TabsState();
}

class _TabsState extends State<Tabs> {
  int _selectedPageIndex = 0;
  @override
  void initState() {
    super.initState();
    _selectedPageIndex = widget.initialPageIndex;
  }

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget activePage = const HomeScreen();
    if (_selectedPageIndex == 1) {
      activePage = const ChatScreen();
    }
    if (_selectedPageIndex == 2) {
      activePage = const CategoryScreen();
    }
    if (_selectedPageIndex == 3) {
      activePage = const ProfileScreen();
    }
    return Scaffold(
      body: activePage,
      bottomNavigationBar: CustomBottomBar(
        onTap: _selectPage,
        selectedPageIndex: _selectedPageIndex,
      ),
    );
  }
}
