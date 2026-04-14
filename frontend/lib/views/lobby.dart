import 'package:flutter/material.dart';
import 'package:frontend/views/ahorcado_page.dart';
import 'package:frontend/views/opera_page.dart';
import 'package:frontend/views/parejas_page.dart';
import 'package:frontend/views/sopa_page.dart';
import 'package:frontend/widgets/exercise_card.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
  
}


class _HomePageState extends State<HomePage> {


  Map<String, Map<String, dynamic>> configEjercicios = {
  'parejas': {'color': Color.fromARGB(255, 174, 25, 25), 'page': const ParejasPage()},
  'sopa': {'color': Color.fromARGB(255, 236, 205, 0), 'page': const SopaPage()},
  'operacion': {'color': Color.fromARGB(255, 48, 154, 180), 'page': const OperaPage()},
  'ahorcado': {'color': Color.fromARGB(255, 171, 82, 203), 'page': const AhorcadoPage()},
};

  

  @override
  void initState(){
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Selección ejercicios"),
        backgroundColor: Color.fromARGB(221, 251, 44, 151),
        ),
      body: Row(
        children: [

          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: ScrollConfiguration(
                behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
                child: ListView.builder(
                  itemCount: 20,
                  itemBuilder: (context, index) {
                    List<String> tipos = ['parejas', 'sopa', 'operacion', 'ahorcado'];
                    String tipoActual = tipos[index % 4];
                                
                    return ExerciseCard(
                      index: index, 
                      tipo: tipoActual, 
                      colorBase: configEjercicios[tipoActual]!['color'], 
                      pagina: configEjercicios[tipoActual]!['page']
                    );
                  },
                ),
              ),
            ),
          ),


          Expanded(
          flex: 1,
          child: Container(
            margin: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.auto_graph, size: 80, color: Colors.blueGrey),
                SizedBox(height: 20),
                Text(
                  "Panel de Progreso",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Text(
                    "Rendimiento actual del niño",
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),


        ]
      )
    );
  }

}