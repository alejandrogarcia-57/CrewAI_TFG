import 'package:flutter/material.dart';
import 'package:frontend/service/auth/auth_gate.dart';
import 'package:frontend/views/lobby.dart';
import 'package:frontend/views/login.dart';
import 'package:frontend/views/signin.dart';
import 'package:frontend/views/usuarios.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:frontend/config/configurations.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';


Future<void> main() async {
  
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Supabase.initialize(
    url: Configurations.supabaseUrl,
    anonKey: Configurations.supabaseKey,
  );
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

 
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CrewAI_TFG',
      theme: ThemeData(
      ),
      home: AuthGate(),
    );
  }
}

