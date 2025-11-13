import 'package:flutter_test/flutter_test.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:brewmatch/core/services/firestore_service.dart';

void main() {
  late FirestoreService firestoreService;
  late FakeFirebaseFirestore fakeFirestore;

  setUp(() {
    fakeFirestore = FakeFirebaseFirestore();
    firestoreService = FirestoreService(firestore: fakeFirestore);
  });

  group('FirestoreService', () {
    test('getCollection returns empty list when collection is empty', () async {
      final result = await firestoreService.getCollection<Map<String, dynamic>>(
        'test-collection',
        (data, id) => {...data, 'id': id},
      );

      expect(result, isEmpty);
    });

    test('getCollection returns list of documents', () async {
      // Setup: Add some test data
      final testData = {'name': 'Test'};
      await fakeFirestore.collection('test-collection').add(testData);

      final result = await firestoreService.getCollection<Map<String, dynamic>>(
        'test-collection',
        (data, id) => {...data, 'id': id},
      );

      expect(result, hasLength(1));
      expect(result.first['name'], equals('Test'));
      expect(result.first['id'], isNotEmpty);
    });

    test('addDocument adds a document and returns reference', () async {
      final testData = {'name': 'Test'};
      
      final ref = await firestoreService.addDocument(
        'test-collection',
        testData,
      );

      expect(ref, isNotNull);
      
      final doc = await ref!.get();
      expect(doc.data()!['name'], equals('Test'));
    });

    test('updateDocument updates an existing document', () async {
      // Setup: Add a document first
      final docRef = await fakeFirestore.collection('test-collection').add({
        'name': 'Original'
      });

      final success = await firestoreService.updateDocument(
        'test-collection',
        docRef.id,
        {'name': 'Updated'},
      );

      expect(success, isTrue);

      final updatedDoc = await docRef.get();
      expect(updatedDoc.data()!['name'], equals('Updated'));
    });

    test('deleteDocument removes an existing document', () async {
      // Setup: Add a document first
      final docRef = await fakeFirestore.collection('test-collection').add({
        'name': 'To Delete'
      });

      final success = await firestoreService.deleteDocument(
        'test-collection',
        docRef.id,
      );

      expect(success, isTrue);

      final deletedDoc = await docRef.get();
      expect(deletedDoc.exists, isFalse);
    });

    test('getDocumentById returns null for non-existent document', () async {
      final result = await firestoreService.getDocumentById<Map<String, dynamic>>(
        'test-collection',
        'non-existent-id',
        (data, id) => {...data, 'id': id},
      );

      expect(result, isNull);
    });

    test('getDocumentById returns document when it exists', () async {
      // Setup: Add a document first
      final docRef = await fakeFirestore.collection('test-collection').add({
        'name': 'Test Document'
      });

      final result = await firestoreService.getDocumentById<Map<String, dynamic>>(
        'test-collection',
        docRef.id,
        (data, id) => {...data, 'id': id},
      );

      expect(result, isNotNull);
      expect(result!['name'], equals('Test Document'));
      expect(result['id'], equals(docRef.id));
    });
  });
}