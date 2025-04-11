import 'dart:async';
import 'package:flutter/material.dart';
import 'package:workforce_app/constants/string.dart';
import 'package:workforce_app/theme/color.dart';

class BannerSlider extends StatefulWidget {
  const BannerSlider({super.key});

  @override
  State<BannerSlider> createState() => _BannerSliderState();
}

class _BannerSliderState extends State<BannerSlider> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startAutoSlide();
  }

  void _startAutoSlide() {
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (!mounted) return; // Prevent calling setState if widget is removed
      setState(() {
        _currentPage = (_currentPage + 1) % bannerImages.length;
      });
      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel(); // Cancel timer when widget is removed
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 400,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: black.withValues(alpha: 0.2),
            blurRadius: 10,
            spreadRadius: 2,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      clipBehavior: Clip.hardEdge,
      child: PageView.builder(
        controller: _pageController,
        itemCount: bannerImages.length,
        itemBuilder: (context, index) {
          return Image.asset(
            bannerImages[index],
            fit: BoxFit.fill,
          );
        },
      ),
    );
  }
}
