import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
void main() {
  runApp(const PokemonApp());
}

class PokemonApp extends StatelessWidget {
  const PokemonApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pokémon Favorites',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomeScreen(),
    );
  }
}



