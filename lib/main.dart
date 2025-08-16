import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_portfolio/screens/home_screen.dart';

void main() {
  runApp(const MyPortfolioApp());
}

class MyPortfolioApp extends StatelessWidget {
  const MyPortfolioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'معرض أعمالي',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        fontFamily: 'Cairo',
        textTheme: GoogleFonts.cairoTextTheme(),
      ),
      home: const HomeScreen(),
    );
  }
}
