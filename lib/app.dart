import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/home_screen.dart';

class AnniversaryApp extends StatelessWidget {
  const AnniversaryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nathan & Frenzy — One Year',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: const ColorScheme.dark(
          surface: AppColors.charcoal,
          primary: AppColors.rose,
          secondary: AppColors.gold,
        ),
        textTheme: GoogleFonts.cormorantGaramondTextTheme(
          ThemeData.dark().textTheme,
        ),
        scaffoldBackgroundColor: AppColors.charcoal,
      ),
      home: const HomeScreen(),
    );
  }
}

class AppColors {
  static const Color cream       = Color(0xFFFAF7F2);
  static const Color parchment   = Color(0xFFF2EBE0);
  static const Color rose        = Color(0xFFC8866E);
  static const Color roseLight   = Color(0xFFE8C4B4);
  static const Color roseDeep    = Color(0xFF8B4A35);
  static const Color gold        = Color(0xFFBFA06A);
  static const Color goldLight   = Color(0xFFE8D9B8);
  static const Color charcoal    = Color(0xFF2C2420);
  static const Color charcoalMid = Color(0xFF3A2A24);
  static const Color muted       = Color(0xFF7A6A60);
}
