import 'package:flutter/material.dart';
import 'package:frontend/views/lobby.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

 
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CrewAI_TFG',
      theme: ThemeData(
      ),
      home: HomePage(),
    );
  }
}

