import 'package:flutter/material.dart';
import '../services/db_service.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  List<int> favorites = [];

  @override
  void initState() {
    super.initState();
    loadFavs();
  }

  Future<void> loadFavs() async {
    favorites = await DbService.getFavorites();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Favoritos')),
      body: ListView.builder(
        itemCount: favorites.length,
        itemBuilder: (context, i) {
          return ListTile(title: Text('Pokemon ID: ${favorites[i]}'));
        },
      ),
    );
  }
}
