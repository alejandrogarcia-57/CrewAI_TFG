import 'package:flutter/material.dart';
import 'package:frontend/service/api_service.dart';




class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
  
}


class _HomePageState extends State<HomePage> {

  final List<String> abecedario = "ABCDEFGHIJKLMNÑOPQRSTUVWXYZ".split("");
  List<String> letrasSeleccionadas = [];
  int fallos = 0;
  String get rutaFlor => 'assets/images/Efecto_flor/Flor_$fallos.png';
  
  

  void verificarLetra(String letraPulsada, String palabra) {

    String palabraUpper = palabra.toUpperCase();

    if (letrasSeleccionadas.contains(letraPulsada)) return;

    setState(() {

      letrasSeleccionadas.add(letraPulsada);


      if (!palabraUpper.contains(letraPulsada)) {
        fallos++;
        print("Letra incorrecta. Fallos: $fallos");

      } else {
        print("¡Bien hecho! La letra $letraPulsada está en la palabra.");
      }
      
    });
  }

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
      body: FutureBuilder(
        future: ApiService().fetchAhorcado(), 
        builder: (context, snapshot) {
          if(snapshot.hasData){
            final ahorcado = snapshot.data!;           
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: 30),
                  AnimatedSwitcher(
                    duration: Duration(milliseconds: 500),
                    child: Image.asset(
                      rutaFlor,
                      key: ValueKey<int>(fallos),
                      height: 200,
                      width: 200,
                      fit: BoxFit.fill,
                    ),
                  ),
                  SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: ahorcado.palabra.toUpperCase().split('').map((char){
                    bool revelada = letrasSeleccionadas.contains(char);

                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 5),
                        padding: const EdgeInsets.only(bottom: 5),
                        width: 30, 
                        decoration: const BoxDecoration(
                         
                          border: Border(
                            bottom: BorderSide(width: 2, color: Colors.black),
                          ),
                        ),
                        child: Text(
                          revelada ? char : "",
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 24, 
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      );    
                    }).toList(),
                  ),
                  SizedBox(height: 30),
                  Flexible(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: 600),
                      child: GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 9,
                          mainAxisSpacing: 8,
                          crossAxisSpacing: 8,
                        ), 
                        itemCount: abecedario.length,
                        itemBuilder: (context, index) {
                          final letra = abecedario[index];
                          final bool yaUsada = letrasSeleccionadas.contains(letra); 
                          final bool esCorrecta = yaUsada && ahorcado.palabra.toUpperCase().contains(letra);  
                          return GestureDetector(
                            onTap: yaUsada ? null : () => verificarLetra(letra, ahorcado.palabra),  
                            child: Container(
                              decoration: BoxDecoration(
                                color: !yaUsada ? Colors.white : (esCorrecta ? Colors.green : Colors.grey),
                                border: Border.all(color: Colors.black),
                                borderRadius: BorderRadius.circular(8.0)
                              ),
                              child: Center(
                                child: Text(
                                  letra,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color: esCorrecta ? Colors.white : (yaUsada ? Colors.black26 : Colors.black),
                                  )
                                )
                              )
                            )
                          );                 
                        },
                      ),
                    ),
                  ),
                  SizedBox(height:50),
                  ElevatedButton(
                    onPressed: () {},
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(Color.fromARGB(221, 251, 44, 151)),
                      padding: WidgetStateProperty.all(EdgeInsets.symmetric(horizontal: 30, vertical: 15)),
                      shape: WidgetStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      )),            
                    ), 
                    child: Text(
                      "ENTER",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),           
                    ),
                  )
                ],
              ),

            );
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
        },
      )
      
      );
  }

}