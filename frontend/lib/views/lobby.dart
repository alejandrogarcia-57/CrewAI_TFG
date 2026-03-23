import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:frontend/models/exercises.dart';
import 'dart:convert';
import 'package:http/http.dart' as http; 

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

Future<Exercise> fetchSopa() async {
  //Para el emulador Android: 10.0.2.2
  //----------------------------------
  //Para pruebas en el ordenandor en local: 127.0.0.1
  final response = await http.get(Uri.parse('http://127.0.0.1:8000/obtener-sopa'));

  if (response.statusCode == 200) {
    return Exercise.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Error al conectar con el backend');
  }  
  
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Implementación Sopa de letras"),
        backgroundColor: Color.fromARGB(221, 251, 44, 151),
        ),
      body: FutureBuilder(
        future: fetchSopa(), 
        builder: (context, snapshot){

          if (snapshot.connectionState == ConnectionState.waiting){
            return Center(child: CircularProgressIndicator(
                color: Color.fromARGB(221, 251, 44, 151),
            ));
          }
          else if(snapshot.hasError){
            return Center(child: Text(
              "Error: ${snapshot.error}",
              style: TextStyle(
                color: Color.fromARGB(255, 147, 4, 4)
              ),
              ));
          }

          else if(snapshot.hasData){
            final sopa = snapshot.data!;

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

          return Container();
        }
        ),
      );
  }

}