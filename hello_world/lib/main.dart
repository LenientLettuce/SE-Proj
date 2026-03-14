import 'package:flutter/material.dart';

void main() {
  runApp(const MyHelloWorldApp());
}

class MyHelloWorldApp extends StatelessWidget {
  const MyHelloWorldApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text(
            'Hello, World!',
            style: TextStyle(fontSize: 24),
          ),
        ),
      ),
    );
  }
}