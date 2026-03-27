import 'package:flutter/material.dart';
import 'package:frontend/models/models.dart';
import 'package:frontend/service/api_service.dart';
import 'package:frontend/widgets/opera_builder.dart';

class OperaFutBuilder extends StatefulWidget {
  const OperaFutBuilder({super.key});

  @override
  State<OperaFutBuilder> createState() => _OperaFutBuilderState();
}

class _OperaFutBuilderState extends State<OperaFutBuilder> {


  late Future<EjerciciosMatematicos> _ejercicioFuture;

  @override
  void initState(){
    super.initState();
    _ejercicioFuture = ApiService().fetchOperacion();
  }


  @override
  Widget build(BuildContext context) {
    return FutureBuilder<EjerciciosMatematicos>(
      future: _ejercicioFuture, 
      builder: (context, snapshot) {
        if (snapshot.hasData){

          return OperaBuilder(ejercicio: snapshot.data!);

        } else if (snapshot.hasError){

          return Center(child: Text(
              "Error: ${snapshot.error}",
              style: TextStyle(
                color: Color.fromARGB(255, 147, 4, 4)
              ),
              ));

        } else {

            return Center(child: CircularProgressIndicator(
                color: Color.fromARGB(221, 251, 44, 151),
            ));

        }  
      },
    );
  }
}