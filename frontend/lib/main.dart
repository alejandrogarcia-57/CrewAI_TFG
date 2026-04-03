import 'package:flutter/material.dart';
import 'package:frontend/views/lobby.dart';
import 'package:supabase/supabase.dart';
import 'package:frontend/config/configurations.dart';




Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SupabaseClient(Configurations.supabaseUrl, Configurations.supabaseKey);
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
      home: HomePage(),
    );
  }
}

