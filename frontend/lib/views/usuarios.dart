import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UsuariosPage extends StatefulWidget {
  const UsuariosPage({super.key});

  @override
  State<UsuariosPage> createState() => _UsuariosPageState();
}

class _UsuariosPageState extends State<UsuariosPage> {

  final supabase = Supabase.instance.client;

  Future<List<Map<String, dynamic>>> getUsuarios() async {
    try {
      final List<Map<String, dynamic>> data = await supabase
          .from('users')
          .select(); 
      return data;
    } catch (e) {
      print("Error en el select: $e");
      return [];
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(title: Text("Usuarios de Prueba")),
      body: FutureBuilder<List<dynamic>>(
        future: getUsuarios(),
        builder:(context, snapshot) {
          if(snapshot.hasData){
            final usuarios = snapshot.data!;

            if (usuarios.isEmpty) {
              return const Center(child: Text("La lista está vacía (posible RLS bloqueando)"));
            }

            return ListView.builder(
            itemCount: usuarios.length,
            itemBuilder: (context, index) {
              final usuario = usuarios[index];
              return ListTile(
                leading: Icon(Icons.person),
                title: Text(usuario['username'] ?? 'Sin nombre'),
                subtitle: Text(usuario['email'] ?? 'Sin email'),
                trailing: Text(usuario['id'].toString().substring(0, 8) + "...", 
                  style: TextStyle(fontSize: 10, color: Colors.black)),
                );
              },
            );
          }else if(snapshot.hasError){

            return Center(child: Text("Error: ${snapshot.error}")); 

          }else{

            return Center(child: CircularProgressIndicator());

          }
        },
      )
    );
  }
}