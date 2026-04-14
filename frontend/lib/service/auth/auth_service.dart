import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient _client = Supabase.instance.client;

  Future<String?> signUp(String email, String password) async{
    final response = await _client.auth.signUp(
      email: email,
      password: password
    );

    if (response.user == null){
      throw Exception("Error al registrarse.");
    }

    return response.user!.id;
  }

  Future<bool> signIn(String email, String password) async{
    
    try{

      final response = await _client.auth.signInWithPassword(
        email: email,
        password: password
      );

      return response.session != null;

    }on AuthException catch (e){
      print("Error de Auth: ${e.message}");
      rethrow;
    }
    
  }

  Future<void> signOut() async{
    await _client.auth.signOut();
  }

  Stream<AuthState> get authState => _client.auth.onAuthStateChange;


  
}