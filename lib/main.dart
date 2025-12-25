import 'package:flutter/material.dart';
import 'package:flutter_flower_shop/pages/home_page.dart';
import 'package:flutter_flower_shop/pages/intro_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/intro',
      routes: {
        '/intro': (context) => const IntroPage(),
        '/home': (context) => const HomePage(),
      },
    );
  }
}
