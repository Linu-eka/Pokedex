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
    final source = await showDialog<ImageSource>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Image Source'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(ImageSource.camera),
            child: const Text('Camera'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(ImageSource.gallery),
            child: const Text('Gallery'),
          ),
        ],
      ),
    );
    if (source == null) return; // User cancelled the dialog

    final pickedFile = await picker.pickImage(source: source);

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
              flex: 6,
              child: Stack(
                children: [
                  _EmptySection(selectedImage: _selectedImage),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                _AddPhotoButton(onPressed: _pickImage)
                ],     
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

class _AddPhotoButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _AddPhotoButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: const Text('Add Photo'),
    );
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
