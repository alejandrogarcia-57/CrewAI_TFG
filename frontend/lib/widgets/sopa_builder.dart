import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:frontend/models/sopa.dart';

class SopadeLetras extends StatefulWidget {
  final Sopa sopa;
  const SopadeLetras({super.key, required this.sopa});

  @override
  State<SopadeLetras> createState() => _SopadeLetrasState();
}

class _SopadeLetrasState extends State<SopadeLetras> {
  late List<String> letras;
  late List<String> listaPalabrasObjetivo;
  List<int> seleccionActual = [];
  List<List<int>> palabrasEncontradasIndices = [];
  List<String> palabrasEncontradas = []; 
  List<String> palabrasRestantes = [];

  Map<String, List<int>> posicionesSolucion = {};
  List<int> celdasPistaActiva = [];
  int pistasUsadas = 0;
  
  int segundosRestantes = 100;
  final int lado = 10;

  int? startIndex;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();

    letras = widget.sopa.cuadricula
      .replaceAll('\n',' ')
      .trim()
      .split(RegExp(r'\s+'));
    
    listaPalabrasObjetivo = widget.sopa.palabras
      .split(',')
      .map((p) => p.trim().toUpperCase())
      .toList();

    palabrasRestantes = List.from(listaPalabrasObjetivo);

    _preCalcularSoluciones();
  }

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if(segundosRestantes > 0){
          segundosRestantes--;

        }else{
          _timer?.cancel();
          _mostrarDerrota();
        }
      });
    });
  }

  String get _tiempoFormateado{
    int minutos = segundosRestantes ~/ 60;
    int segundos = segundosRestantes % 60;
    return '${minutos.toString().padLeft(2, '0')}:${segundos.toString().padLeft(2, '0')}';
  }

  String _quitarTildes(String texto) {
    String res = texto;
    res = res.replaceAll('Á', 'A');
    res = res.replaceAll('É', 'E');
    res = res.replaceAll('Í', 'I');
    res = res.replaceAll('Ó', 'O');
    res = res.replaceAll('Ú', 'U');
    return res;
  }


  void _iniciarSeleccion(Offset localPosition, double cellSize) {
    int col = (localPosition.dx / cellSize).floor();
    int row = (localPosition.dy / cellSize).floor();

    if (col >= 0 && col < lado && row >= 0 && row < lado) {
      setState(() {
        startIndex = row * lado + col;
        seleccionActual = [startIndex!];
      });
    }
  }


  void _actualizarSeleccion(Offset localPosition, double cellSize) {
    if (startIndex == null) return; 

    int col = (localPosition.dx / cellSize).floor();
    int row = (localPosition.dy / cellSize).floor();

    if (col >= 0 && col < lado && row >= 0 && row < lado) {
      int startCol = startIndex! % lado;
      int startRow = startIndex! ~/ lado;

      int dx = col - startCol; 
      int dy = row - startRow; 


      if (dx == 0 || dy == 0 || dx.abs() == dy.abs()) {
        List<int> nuevaSeleccion = [];
        

        int steps = dx.abs() > dy.abs() ? dx.abs() : dy.abs();
        
   
        int stepX = dx == 0 ? 0 : (dx > 0 ? 1 : -1);
        int stepY = dy == 0 ? 0 : (dy > 0 ? 1 : -1);


        for (int i = 0; i <= steps; i++) {
          int c = startCol + (i * stepX);
          int r = startRow + (i * stepY);
          nuevaSeleccion.add(r * lado + c);
        }


        if (seleccionActual.length != nuevaSeleccion.length || seleccionActual.last != nuevaSeleccion.last) {
          setState(() {
            seleccionActual = nuevaSeleccion;
          });
        }
      }
    }
  }

  void _finalizarSeleccion() {
    if (seleccionActual.isEmpty) return;

    String palabraFormada = seleccionActual.map((i) => letras[i]).join('');
    String palabraInversa = palabraFormada.split('').reversed.join('');

    String? encontrada;
    for (var p in palabrasRestantes) {
      String pNormalizada = _quitarTildes(p);
      if ((pNormalizada == palabraFormada || pNormalizada == palabraInversa) && !palabrasEncontradas.contains(p)){
        encontrada = p;
        break;
      }
    }

    setState(() {
      if (encontrada != null) {
 
      palabrasEncontradasIndices.add(List.from(seleccionActual));      
      palabrasEncontradas.add(encontrada); 
      palabrasRestantes.remove(encontrada);
      
      if (palabrasRestantes.isEmpty) {
        _mostrarVictoria();
      }
    }
    startIndex = null;
    seleccionActual.clear();
    });
  }

  void _preCalcularSoluciones() {
  
    for (String palabra in listaPalabrasObjetivo) {
      String pNorm = _quitarTildes(palabra);
      List<int>? indices = _encontrarPalabraEnCuadricula(pNorm);
      if (indices != null) {
        posicionesSolucion[palabra] = indices;
      }
    }
  }

  List<int>? _encontrarPalabraEnCuadricula(String palabra) {
    List<List<int>> direcciones = [
      [0, 1], [0, -1], [1, 0], [-1, 0], 
      [1, 1], [-1, -1], [1, -1], [-1, 1] 
    ];

    for (int r = 0; r < lado; r++) {
      for (int c = 0; c < lado; c++) {
        for (var dir in direcciones) {
          List<int> tempIndices = [];
          bool coincide = true;

          for (int i = 0; i < palabra.length; i++) {
            int newR = r + (dir[0] * i);
            int newC = c + (dir[1] * i);

            if (newR < 0 || newR >= lado || newC < 0 || newC >= lado) {
              coincide = false; break;
            }
            int index = newR * lado + newC;
            if (letras[index] != palabra[i]) {
              coincide = false; break;
            }
            tempIndices.add(index);
          }
          if (coincide) return tempIndices;
        }
      }
    }
    return null;
  }


