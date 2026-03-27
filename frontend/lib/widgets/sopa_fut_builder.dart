import 'package:flutter/material.dart';
import 'package:frontend/service/api_service.dart';
import 'package:frontend/models/sopa.dart';
import 'package:frontend/widgets/sopa_builder.dart';

class SopaFutBuilder extends StatefulWidget {
  const SopaFutBuilder({super.key});

  @override
  State<SopaFutBuilder> createState() => _SopaFutBuilderState();
}

class _SopaFutBuilderState extends State<SopaFutBuilder> {

  late Future<Sopa> _sopaFuture;

  @override
  void initState(){
    super.initState();
    _sopaFuture = ApiService().fetchSopa();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Sopa>(
      future: _sopaFuture,
      builder: (context, snapshot){
        if (snapshot.hasData){

          return SopadeLetras(sopa: snapshot.data!);

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