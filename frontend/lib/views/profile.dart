import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Perfil de usuario"),
        backgroundColor: Color.fromARGB(255, 0, 49, 96),
      ),
      body: 
      Center(
        child: Text("Perfil de usuario")
      )
    );
  }
}