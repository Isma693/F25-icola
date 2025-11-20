import 'package:cloud_firestore/cloud_firestore.dart';

/// Service centralisé pour interagir avec Firestore.
///
/// Fournit des méthodes génériques pour lire/ajouter/mettre à jour/supprimer
/// des documents. Les erreurs sont capturées et loggées dans la console.
class FirestoreService {
  FirestoreService({FirebaseFirestore? firestore}) : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  /// Lit tous les documents de la collection [path] et les convertit en [T]
  /// en utilisant la fonction [fromMap] fournie : (map, id) => T.
  ///
  /// Retourne une liste vide en cas d'erreur.
  Future<List<T>> getCollection<T>(
    String path,
    T Function(Map<String, dynamic> map, String id) fromMap,
  ) async {
    try {
      final snapshot = await _firestore.collection(path).get();
    return snapshot.docs
      .map((d) => fromMap(d.data(), d.id))
      .toList();
    } catch (e, st) {
      // Log clair pour faciliter le debug
      print('FirestoreService.getCollection<$T> failed for "$path": $e');
      print(st);
      return <T>[];
    }
  }

  /// Retourne les snapshots (docs) d'une collection brute. Utile pour obtenir
  /// les `DocumentReference` et métadonnées.
  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> getCollectionSnapshots(
    String path,
  ) async {
    try {
      final snapshot = await _firestore.collection(path).get();
      return snapshot.docs;
    } catch (e, st) {
      print('FirestoreService.getCollectionSnapshots failed for "$path": $e');
      print(st);
      return <QueryDocumentSnapshot<Map<String, dynamic>>>[];
    }
  }

  /// Ajoute un document à la collection [path] avec les données [data].
  ///
  /// Retourne le [DocumentReference] du document ajouté, ou `null` en cas d'erreur.
  Future<DocumentReference<Map<String, dynamic>>?> addDocument(
    String path,
    Map<String, dynamic> data,
  ) async {
    try {
      final ref = await _firestore.collection(path).add(data);
      return ref.withConverter<Map<String, dynamic>>(
        fromFirestore: (snap, _) => snap.data() ?? <String, dynamic>{},
        toFirestore: (value, _) => value,
      );
    } catch (e, st) {
      print('FirestoreService.addDocument failed for "$path": $e');
      print(st);
      return null;
    }
  }

  /// Met à jour le document [id] dans la collection [path] avec [data].
  ///
  /// Retourne `true` si l'opération a réussi, sinon `false`.
  Future<bool> updateDocument(
    String path,
    String id,
    Map<String, dynamic> data,
  ) async {
    try {
      await _firestore.collection(path).doc(id).update(data);
      return true;
    } catch (e, st) {
      print('FirestoreService.updateDocument failed for "$path/$id": $e');
      print(st);
      return false;
    }
  }

  /// Supprime le document [id] dans la collection [path].
  ///
  /// Retourne `true` si l'opération a réussi, sinon `false`.
  Future<bool> deleteDocument(String path, String id) async {
    try {
      await _firestore.collection(path).doc(id).delete();
      return true;
    } catch (e, st) {
      print('FirestoreService.deleteDocument failed for "$path/$id": $e');
      print(st);
      return false;
    }
  }

  /// Récupère un document spécifique par son [id] dans la collection [path]
  /// et le convertit en [T] en utilisant la fonction [fromMap] fournie.
  ///
  /// Retourne `null` si le document n'existe pas ou en cas d'erreur.
  Future<T?> getDocumentById<T>(
    String path,
    String id,
    T Function(Map<String, dynamic> map, String id) fromMap,
  ) async {
    try {
      final doc = await _firestore.collection(path).doc(id).get();
      if (!doc.exists) return null;
      return fromMap(doc.data()!, doc.id);
    } catch (e, st) {
      print('FirestoreService.getDocumentById<$T> failed for "$path/$id": $e');
      print(st);
      return null;
    }
  }

  // Méthodes futures possibles : queryWithFilters, streamCollection, etc.
}
