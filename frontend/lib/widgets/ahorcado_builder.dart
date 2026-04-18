import 'dart:async';
import 'package:flutter/material.dart';
import 'package:frontend/models/ahorcado.dart';

class AhorcadoBuilder extends StatefulWidget {

  final Ahorcado ahorcado;

  const AhorcadoBuilder({super.key, required this.ahorcado});

  @override
  State<AhorcadoBuilder> createState() => _AhorcadoBuilderState();
}

class _AhorcadoBuilderState extends State<AhorcadoBuilder> {

  final List<String> abecedario = "ABCDEFGHIJKLMNÑOPQRSTUVWXYZ".split("");
  List<String> letrasSeleccionadas = [];
  int fallos = 0;
  int pistasUsadas = 0;
  bool juegoTerminado = false;

  int segundos = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        segundos++;
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String get rutaFlor => 'assets/images/Efecto_flor/Flor_$fallos.png';

  
  void verificarLetra(String letraPulsada, String palabra) {
    if (juegoTerminado || letrasSeleccionadas.contains(letraPulsada)) return;

    String palabraUpper = palabra.toUpperCase();

    if (letrasSeleccionadas.contains(letraPulsada)) return;

    setState(() {

      letrasSeleccionadas.add(letraPulsada);
      if (!palabraUpper.contains(letraPulsada)) {
        fallos++;
        print("Letra incorrecta. Fallos: $fallos");
      } 

    });
    _reprobarEstadoJuego();

  }

  void _reprobarEstadoJuego() {
    String palabra = widget.ahorcado.palabra.toUpperCase();
    bool todasReveladas = palabra.split('').every((char) => letrasSeleccionadas.contains(char));

    if (todasReveladas) {
      _finalizarJuego(true);
    } else if (fallos >= 5) { 
      _finalizarJuego(false);
    }
  }

  void _finalizarJuego(bool ganado){
    _timer?.cancel();
    setState(() => juegoTerminado = true);

    showDialog(
      context: context, 
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(ganado ? "¡Felicidades!" : "Has perdido"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(ganado ? "Has ganado el juego" : "La palabra era: ${widget.ahorcado.palabra}"),
            SizedBox(height: 10),
            Text("Tiempo total: ${_formatTime(segundos)}"),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst), // Al lobby
            child: const Text("OK"),
          )
        ],
      ),
    );
  }

  String _formatTime(int s) {
    int min = s ~/ 60;
    int sec = s % 60;
    return '${min.toString().padLeft(2, '0')}:${sec.toString().padLeft(2, '0')}';
  }

  void _usarPista() {
    if (pistasUsadas < 3) {
      setState(() {
        pistasUsadas++;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Pista $pistasUsadas: ${widget.ahorcado.pistas[pistasUsadas - 1]}"),
          backgroundColor: Colors.blueAccent,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          decoration: BoxDecoration(
                            color: Colors.blueGrey.withValues(alpha:0.1),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.blueGrey)
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.timer, color: Colors.blueGrey),
                              SizedBox(width:8),
                              Text(
                                _formatTime(segundos), 
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blueGrey)
                              )
                            ],
                          )
                        ),
                        ElevatedButton.icon(
                          onPressed: (pistasUsadas < 3 && !juegoTerminado) ? _usarPista : null,
                          icon: const Icon(Icons.help_outline),
                          label: Text("Pista (${3 - pistasUsadas})"),
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.amber),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
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
                  Wrap( 
                    alignment: WrapAlignment.center,
                    children: widget.ahorcado.palabra.toUpperCase().split('').map((char) {
                      bool revelada = letrasSeleccionadas.contains(char);
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                        width: 30,
                        decoration: const BoxDecoration(
                          border: Border(bottom: BorderSide(width: 2, color: Colors.black)),
                        ),
                        child: Text(
                          revelada ? char : "",
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
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
                          final bool esCorrecta = yaUsada && widget.ahorcado.palabra.toUpperCase().contains(letra);  
                          return GestureDetector(
                            onTap: yaUsada ? null : () => verificarLetra(letra, widget.ahorcado.palabra),  
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
  }
}

