import 'dart:convert';

import 'package:http/http.dart' as http;
import '../models/receta.dart';

class RecipeService {
  static const String _baseUrl = 'https://dummyjson.com/recipes'; 

  Future<List<Receta>> obtenerRecetas() async {  
    final respuesta = await http.get(Uri.parse(_baseUrl));

    if (respuesta.statusCode == 200) {    
      final Map<String, dynamic> data = jsonDecode(respuesta.body); 
      final List<dynamic> lista = data['recipes'];

      return lista.map((json) => Receta.fromJson(json)).toList();
    } else {
      throw Exception('Error al obtener las recetas');
    }
  }
}
