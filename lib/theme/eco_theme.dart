import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EcoTheme {
  static ThemeData lightTheme = ThemeData(
    primaryColor: const Color(0xFF50AA5C),
    scaffoldBackgroundColor: const Color(0xFFF1FCE9),
    textTheme: GoogleFonts.poppinsTextTheme().copyWith(
      titleLarge: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF1E3A34)),
      bodyLarge: const TextStyle(fontSize: 16, color: Color(0xFF273233)),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: const BorderSide(color: Color(0xFF50AA5C)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: const BorderSide(color: Color(0xFF50AA5C), width: 2),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF50AA5C),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 14),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    ),
  );
}
