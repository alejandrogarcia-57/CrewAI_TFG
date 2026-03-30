import 'dart:convert';
import 'package:frontend/models/parejas.dart';
import 'package:http/http.dart' as http;
import 'package:frontend/models/models.dart';


class ApiService {

  static const String baseUrl = 'http://127.0.0.1:8000';

  Future<Sopa> fetchSopa() async {

    final response = await http.get(Uri.parse('$baseUrl/obtener-sopa'));
    if (response.statusCode == 200) {
      return Sopa.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Error al obtener sopa');
    }
  }


  Future<EjerciciosMatematicos> fetchOperacion() async {

    final response = await http.get(Uri.parse('$baseUrl/obtener-operaciones'));
    if (response.statusCode == 200) {
      return EjerciciosMatematicos.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Error al conectar con el backend');
    }
  }

  Future<Parejas> fetchParejas() async {
    final response = await http.get(Uri.parse('$baseUrl/obtener-parejas'));
    if (response.statusCode == 200) {
      return Parejas.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Error al conectar con el backend');
    }
  }

  Future<Ahorcado> fetchAhorcado() async {
    final response = await http.get(Uri.parse('$baseUrl/obtener-ahorcado'));
    if (response.statusCode == 200) {
      return Ahorcado.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Error al conectar con el backend');
    }
  }
}