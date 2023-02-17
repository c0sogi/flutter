import 'package:flutter/material.dart';
import 'pomodoro_widget.dart' as pmdr;
// import 'package:flutter/src/widgets/framework.dart';
// import 'package:flutter/src/widgets/placeholder.dart';

void main(List<String> args) {
  runApp(const PomodoroApp());
}

class PomodoroApp extends StatelessWidget {
  const PomodoroApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: const ColorScheme(
          brightness: Brightness.light,
          primary: Color(0xFF6750a4),
          onPrimary: Color(0xFF22005d),
          secondary: Color(0xFF7d5260),
          onSecondary: Color(0xFF31101d),
          error: Color(0xFFba1b1b),
          onError: Color(0xFF410001),
          background: Color(0xFFE7626C),
          onBackground: Color(0xFF31101d),
          surface: Color(0xFF4DB6AC),
          onSurface: Color(0xFF00796B),
        ),
        iconTheme: const IconThemeData(
          color: Color(0xFFF4EDDB),
          size: 120,
        ),
        textTheme: const TextTheme(
          displayLarge: TextStyle(
            color: Color(0xfff4eddb),
            fontSize: 89,
            fontWeight: FontWeight.w600,
          ),
          displayMedium: TextStyle(
            color: Color(0xff232b55),
            fontSize: 58,
            fontWeight: FontWeight.w600,
          ),
          displaySmall: TextStyle(
            color: Color(0xff232b55),
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        cardTheme: const CardTheme(
          color: Color(0xfff4eddb),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(50))),
        ),
      ),
      home: const pmdr.Home(),
    );
  }
}
