import 'package:flutter/material.dart';
import 'favorites_page.dart';
import '../models/pokemon.dart';
import '../services/api_service.dart';
import '../services/db_service.dart';
import '../widgets/pokemon_tile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Pokemon>> futurePokemons;

  List<Pokemon> allPokemons = [];
  List<Pokemon> filteredPokemons = [];

  List<int> favorites = [];
  String search = '';

  @override
  void initState() {
    super.initState();
    futurePokemons = ApiService.fetchPokemons();
    loadFavs();
  }

  Future<void> loadFavs() async {
    favorites = await DbService.getFavorites();
    setState(() {});
  }

  void filterList(String value) {
    search = value.toLowerCase();

    filteredPokemons = allPokemons.where((p) {
      return p.name.toLowerCase().contains(search);
    }).toList();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pokedex Simples'),
        actions: [
          IconButton(
            icon: const Icon(Icons.star),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const FavoritesPage()),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Pokemon>>(
        future: futurePokemons,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData) {
            return const Center(child: Text('Erro ao carregar pokémons'));
          }

          allPokemons = snapshot.data!;
          filteredPokemons = filteredPokemons.isEmpty && search.isEmpty
              ? allPokemons
              : filteredPokemons;

          return RefreshIndicator(
            onRefresh: () async {
              favorites = await DbService.getFavorites();
              setState(() {});
            },
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: TextField(
                    onChanged: filterList,
                    decoration: InputDecoration(
                      hintText: 'Buscar Pokémon...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),

                // LISTA
                Expanded(
                  child: ListView.builder(
                    itemCount: filteredPokemons.length,
                    itemBuilder: (context, i) {
                      final p = filteredPokemons[i];
                      return PokemonTile(
                        pokemon: p,
                        initiallyFavorite: favorites.contains(p.id),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}