import 'package:flutter/material.dart';

import 'screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Wallpapers App',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xff0e0e0f),
      ),
      home: const HomeScreen(),
      
    );
  }
}
