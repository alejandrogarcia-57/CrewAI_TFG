import 'package:flutter/material.dart';
import 'package:frontend/widgets/opera_fut_builder.dart';

class OperaPage extends StatefulWidget {
  const OperaPage({super.key});

  @override
  State<OperaPage> createState() => _OperaPageState();
}

class _OperaPageState extends State<OperaPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Implementación Operacion"),
        backgroundColor: Color.fromARGB(221, 251, 44, 151),
        ),
      body: OperaFutBuilder()
      
    );
  }
}