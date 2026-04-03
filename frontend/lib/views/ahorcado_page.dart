import 'package:flutter/material.dart';
import 'package:frontend/widgets/ahorcado_fut_builder.dart';

class AhorcadoPage extends StatefulWidget {
  const AhorcadoPage({super.key});

  @override
  State<AhorcadoPage> createState() => _AhorcadoPageState();
}

class _AhorcadoPageState extends State<AhorcadoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Implementación Ahorcado"),
        backgroundColor: Color.fromARGB(221, 251, 44, 151),
        ),
      body: AhorcadoFutBuilder()
      
    );
  }
}