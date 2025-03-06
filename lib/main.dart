import 'package:flutter/material.dart';
import 'form_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter API Form',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FormScreen(),
    );
  }
}