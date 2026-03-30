import 'package:flutter/material.dart';
import 'package:frontend/models/parejas.dart';
import 'dart:math';

class ParejasBuilder extends StatefulWidget {

  final Parejas parejas;

  const ParejasBuilder({super.key, required this.parejas});

  @override
  State<ParejasBuilder> createState() => _ParejasBuilderState();
}

class _ParejasBuilderState extends State<ParejasBuilder> {

  List<int> cartasReveladas = [];

  Widget _buildCaraFrontal(Carta carta) {
  return Container(
    key: const ValueKey(true), 
    decoration: BoxDecoration(
      color: Colors.white,
      border: Border.all(color: Colors.blueAccent, width: 2),
      borderRadius: BorderRadius.circular(5.0),
    ),
    child: Center(
      child: Text(carta.emoji, style: const TextStyle(fontSize: 32)),
    ),
  );
  } 

  Widget _buildCaraTrasera() {
    return Container(
      key: const ValueKey(false),
      decoration: BoxDecoration(
        color: Colors.blueAccent,
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: const Center(
        child: Icon(Icons.help_outline, color: Colors.white, size: 30),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [ 
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical:16.0, horizontal: 8.0),
                    child: Text("Encuentra las parejas", style: TextStyle(fontSize: 20)),
                  ),
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: 350,
                      maxHeight: 500,
                    ),
                    child: AspectRatio(
                      aspectRatio: 0.8,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: GridView.builder(

                            shrinkWrap: false,
                            physics: const ClampingScrollPhysics(),
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 4,
                              mainAxisSpacing: 10,
                              crossAxisSpacing: 10,
                              childAspectRatio: 0.7,
                            ),
                            itemCount: widget.parejas.cartas.length,
                            itemBuilder: (context, index){
                              
                              final carta = widget.parejas.cartas[index];
                              final bool estaGirada = cartasReveladas.contains(index);
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    if (estaGirada) {
                                      cartasReveladas.remove(index);
                                    } else {
                                      cartasReveladas.add(index);
                                    }
                                  });
                                },
                                child: AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 400),
                                  transitionBuilder: (Widget child, Animation<double> animation) {
                                    
                                    final rotate = Tween(begin: pi, end: 0.0).animate(animation);
                                    return AnimatedBuilder(
                                      animation: rotate,
                                      child: child,
                                      builder: (context, child) {
                                        final isBack = (rotate.value > pi / 2);
                                        final value = isBack ? pi - rotate.value : rotate.value;
                                        
                                        return Transform(
                                          transform: Matrix4.rotationY(value),
                                          alignment: Alignment.center,
                                          child: child,
                                        );
                                      },
                                    );
                                  },
                                  
                                  child: estaGirada 
                                    ? _buildCaraFrontal(carta) 
                                    : _buildCaraTrasera(),
                                ),
                              );
                            }
                          )
                        )
                    ),
                  )
                  
                ],
              )              
            );
  }
}