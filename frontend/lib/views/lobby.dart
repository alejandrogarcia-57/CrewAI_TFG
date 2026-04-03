import 'package:flutter/material.dart';
import 'package:frontend/service/api_service.dart';
import 'package:frontend/widgets/parejas_fut_builder.dart';
import 'package:frontend/widgets/sopa_fut_builder.dart';
import 'package:frontend/widgets/ahorcado_fut_builder.dart';
import 'package:frontend/views/ahorcado_page.dart';



class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
  
}


class _HomePageState extends State<HomePage> {

  

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
      body: Padding(
        padding: EdgeInsetsGeometry.symmetric(vertical: 20.0, horizontal: 12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: 20,
                itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.only(bottom: 8.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        color: Colors.black,
                        width: 2,
                      )
                    ),
                    child: ListTile(
                      title: Text("Exercise $index: Name"),
                      subtitle: Text("Description of exercise $index"),
                      
                      onTap: () {
                        Navigator.push(
                          context, 
                          MaterialPageRoute(builder: (context) => AhorcadoPage())
                        );
                      },
                    ),
                  );                
                }, 
              ),
            ),
          ],
        )
      )
      
      );
  }

}