String? _ultimaPalabraPista;

void _usarPista() {
  if (pistasUsadas >= 3 || posicionesSolucion.isEmpty) return;


  List<String> palabrasPendientes = listaPalabrasObjetivo
      .where((p) => !palabrasEncontradas.contains(p))
      .toList();

  if (palabrasPendientes.isEmpty) return;

  String palabraAleatoria;
  if (palabrasPendientes.length > 1) {
    do {
      palabraAleatoria = palabrasPendientes[Random().nextInt(palabrasPendientes.length)];
    } while (palabraAleatoria == _ultimaPalabraPista);
  } else {
    palabraAleatoria = palabrasPendientes.first;
  }

  List<int>? indicesPista = posicionesSolucion[palabraAleatoria];

  if (indicesPista != null) {

    setState(() {
      celdasPistaActiva = [];
      _ultimaPalabraPista = palabraAleatoria;
    });

    Future.microtask(() {
      setState(() {
        pistasUsadas++;
        celdasPistaActiva = indicesPista;
      });


      Future.delayed(const Duration(milliseconds: 800), () {
        if (mounted) {
          setState(() {
            celdasPistaActiva = [];
          });
        }
      });
    });
  }
}

  void _mostrarVictoria() {
    _timer?.cancel();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("¡CONSEGUIDO!", textAlign: TextAlign.center),
        content: const Text("Has encontrado todas las palabras.", textAlign: TextAlign.center),
        actions: [
          Center(
            child: ElevatedButton(
              onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              child: const Text("¡GENIAL!", style: TextStyle(color: Colors.white)),
            ),
          )
        ],
      ),
    );
  }

  void _mostrarDerrota(){
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("¡TIEMPO AGOTADO!", style: TextStyle(color: Colors.red), textAlign: TextAlign.center),
        content: const Text("No has logrado encontrar todas las palabras a tiempo.", textAlign: TextAlign.center),
        actions: [
          Center(
            child: ElevatedButton(
              onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text("VOLVER AL MENÚ", style: TextStyle(color: Colors.white)),
            ),
          )
        ],
      ),
    );  
  }



  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 10),
            Text(
              "TEMA: ${widget.sopa.tema}",
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blueGrey),
            ),
            const SizedBox(height: 20),


            LayoutBuilder(builder: (context, constraints) {

              bool isPequena = constraints.maxWidth < 650;
              double totalSize = isPequena ? constraints.maxWidth * 0.95 : 500;
              double cellSize = (totalSize - 20) / lado;

              Widget tableroSopa = GestureDetector(
                onPanStart: (details) => _iniciarSeleccion(details.localPosition, cellSize),
                onPanUpdate: (details) => _actualizarSeleccion(details.localPosition, cellSize),
                onPanEnd: (_) => _finalizarSeleccion(),
                child: Container(
                  height: totalSize,
                  width: totalSize,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 15)],
                  ),
                  child: GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: lado,
                      mainAxisSpacing: 3,
                      crossAxisSpacing: 3,
                    ),
                    itemCount: letras.length,
                    itemBuilder: (context, index) {
                      bool estaEnSeleccion = seleccionActual.contains(index);
                      bool estaEncontrada = palabrasEncontradasIndices.any((list) => list.contains(index));
                      bool esPistaVisual = celdasPistaActiva.contains(index); 


                      Color colorCelda = Colors.blueAccent;
                      if (estaEnSeleccion) {
                        colorCelda = Colors.redAccent;
                      } else if (esPistaVisual) {
                        colorCelda = Colors.orangeAccent; 
                      } else if (estaEncontrada) {
                        colorCelda = Colors.green;
                      }

                      return AnimatedContainer( 
                        duration: const Duration(milliseconds: 300),
                        decoration: BoxDecoration(
                          color: colorCelda,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Center(
                          child: Text(
                            letras[index],
                            style: const TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              );

              // Reloj Widget
              Widget reloj = Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: segundosRestantes <= 15 ? Colors.red.withValues(alpha: 0.2) : Colors.blueGrey.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: segundosRestantes <= 15 ? Colors.red : Colors.blueGrey),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.timer, color: segundosRestantes <= 15 ? Colors.red : Colors.blueGrey),
                    const SizedBox(width: 8),
                    Text(_tiempoFormateado, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: segundosRestantes <= 15 ? Colors.red : Colors.blueGrey)),
                  ],
                ),
              );

              // Botón Ayuda Widget
              Widget botonAyuda = ElevatedButton.icon(
                onPressed: pistasUsadas < 3 ? _usarPista : null,
                icon: const Icon(Icons.lightbulb_outline),
                label: Text("Pista (${3 - pistasUsadas})"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                  foregroundColor: Colors.black87,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                ),
              );


              if (isPequena) {
                return Column(
                  children: [
                    Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [reloj, botonAyuda]),
                    const SizedBox(height: 15),
                    tableroSopa,
                  ],
                );
              } else {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(child: Center(child: reloj)),
                    tableroSopa,
                    Expanded(child: Center(child: botonAyuda)),
                  ],
                );
              }
            }),

            const Padding(
              padding: EdgeInsets.symmetric(vertical: 30),
              child: Text("¿DÓNDE ESTÁN ESTAS PALABRAS?", style: TextStyle(fontWeight: FontWeight.w900)),
            ),


            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Wrap(
                spacing: 12,
                runSpacing: 12,
                alignment: WrapAlignment.center,
                children: listaPalabrasObjetivo.map((p) {

                   bool encontrada = palabrasEncontradas.contains(p);
                   return Container(
                     padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                     decoration: BoxDecoration(
                       color: encontrada ? Colors.grey[300] : Colors.orangeAccent.withValues(alpha: 0.2),
                       borderRadius: BorderRadius.circular(20),
                       border: Border.all(color: encontrada ? Colors.grey : Colors.orangeAccent),
                     ),
                     child: Text(p, style: TextStyle(fontWeight: FontWeight.bold, color: encontrada ? Colors.grey : Colors.orange, decoration: encontrada ? TextDecoration.lineThrough : null)),
                   );
                }).toList(),
              ),
            ),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}