import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Authentic MarathonBet (БК Марафон) Design System & Theme
class AppTheme {
  // MarathonBet Signature Brand Colors
  static const Color primary = Color(0xFFE21A22); // MarathonBet Iconic Red
  static const Color primaryDark = Color(0xFFB81017); // Deep Marathon Crimson
  static const Color secondary = Color(0xFF00A3E0); // MarathonBet Sky Blue / Cyan (odds & live highlights)
  static const Color secondaryDark = Color(0xFF0077B6);

  // Dedicated Marathon Named Tokens
  static const Color marathonRed = Color(0xFFE21A22);
  static const Color marathonBlue = Color(0xFF00A3E0);
  static const Color marathonNavy = Color(0xFF0D2348);
  static const Color marathonDarkNavy = Color(0xFF071224);

  // Sports & League Accents
  static const Color accentPurple = Color(0xFF2563EB); // Royal League Blue
  static const Color accentGold = Color(0xFFFFB800); // Championship Trophy / Coin Gold
  static const Color accentRose = Color(0xFFE21A22); // Marathon Red Accent / Alert
  static const Color accentOrange = Color(0xFFFF6D00); // Live Action Orange
  static const Color accentGreen = Color(0xFF00C853); // Stadium Pitch Green / Success

  // Background Surfaces (Authentic MarathonBet Dark Sports Atmosphere)
  static const Color background = Color(0xFF071224); // Deep Marathon Sportsbook Navy
  static const Color surface = Color(0xFF0C1D38); // Deep Navy Surface (Header & Bottom Nav)
  static const Color surfaceCard = Color(0xFF122544); // Athletic Navy Card Background
  static const Color surfaceCardElevated = Color(0xFF172E54); // Elevated Stadium Card
  static const Color surfaceBorder = Color(0xFF1D3A68); // Crisp Stadium Card Border

  // Text Colors
  static const Color textPrimary = Color(0xFFFFFFFF); // Crisp Pure White
  static const Color textSecondary = Color(0xFF94A9C9); // Marathon Slate Blue-Gray
  static const Color textMuted = Color(0xFF567194); // Muted Navy Gray
  static const Color onPrimary = Color(0xFFFFFFFF); // Text on Marathon Red

  // Box Shadows & Glows
  static List<BoxShadow> get neonGlow => [
        BoxShadow(
          color: marathonRed.withAlpha(70),
          blurRadius: 18,
          spreadRadius: 2,
        ),
      ];

  static List<BoxShadow> get redGlow => [
        BoxShadow(
          color: marathonRed.withAlpha(80),
          blurRadius: 16,
          spreadRadius: 1,
        ),
      ];

  static List<BoxShadow> get blueGlow => [
        BoxShadow(
          color: marathonBlue.withAlpha(70),
          blurRadius: 16,
          spreadRadius: 1,
        ),
      ];

  // Marathon Gradients
  static const LinearGradient marathonRedGradient = LinearGradient(
    colors: [Color(0xFFE52320), Color(0xFFB81017)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient marathonNavyGradient = LinearGradient(
    colors: [Color(0xFF0F2B5B), Color(0xFF07152B)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient marathonCardGradient = LinearGradient(
    colors: [Color(0xFF14284C), Color(0xFF0D1E3A)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient marathonBlueGradient = LinearGradient(
    colors: [Color(0xFF00A3E0), Color(0xFF0077B6)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: background,
      primaryColor: primary,
      colorScheme: const ColorScheme.dark(
        primary: primary,
        onPrimary: onPrimary,
        secondary: secondary,
        surface: surface,
        error: accentRose,
      ),
      textTheme: GoogleFonts.interTextTheme(
        ThemeData.dark().textTheme,
      ).apply(
        bodyColor: textPrimary,
        displayColor: textPrimary,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: surface,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.outfit(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: textPrimary,
          letterSpacing: 0.5,
        ),
        iconTheme: const IconThemeData(color: textPrimary),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: onPrimary,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: GoogleFonts.outfit(
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
