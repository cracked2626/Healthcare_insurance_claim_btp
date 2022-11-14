import 'package:btp_project/screens/homeScreen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: const MaterialColor(
          4294967295,
          <int, Color>{
            50: Color(0xfffff8e1),
            100: Color(0xffffecb3),
            200: Color(0xffffe082),
            300: Color(0xffffd54f),
            400: Color(0xffffca28),
            500: Color(0xffffc107),
            600: Color(0xffffb300),
            700: Color(0xffffa000),
            800: Color(0xffff8f00),
            900: Color(0xffff6f00),
          },
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(),
    );
  }
}
