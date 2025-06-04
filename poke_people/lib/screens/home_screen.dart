import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../models/pokemon.dart';
import '../widgets/pokemon_card.dart';
import '../widgets/pokemon_grid.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Pokemon> _pokemonList = [];

  @override
  void initState() {
    super.initState();
    _loadPokemon();
  }

  Future<void> _loadPokemon() async {
    final String jsonString =
        await rootBundle.loadString('lib/data/pokemon_list.json');
    final List<dynamic> data = json.decode(jsonString);
    setState(() {
      _pokemonList = data.map((e) => Pokemon.fromJson(e)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Pokemon'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              FirebaseAuth.instance.signOut();
            },
          ),
        ],
      ),
      body: PokemonGrid(
        pokemonList: _pokemonList,
      ),
    );
  }
}