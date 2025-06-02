import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/producto.dart';

class ApiService {
  static const String baseUrlProductos = "http://10.0.2.2:3000/api/productos";
  static const String baseUrl = "http://10.0.2.2:3000/api"; // base general

  static Future<List<Producto>> obtenerProductos() async {
    final response = await http.get(Uri.parse(baseUrlProductos));
    if (response.statusCode == 200) {
      List datos = json.decode(response.body);
      return datos.map((p) => Producto.fromJson(p)).toList();
    } else {
      throw Exception("Error al cargar productos");
    }
  }

  static Future<bool> login(String correo, String contrasena) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'correo': correo, 'contrasena': contrasena}),
    );
    return response.statusCode == 200;
  }

  static Future<bool> register(
    String nombre,
    String correo,
    String contrasena,
  ) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'nombre': nombre,
        'correo': correo,
        'contrasena': contrasena,
      }),
    );
    return response.statusCode == 200;
  }
}
