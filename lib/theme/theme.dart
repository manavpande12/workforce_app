import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:workforce_app/theme/color.dart';

final lightTheme = ThemeData().copyWith(
  brightness: Brightness.light,
  textTheme: GoogleFonts.ubuntuCondensedTextTheme().copyWith(
    titleSmall: GoogleFonts.poppins(
      fontWeight: FontWeight.w600,
      fontSize: 12,
      color: black.withValues(alpha: 0.6),
    ),
    titleMedium: GoogleFonts.ubuntuCondensed(
      fontWeight: FontWeight.w800,
      fontSize: 20,
      color: black,
    ),
    titleLarge: GoogleFonts.merienda(
      fontSize: 24,
      fontWeight: FontWeight.w700,
      fontStyle: FontStyle.italic,
      color: black,
    ),
    bodyLarge: GoogleFonts.lato(
      fontSize: 28,
      fontWeight: FontWeight.w600,
      color: black,
    ),
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: white,
    iconTheme: IconThemeData(
      color: black,
    ),
    shadowColor: black.withValues(alpha: 0.5),
    elevation: 9,
    titleTextStyle: GoogleFonts.lato(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      color: black,
    ),
  ),
  primaryColor: red,
  dialogBackgroundColor: white,
  scaffoldBackgroundColor: white,
  buttonTheme: ButtonThemeData(buttonColor: red),
  iconTheme: IconThemeData(color: black),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: white,
    unselectedItemColor: bgrey,
  ),
  drawerTheme: DrawerThemeData(backgroundColor: white),
  bottomSheetTheme: BottomSheetThemeData(
    backgroundColor: white,
  ),
  progressIndicatorTheme: ProgressIndicatorThemeData(
    color: red,
    circularTrackColor: grey,
    linearTrackColor: grey.withValues(alpha: 0.8),
    refreshBackgroundColor: white,
  ),
);

final darkTheme = ThemeData().copyWith(
  brightness: Brightness.dark,
  textTheme: GoogleFonts.ubuntuCondensedTextTheme().copyWith(
    titleSmall: GoogleFonts.poppins(
      fontWeight: FontWeight.w600,
      fontSize: 12,
      color: white.withValues(alpha: 0.6),
    ),
    titleMedium: GoogleFonts.ubuntuCondensed(
      fontWeight: FontWeight.w800,
      fontSize: 20,
      color: white,
    ),
    titleLarge: GoogleFonts.merienda(
      fontSize: 24,
      fontWeight: FontWeight.w700,
      fontStyle: FontStyle.italic,
      color: white,
    ),
    bodyLarge: GoogleFonts.lato(
      fontSize: 28,
      fontWeight: FontWeight.w600,
      color: white,
    ),
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: black,
    iconTheme: IconThemeData(
      color: white,
    ),
    shadowColor: Colors.transparent,
    elevation: 9,
    titleTextStyle: GoogleFonts.lato(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      color: white,
    ),
  ),
  primaryColor: black,
  dialogBackgroundColor: black,
  scaffoldBackgroundColor: black,
  buttonTheme: ButtonThemeData(buttonColor: red),
  iconTheme: IconThemeData(color: white),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: bgrey,
    unselectedItemColor: black,
  ),
  drawerTheme: DrawerThemeData(backgroundColor: black),
  bottomSheetTheme: BottomSheetThemeData(
    backgroundColor: black,
  ),
  progressIndicatorTheme: ProgressIndicatorThemeData(
    color: red,
    circularTrackColor: bgrey,
    linearTrackColor: bgrey.withValues(alpha: 0.8),
    refreshBackgroundColor: black,
  ),
);
