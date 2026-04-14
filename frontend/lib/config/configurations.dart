import 'package:flutter_dotenv/flutter_dotenv.dart';

class Configurations {
  static String get supabaseUrl => _get('SUPABASE_URL');
  static String get supabaseKey => _get('SUPABASE_ANON_KEY');

  static String _get(String key) {
    final value = dotenv.env[key];
    if (value == null || value.isEmpty) {
      throw Exception('Falta la variable de entorno $key en el archivo .env');
    }
    return value;
  }
}