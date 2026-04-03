import 'package:flutter/material.dart';
import 'package:frontend/widgets/sopa_fut_builder.dart';

class SopaPage extends StatefulWidget {
  const SopaPage({super.key});

  @override
  State<SopaPage> createState() => _SopaPageState();
}

class _SopaPageState extends State<SopaPage> {
  @override
  Widget build(BuildContext context) {
     return Scaffold(
      appBar: AppBar(
        title: Text("Implementación Sopa de letras"),
        backgroundColor: Color.fromARGB(221, 251, 44, 151),
        ),
      body: SopaFutBuilder()
      
    );  
  }
}