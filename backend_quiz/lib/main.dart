import 'package:flutter/material.dart';
import 'package:backend_quiz/screen/screen_home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My quiz App',
      home: HomeScreen(),
    );
  }
}
