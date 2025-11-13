import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/beer.dart';
import '../models/ingredient.dart';
import 'firestore_service.dart';

/// Repository dédié aux opérations du backoffice (CRUD ingrédients & bières).
class AdminCatalogRepository {
  AdminCatalogRepository({
    FirestoreService? firestoreService,
    FirebaseFirestore? firestore,
  })  : _firestoreService = firestoreService ?? FirestoreService(firestore: firestore),
        _firestore = firestore ?? FirebaseFirestore.instance;

  static const String _ingredientsPath = 'ingredients';
  static const String _beersPath = 'beers';

  final FirestoreService _firestoreService;
  final FirebaseFirestore _firestore;

  /// -----------------------
  /// Ingrédients
  /// -----------------------

  Future<List<Ingredient>> fetchIngredients() {
    return _firestoreService.getCollection<Ingredient>(
      _ingredientsPath,
      (map, id) => Ingredient.fromMap(map, id: id),
    );
  }

  Stream<List<Ingredient>> watchIngredients() {
    return _firestore.collection(_ingredientsPath).snapshots().map(
          (snapshot) => snapshot.docs.map(Ingredient.fromFirestore).toList(),
        );
  }

  Future<Ingredient?> fetchIngredientById(String id) {
    return _firestoreService.getDocumentById<Ingredient>(
      _ingredientsPath,
      id,
      (map, docId) => Ingredient.fromMap(map, id: docId),
    );
  }

  Future<Ingredient?> createIngredient({
    required Map<String, String> name,
    required IngredientCategory category,
    required bool isAllergen,
    Map<String, String>? description,
  }) async {
    final data = Ingredient(
      id: '',
      name: name,
      category: category,
      isAllergen: isAllergen,
      description: description,
    ).toMap();
    final ref = await _firestoreService.addDocument(_ingredientsPath, data);
    if (ref == null) return null;
    final snapshot = await ref.get();
    return Ingredient.fromFirestore(snapshot);
  }

  Future<bool> updateIngredient(Ingredient ingredient) {
    return _firestoreService.updateDocument(
      _ingredientsPath,
      ingredient.id,
      ingredient.toMap(),
    );
  }

  Future<bool> deleteIngredient(String id) {
    return _firestoreService.deleteDocument(_ingredientsPath, id);
  }

  /// -----------------------
  /// Bières
  /// -----------------------

  Future<List<Beer>> fetchBeers() {
    return _firestoreService.getCollection<Beer>(
      _beersPath,
      (map, id) => Beer.fromMap(map, id: id),
    );
  }

  Stream<List<Beer>> watchBeers() {
    return _firestore.collection(_beersPath).snapshots().map(
          (snapshot) => snapshot.docs.map(Beer.fromFirestore).toList(),
        );
  }

  Future<Beer?> fetchBeerById(String id) {
    return _firestoreService.getDocumentById<Beer>(
      _beersPath,
      id,
      (map, docId) => Beer.fromMap(map, id: docId),
    );
  }

  Future<Beer?> createBeer(Beer beer) async {
    final ref = await _firestoreService.addDocument(_beersPath, beer.toMap());
    if (ref == null) return null;
    final snapshot = await ref.get();
    return Beer.fromFirestore(snapshot);
  }

  Future<bool> updateBeer(Beer beer) {
    return _firestoreService.updateDocument(
      _beersPath,
      beer.id,
      beer.toMap(),
    );
  }

  Future<bool> deleteBeer(String id) {
    return _firestoreService.deleteDocument(_beersPath, id);
  }
}
