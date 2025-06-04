import 'package:flutter/material.dart';
import '../models/pokemon.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'pokemon_card.dart';

class SlowScrollPhysics extends ClampingScrollPhysics {
  const SlowScrollPhysics({ScrollPhysics? parent}) : super(parent: parent);

  @override
  SlowScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return SlowScrollPhysics(parent: buildParent(ancestor));
  }

  @override
  double applyPhysicsToUserOffset(ScrollMetrics position, double offset) {
    // Reduce the offset to slow down the scroll speed (e.g., 0.5x)
    return super.applyPhysicsToUserOffset(position, offset * 0.5);
  }
}
class PokemonGrid extends StatefulWidget {
  final List<Pokemon> pokemonList;

  const PokemonGrid({super.key, required this.pokemonList});

  @override
  State<PokemonGrid> createState() => _PokemonGridState();
}

class _PokemonGridState extends State<PokemonGrid> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  Set<String> _pokemonWithImages = {};

  Future<void> _fetchPokemonWithImages() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;

    final snapshot = await _firestore
        .collection('users')
        .doc(uid)
        .collection('pokedex')
        .where('imageUrl', isGreaterThan: '')
        .get();

    setState(() {
      _pokemonWithImages = snapshot.docs.map((doc) => doc.id).toSet();
    });
  }

  

  @override
  void initState() {
    super.initState();
    _fetchPokemonWithImages();
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: widget.pokemonList.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 6,
        crossAxisSpacing: 4,
        mainAxisSpacing: 4,
      ),
      physics: const SlowScrollPhysics(),
      itemBuilder: (context, index) {
        final pokemon = widget.pokemonList[index];
        final exists = _pokemonWithImages.contains(pokemon.id.toString());
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => PokemonCard(pokemon: pokemon)),
            );
          },
          child: Container(
            decoration: BoxDecoration(
              color: exists ? Colors.green[200] : Colors.grey[200],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Image.network(pokemon.imageUrl),
          ),
        );
      },
    );
  }
}


