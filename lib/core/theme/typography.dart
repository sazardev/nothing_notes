import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NothingTypography {
  NothingTypography._();

  static TextStyle displayXl(Color color) => GoogleFonts.spaceMono(
        fontSize: 72,
        fontWeight: FontWeight.w700,
        color: color,
        height: 1.0,
        letterSpacing: -0.03,
      );

  static TextStyle displayLg(Color color) => GoogleFonts.spaceMono(
        fontSize: 48,
        fontWeight: FontWeight.w700,
        color: color,
        height: 1.05,
        letterSpacing: -0.02,
      );

  static TextStyle displayMd(Color color) => GoogleFonts.spaceMono(
        fontSize: 36,
        fontWeight: FontWeight.w700,
        color: color,
        height: 1.1,
        letterSpacing: -0.02,
      );

  static TextStyle heading(Color color) => GoogleFonts.spaceGrotesk(
        fontSize: 24,
        fontWeight: FontWeight.w500,
        color: color,
        height: 1.2,
        letterSpacing: -0.01,
      );

  static TextStyle subheading(Color color) => GoogleFonts.spaceGrotesk(
        fontSize: 18,
        fontWeight: FontWeight.w400,
        color: color,
        height: 1.3,
      );

  static TextStyle body(Color color) => GoogleFonts.spaceGrotesk(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: color,
        height: 1.5,
      );

  static TextStyle bodySmall(Color color) => GoogleFonts.spaceGrotesk(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: color,
        height: 1.5,
        letterSpacing: 0.01,
      );

  static TextStyle caption(Color color) => GoogleFonts.spaceMono(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: color,
        height: 1.4,
        letterSpacing: 0.04,
      );

  static TextStyle label(Color color) => GoogleFonts.spaceMono(
        fontSize: 11,
        fontWeight: FontWeight.w400,
        color: color,
        height: 1.2,
        letterSpacing: 0.08,
      );

  static TextStyle button(Color color) => GoogleFonts.spaceMono(
        fontSize: 13,
        fontWeight: FontWeight.w400,
        color: color,
        letterSpacing: 0.06,
      );
}