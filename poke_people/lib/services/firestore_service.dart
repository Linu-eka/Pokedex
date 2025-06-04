import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final _db = FirebaseFirestore.instance;

  Future<void> savePokemonEntry({
    required String uid,
    required String pokemonId,
    required String personName,
    required String? imageUrl,
  }) async {
    await _db.collection('users').doc(uid).collection('pokedex').doc(pokemonId).set({
      'personName': personName,
      'imageUrl': imageUrl ?? '',
    });
  }

  Future<Map<String, dynamic>> getUserPokedex(String uid) async {
  final snapshot = await FirebaseFirestore.instance
      .collection('users')
      .doc(uid)
      .collection('pokedex')
      .get();   

  return {
      for (var doc in snapshot.docs) doc.id: doc.data(), // doc.id = pokemonId
    };
  }
  
}
