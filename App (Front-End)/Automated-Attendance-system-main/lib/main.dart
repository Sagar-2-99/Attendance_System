import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:automated_attdance_system/screens/signin_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final cs = ColorScheme.fromSeed(
    brightness: Brightness.dark,
    seedColor: const Color.fromARGB(255, 167,55,40),
);
final theme = ThemeData(
  colorScheme: cs,
  scaffoldBackgroundColor: cs.background,
  textTheme: GoogleFonts.juaTextTheme()
);

void main() {
  runApp(
    const ProviderScope(child: MyApp())
  );
}

class MyApp extends StatelessWidget {

  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: theme,
      home: const SigninScreen(),
    );
  }

}