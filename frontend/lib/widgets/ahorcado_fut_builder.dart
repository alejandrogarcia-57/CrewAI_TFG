import 'package:flutter/material.dart';
import 'package:frontend/models/models.dart';
import 'package:frontend/service/api_service.dart';
import 'package:frontend/widgets/ahorcado_builder.dart';

class AhorcadoFutBuilder extends StatefulWidget {
  const AhorcadoFutBuilder({super.key});

  @override
  State<AhorcadoFutBuilder> createState() => _AhorcadoFutBuilderState();
}

class _AhorcadoFutBuilderState extends State<AhorcadoFutBuilder> {

  late Future<Ahorcado> _ahorcadoFuture;

  @override
  void initState() {
    super.initState();
    _ahorcadoFuture = ApiService().fetchAhorcado();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Ahorcado>(
      future: _ahorcadoFuture, 
      builder: (context, snapshot) {
        if(snapshot.hasData){

          return AhorcadoBuilder(ahorcado: snapshot.data!);

        }else if(snapshot.hasError){
          return Center(child: Text(
              "Error: ${snapshot.error}",
              style: TextStyle(
                color: Color.fromARGB(255, 147, 4, 4)
              )
              ));

        }else{
          return Center(child: CircularProgressIndicator(
                color: Color.fromARGB(221, 251, 44, 151),
            ));
        }
      },
    );
  }
}