import 'package:flutter/material.dart';
import 'package:frontend/widgets/parejas_fut_builder.dart';

class ParejasPage extends StatefulWidget {
  const ParejasPage({super.key});

  @override
  State<ParejasPage> createState() => _ParejasPageState();
}

class _ParejasPageState extends State<ParejasPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Implementación Parejas"),
        backgroundColor: Color.fromARGB(221, 251, 44, 151),
        ),
      body: ParejasFutBuilder()
      
    );
  }
}