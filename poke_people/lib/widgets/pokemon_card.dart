import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
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
  String? _imageUrl;
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  @override
  void initState(){
    super.initState();
    // Load the image URL from Firestore if it exists
    _loadImageUrl();
  }

  Future<void> _loadImageUrl() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;

    final doc = await _firestore
        .collection('users')
        .doc(uid)
        .collection('pokedex')
        .doc(widget.pokemon.id.toString())
        .get();

    if (doc.exists && doc.data() != null) {
      setState(() {
        _imageUrl = doc.data()?['imageUrl'] as String?;
      });
    }
  }

  Future<void> _uploadImage(File file) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;

    final storageRef = FirebaseStorage.instance
    .ref()
    .child('user_uploads')
    .child(uid)
    .child('${widget.pokemon.id}.jpg');

    await storageRef.putFile(file);
    final downloadUrl = await storageRef.getDownloadURL();

    await _firestore
        .collection('users')
        .doc(uid)
        .collection('pokedex')
        .doc(widget.pokemon.id.toString())
        .set({
      'imageUrl': downloadUrl, 
    }, SetOptions(merge: true));

    setState(() {
      _imageUrl = downloadUrl;
    });
  }

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
    
    if (pickedFile == null) return; // User cancelled the image picking
    
    final file = File(pickedFile.path);
    setState(() {
      _selectedImage = file;
    });

  await _uploadImage(file);
    
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
                  _PersonSection(selectedImage: _selectedImage, imageUrl: _imageUrl,),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                _AddPhotoButton(onPressed: _pickImage),
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
class _PersonSection extends StatelessWidget {
  final File? selectedImage;
  final String? imageUrl;
  const _PersonSection({this.selectedImage,this.imageUrl});

  @override
  Widget build(BuildContext context) {
    Widget imageWidget;
    if (selectedImage != null) {
      imageWidget = Image.file(
        selectedImage!,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
      );
    } else if (imageUrl != null) {
      imageWidget = Image.network(
        imageUrl!,
        fit: BoxFit.cover
      );
    } else {
      imageWidget = const Center(child: Text('No Image Selected'));
    }
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black, width: 1.0),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: imageWidget,
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
