import 'package:flutter/material.dart';
import 'package:frontend/models/sopa.dart';

class SopadeLetras extends StatelessWidget {

  final Sopa sopa;

  const SopadeLetras({super.key, required this.sopa});

  @override
  Widget build(BuildContext context) {

    List<String> letras = sopa.cuadricula.trim().split(RegExp(r'\s+'));

    return Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      "TEMA: ${sopa.tema}", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                      
                  ),
                  LayoutBuilder(builder: (context, constraints) {
                    double size = constraints.maxWidth < 500 ? constraints.maxWidth * 0.9 : 500;
                    return Container(
                      height: size,
                      width: size,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(color: Colors.black12, blurRadius: 10, spreadRadius: 2)
                        ]
                      ),
                      child: GridView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.all(10),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 10,
                          mainAxisSpacing: 2,
                          crossAxisSpacing: 2,
                        ),
                        itemCount: letras.length,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: EdgeInsets.all(4.0),
                            decoration: BoxDecoration(
                              color: Colors.blueAccent,
                              border: Border.all(color: Colors.blue),
                              borderRadius: BorderRadius.circular(5.0),
                            ),    
                            child: Center(
                              child: Text(letras[index], style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold)),
                            ),
                          );
                        },
                      ),
                    );
                  }),
                  Padding(
                    padding:const EdgeInsets.all(16.0),
                    child: Text("Busca: ${sopa.palabras}"),
                  ),
                ],
              ),
            ),
      );   
  }
}