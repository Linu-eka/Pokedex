import 'package:flutter/material.dart';
import '../models/pokemon.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class PokemonCard extends StatefulWidget{
  final Pokemon pokemon;

  const PokemonCard({required this.pokemon, super.key});

  @override
  State<PokemonCard> createState() => _PokemonCardState();
}


class _PokemonCardState extends State<PokemonCard> {
  File? _selectedImage;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
      // Here you can also save the image to the Pokemon model or perform other actions
    }
  }


  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Expanded(
              flex: 7,
              child: Stack(
                children: [
                  _EmptySection(selectedImage: _selectedImage),
                  Positioned(
                    bottom: 8,
                    right: 8,
                    child: ElevatedButton(
                      onPressed: _pickImage, 
                      child: const Text('Take Photo'),
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              flex: 3,
              child: _PokemonInfoSection(pokemon: widget.pokemon),
            ),
          ],
        ),
      ),
    );
// ...existing code...
  }
}

//Empty section with border for user image
class _EmptySection extends StatelessWidget {
  final File? selectedImage;
  const _EmptySection({this.selectedImage});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black, width: 1.0),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: selectedImage != null
          ? Image.file(
              selectedImage!,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
            )
          : const Center(
              child: Text('No Image Selected'),
            ),
    );
  }
}

// Section displaying the Pokémon image and name
class _PokemonInfoSection extends StatelessWidget {
  final Pokemon pokemon;

  const _PokemonInfoSection({required this.pokemon});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Expanded(
          flex: 3,
          child: Image.network(
            pokemon.imageUrl,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
          ),
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
    );
  }
}
