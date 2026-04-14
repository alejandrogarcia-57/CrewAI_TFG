import 'package:flutter/material.dart';
import 'package:frontend/service/auth/auth_service.dart';
import 'package:frontend/views/lobby.dart';
import 'package:frontend/views/login.dart';
import 'package:frontend/views/signin.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  @override
  Widget build(BuildContext context) {
    final auth = AuthService(); 
    return StreamBuilder<AuthState>(
      stream: auth.authState, 
      builder: (context, snapshot) {
        final session = snapshot.data?.session;

        if(session != null){

          return const HomePage();
        }else{

          return const LoginPage();
        }
      },
    );
  }
}