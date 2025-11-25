import 'package:flutter/material.dart';
import '../models/pokemon.dart';
import '../services/db_service.dart';

class PokemonTile extends StatefulWidget {
  final Pokemon pokemon;
  final bool initiallyFavorite;

  const PokemonTile({
    super.key,
    required this.pokemon,
    required this.initiallyFavorite,
  });

  @override
  State<PokemonTile> createState() => _PokemonTileState();
}

class _PokemonTileState extends State<PokemonTile> {
  late bool isFavorite;

  @override
  void initState() {
    super.initState();
    isFavorite = widget.initiallyFavorite;
  }

  void toggle() async {
    await DbService.toggleFavorite(widget.pokemon.id);
    setState(() => isFavorite = !isFavorite);
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        '#${widget.pokemon.id.toString().padLeft(3, '0')} - ${widget.pokemon.name}',
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),

      subtitle: Text(widget.pokemon.types.join(', ')),
      trailing: IconButton(
        icon: Icon(isFavorite ? Icons.star : Icons.star_border),
        onPressed: toggle,
        color: isFavorite ? Colors.amber : Colors.grey,
      ),
    );
  }
}
