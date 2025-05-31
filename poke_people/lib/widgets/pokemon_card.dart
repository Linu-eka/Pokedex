import 'package:flutter/material.dart';
import '../models/pokemon.dart';

class PokemonCard extends StatelessWidget {
  final Pokemon pokemon;

  const PokemonCard({required this.pokemon, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Expanded(
              flex: 6, // 
              child: Container(),
            ),
            Expanded(
              flex: 4, 
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(
                    flex: 3, 
                    child: Image.network(
                      pokemon.imageUrl,
                      fit: BoxFit.contain,
                      
                      errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
                    )
                  ),
                  Expanded(
                    flex: 1, 
                    child: Text(
                      pokemon.name,
                      style: Theme.of(context).textTheme.titleLarge,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
// ...existing code...
  }
}