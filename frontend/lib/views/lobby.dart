import 'package:flutter/material.dart';
import 'package:frontend/widgets/opera_fut_builder.dart';
import 'package:frontend/widgets/sopa_fut_builder.dart';
import 'package:frontend/models/operaciones.dart';
import 'package:frontend/service/api_service.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}


class _HomePageState extends State<HomePage> {

  @override
  void initState(){
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Implementación Operaciones"),
        backgroundColor: Color.fromARGB(221, 251, 44, 151),
        ),
      body: OperaFutBuilder()
      );
  }

}