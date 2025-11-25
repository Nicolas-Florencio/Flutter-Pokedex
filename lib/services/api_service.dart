import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/pokemon.dart';

class ApiService {
  static Future<List<Pokemon>> fetchPokemons() async {
    final response = await http.get(
      Uri.parse('https://pokeapi.co/api/v2/pokemon?limit=80'),
    );

    if (response.statusCode != 200) {
      throw Exception('Erro ao buscar pokemons');
    }

    final data = jsonDecode(response.body);
    List results = data['results'];

    List<Pokemon> pokemons = [];

    for (var item in results) {
      var detail = await http.get(Uri.parse(item['url']));
      var detailJson = jsonDecode(detail.body);
      pokemons.add(Pokemon.fromJson(detailJson));
    }

    return pokemons;
  }
}
