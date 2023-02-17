import 'package:flutter/material.dart';
import 'package:flutter_web/widgets/webtoon_widget.dart';

void main(List<String> args) {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFE7626C),
        // colorScheme: const ColorScheme(
        //   brightness: Brightness.light,
        //   primary: Color(0xFF6750a4),
        //   onPrimary: Color(0xFF22005d),
        //   secondary: Color(0xFF7d5260),
        //   onSecondary: Color(0xFF31101d),
        //   error: Color(0xFFba1b1b),
        //   onError: Color(0xFF410001),
        //   background: Color(0xFFE7626C),
        //   onBackground: Color(0xFF31101d),
        //   surface: Color(0xFF4DB6AC),
        //   onSurface: Color(0xFF00796B),
        // ),
        appBarTheme: const AppBarTheme(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadiusDirectional.vertical(
              bottom: Radius.circular(20),
            ),
          ),
          toolbarHeight: 60,
          centerTitle: true,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
          elevation: 10,
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
        ),
        iconTheme: const IconThemeData(
          color: Color(0xFFF4EDDB),
          size: 40,
        ),
        textTheme: TextTheme(
          displayLarge: const TextStyle(
            color: Color(0xfff4eddb),
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
          displayMedium: TextStyle(
            color: const Color(0xfff4eddb).withOpacity(0.9),
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
          displaySmall: TextStyle(
            color: const Color(0xfff4eddb).withOpacity(0.6),
            fontSize: 12,
            fontWeight: FontWeight.w400,
          ),
        ),
        cardTheme: const CardTheme(
          color: Color(0xfff4eddb),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(50))),
        ),
      ),
      home: const Home(),
    );
  }
}
