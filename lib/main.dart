import 'package:flutter/material.dart';
import 'pages/home_page.dart';

void main() {
  runApp(SleepWakeApp());
}

class SleepWakeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sleep Wake App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}
