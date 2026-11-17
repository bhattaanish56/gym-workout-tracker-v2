import 'package:flutter/material.dart';

abstract final class AppTheme {
  static final ThemeData light = ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFFFF6B00),
      brightness: Brightness.light,
    ),
    useMaterial3: true,
  );

  static final ThemeData dark = ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFFFF6B00),
      brightness: Brightness.dark,
      surface: const Color(0xFF1C1E23),
      surfaceContainerLowest: const Color(0xFF101114),
    ),
    scaffoldBackgroundColor: const Color(0xFF101114),
    useMaterial3: true,
  );
}
