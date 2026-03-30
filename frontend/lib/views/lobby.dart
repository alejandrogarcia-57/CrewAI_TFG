import 'package:flutter/material.dart';
import 'package:frontend/service/api_service.dart';




class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}


class _HomePageState extends State<HomePage> {

  int long_solucion = 0;

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
                  Image.asset(
                    'assets/images/Ordenador.png',
                    height: 250,
                    width: 350,
                    fit: BoxFit.fill,
                  ),
                  SizedBox(height: 30),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 8.0, 
                      children: List.generate(ahorcado.longitud, (index) {
                        return SizedBox(
                          width: 40,
                          child: TextField(
                            keyboardType: TextInputType.text,
                            textAlign: TextAlign.center,
                            maxLength: 1,
                            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                            decoration: InputDecoration(
                              counterText: "",
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.black, width: 2),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.pinkAccent, width: 3),
                              ),
                            ),
                          ),
                        );
                      }),
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