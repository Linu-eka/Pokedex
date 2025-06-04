import 'package:flutter/material.dart';
import '../models/pokemon.dart';

class PokemonGrid extends StatelessWidget {
  final List<Pokemon> pokemonList;

  const PokemonGrid({super.key, required this.pokemonList});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: pokemonList.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 6,
        crossAxisSpacing: 4,
        mainAxisSpacing: 4,
      ),
      itemBuilder: (context, index) {
        final pokemon = pokemonList[index];
        return GestureDetector(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Image.network(pokemon.imageUrl),
          ),
        );
      },
    );
  }
}


