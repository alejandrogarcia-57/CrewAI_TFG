import 'package:flutter/material.dart';
import 'package:frontend/models/operaciones.dart';

class OperaBuilder extends StatelessWidget {

  final EjerciciosMatematicos ejercicio;

  const OperaBuilder({super.key, required this.ejercicio});

  @override
  Widget build(BuildContext context) {

            return Padding(        
                padding: EdgeInsets.all(20),
                child: ListView.builder(
                  itemCount: ejercicio.operaciones.length,
                  itemBuilder: (context, index) {
                    final op = ejercicio.operaciones[index];

                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 60,
                              width: 150,
                              child: Card(
                                color: Colors.blueAccent,
                                elevation: 4,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Center(
                                  child: Text(
                                    "${op.operacion} = ", 
                                    style: TextStyle(
                                      fontSize: 18, 
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      letterSpacing: 1.4,
                                    ),
                                    )
                                  )
                              ),
                            ),

                            const SizedBox(width: 15),
                            SizedBox(
                              width: 100,
                              child: TextField(
                                keyboardType: TextInputType.number,
                                textAlign: TextAlign.center,
                                decoration: InputDecoration(
                                  border:OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  )
                                ),
                              )
                            )
                          ],

                        ),
                      );         
                  },
                ),
              );
  }
}

