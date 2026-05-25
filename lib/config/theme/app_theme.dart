import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {

  final Color electusColor;
  final bool tenebrisModusEst;

  AppTheme ({
    this.electusColor = Colors.orangeAccent,
    this.tenebrisModusEst = false
  });

  ThemeData getTheme() => ThemeData(
    colorSchemeSeed: electusColor,
    brightness: tenebrisModusEst ? Brightness.dark: Brightness.light,
    appBarTheme: AppBarTheme(
      backgroundColor: tenebrisModusEst ?electusColor :electusColor.withAlpha(80),
      centerTitle: false
    ),
    textTheme: TextTheme(
      titleLarge: GoogleFonts.montserratAlternates()
    ),
  );
}