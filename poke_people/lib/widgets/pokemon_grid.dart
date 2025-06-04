import 'package:flutter/material.dart';
import '../models/pokemon.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'pokemon_card.dart';
  
class PokemonGrid extends StatelessWidget {
  final List<Pokemon> pokemonList;
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  final Map<String, bool> _imageExistsCache = {};

  PokemonGrid({super.key, required this.pokemonList});

  Future<bool> _checkImageExists(String pokemonId) async {

    // Check if the image existence is already cached
    if (_imageExistsCache.containsKey(pokemonId)) {
      return _imageExistsCache[pokemonId]!;
    }
    // If not cached, check Firestore for the image URL
    final uid = _auth.currentUser?.uid;
    if (uid == null) return false;

    final doc = await _firestore
        .collection('users')
        .doc(uid)
        .collection('pokedex')
        .doc(pokemonId)
        .get();

    if (doc.exists && doc.data() != null) {
      final imageUrl = doc.data()?['imageUrl'] as String?;
      if (imageUrl != null && imageUrl.isNotEmpty) {
        // Image exists, you can handle it here if needed
        return true;
      } else {
        // Image does not exist, you can handle it here if needed
        return false;
      }
    }

    // Document does not exist, image does not exist
    return false;
  }

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
          onTap: () {
            // Handle tap on the Pokemon card
            Navigator.push(
              context, 
              MaterialPageRoute(builder: (_) => PokemonCard(pokemon: pokemon))
              );
            // You can navigate to a detail page or show a dialog, etc.
          },
          child: FutureBuilder<bool>(
            future: _checkImageExists(pokemon.id.toString()),
            builder: (context, snapshot) {
              final exists = snapshot.data ?? false;
              return Container(
                decoration: BoxDecoration(
                  color: exists ? Colors.green[200] : Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Image.network(pokemon.imageUrl),
              );
            },
          ),
        );
      },
    );
  }
}


