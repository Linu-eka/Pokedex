import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

Future<String> uploadPokemonImage(String uid, String pokemonId, File file) async {
  final ref = FirebaseStorage.instance.ref('user_uploads/$uid/$pokemonId.jpg');
  final uploadTask = await ref.putFile(file);
  return await uploadTask.ref.getDownloadURL();
}

// Function to delete a Pokemon image from Firebase Storage
Future<void> deletePokemonImage(String uid, String pokemonId) async {
  final ref = FirebaseStorage.instance.ref('user_uploads/$uid/$pokemonId.jpg');
  await ref.delete();
}
