import 'package:flutter/material.dart';
import 'package:frontend/views/ahorcado_page.dart';
import 'package:frontend/views/opera_page.dart';
import 'package:frontend/views/parejas_page.dart';
import 'package:frontend/views/sopa_page.dart';
import 'package:frontend/widgets/exercise_card.dart';
import 'package:frontend/views/profile.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
  
}


class _HomePageState extends State<HomePage> {


  
  Route _createRoute() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => ProfilePage(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(0.0, 0.1); // Empieza un poco abajo
      const end = Offset.zero;       // Termina en su sitio
      const curve = Curves.easeOutQuart;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
      
      return FadeTransition(
        opacity: animation,
        child: SlideTransition(
          position: animation.drive(tween),
          child: child,
          ),
        );
      },
    );
  } 

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
      body: Stack(
        clipBehavior: Clip.none,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 80),
            child: Row(
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
                    ),
        ),
        Container(
          height: 60,
          color: Color.fromARGB(255, 0, 49, 96), 
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Text(
                  "Bienvenido, Username",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold
                  ),
                ),
              ),
            ],
          ),        
        ),

        Positioned(
          top: 20,
          right: 40,
          child: Hero(
            tag: 'avatar',
            child: GestureDetector(
              onTap: () {  
                Navigator.of(context).push(_createRoute());        
              },
              child: Container(
                height: 80,
                width: 80,
                decoration: BoxDecoration(
                  color: Colors.redAccent,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                    color: Colors.black.withValues(alpha: 0.15),
                    blurRadius: 10,
                    offset: Offset(0, 5)
                  )
                  ]
                ),
                child: Container(
                  margin: const EdgeInsets.all(2.5),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.person, color: Colors.redAccent, size: 50)
                )
              ),
            ),
          )
        ),
        Positioned(
          bottom: 20,
          right: 40,
          child: Container(
            height: 80,
            width: 80,
            decoration: BoxDecoration(
              color: Colors.redAccent,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                color: Colors.black.withValues(alpha: 0.15),
                blurRadius: 10,
                offset: Offset(0, 5)
              )
              ]
            ),
            child: Container(
              margin: const EdgeInsets.all(2.5),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.settings, color: Colors.redAccent, size: 50,)
            )
          )
        )
        ],
        
      )
    );
  }

}