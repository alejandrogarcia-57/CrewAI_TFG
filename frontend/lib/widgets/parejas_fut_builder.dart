import 'package:flutter/material.dart';
import 'package:frontend/models/parejas.dart';
import 'package:frontend/widgets/parejas_builder.dart';
import 'package:frontend/service/api_service.dart';

class ParejasFutBuilder extends StatefulWidget {
  const ParejasFutBuilder({super.key});

  @override
  State<ParejasFutBuilder> createState() => _ParejasFutBuilderState();
}

class _ParejasFutBuilderState extends State<ParejasFutBuilder> {

  late Future<Parejas> _ejercicioParejas;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Parejas>(
      future: ApiService().fetchParejas(), 
      builder: (context, snapshot){
        if(snapshot.hasData){
          return ParejasBuilder(parejas: snapshot.data!);

        }else if(snapshot.hasError){
          return Center(
              child: Text(
                "Error: ${snapshot.error}",
                style: TextStyle(
                  color: Color.fromARGB(255, 147, 4, 4)
                )
              ),
            );  
        }else{
          return Center(child: CircularProgressIndicator(
                color: Color.fromARGB(221, 251, 44, 151),
            ));
        }
      }
    );
  }
}