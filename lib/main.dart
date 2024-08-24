import 'package:flutter/material.dart';
import 'package:personal_expenses/themes/themes.dart';
import 'package:personal_expenses/widgets/expenses.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Expenses App',
      themeMode: ThemeMode.light,
      theme: ThemeData().copyWith(
        colorScheme: myColorScheme,
        appBarTheme: const AppBarTheme().copyWith(
          backgroundColor: myColorScheme.primary,
        ),
      ),
      home: const Expenses(),
    );
  }
}
