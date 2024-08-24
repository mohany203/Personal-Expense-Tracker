import 'package:flutter/material.dart';

final myColorScheme = ColorScheme.fromSeed(
  seedColor: const Color(0xFF61efa1),
  primary: const Color(0xFF61efa1),
  secondary: const Color(0xFF2ed8b6),
);

final myTheme = ThemeData(
  useMaterial3: true,
  colorScheme: myColorScheme,
  textTheme: TextTheme(
    titleLarge: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,
      color: myColorScheme.onSurface,
    ),
    bodyLarge: TextStyle(
      fontSize: 16,
      color: myColorScheme.onSurface,
    ),
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: myColorScheme.primary,
    foregroundColor: Colors.white,
    titleTextStyle: const TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
  ),
  cardTheme: CardTheme(
    color: myColorScheme.surface,
    elevation: 4,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
  ),
);
