import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:brewmatch/core/models/beer.dart';

class MockDocumentReference implements DocumentReference<Map<String, dynamic>> {
  final String path;
  MockDocumentReference(this.path);
  
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  group('Beer', () {
    final mockIngredientRef = MockDocumentReference('ingredients/1');

    test('should create a beer with all required fields', () {
      final beer = Beer(
        id: '1',
        name: {'en': 'IPA', 'fr': 'IPA'},
        style: 'India Pale Ale',
        alcoholLevel: 6.5,
        bitternessLevel: 8.0,
        sweetnessLevel: 3.0,
        carbonationLevel: 4.0,
        ingredients: [mockIngredientRef],
      );

      expect(beer.id, equals('1'));
      expect(beer.name['en'], equals('IPA'));
      expect(beer.name['fr'], equals('IPA'));
      expect(beer.style, equals('India Pale Ale'));
      expect(beer.alcoholLevel, equals(6.5));
      expect(beer.bitternessLevel, equals(8.0));
      expect(beer.sweetnessLevel, equals(3.0));
      expect(beer.carbonationLevel, equals(4.0));
      expect(beer.ingredients.length, equals(1));
      expect(beer.imageUrl, isNull);
      expect(beer.onTap, isFalse);
      expect(beer.description, isNull);
    });

    test('should create a beer with optional fields', () {
      final beer = Beer(
        id: '1',
        name: {'en': 'IPA', 'fr': 'IPA'},
        style: 'India Pale Ale',
        alcoholLevel: 6.5,
        bitternessLevel: 8.0,
        sweetnessLevel: 3.0,
        carbonationLevel: 4.0,
        ingredients: [mockIngredientRef],
        description: {'en': 'A hoppy beer', 'fr': 'Une bière houblonnée'},
        imageUrl: 'http://example.com/image.jpg',
        onTap: true,
      );

      expect(beer.description?['en'], equals('A hoppy beer'));
      expect(beer.description?['fr'], equals('Une bière houblonnée'));
      expect(beer.imageUrl, equals('http://example.com/image.jpg'));
      expect(beer.onTap, isTrue);
    });

    test('should convert to map correctly', () {
      final beer = Beer(
        id: '1',
        name: {'en': 'IPA', 'fr': 'IPA'},
        style: 'India Pale Ale',
        alcoholLevel: 6.5,
        bitternessLevel: 8.0,
        sweetnessLevel: 3.0,
        carbonationLevel: 4.0,
        ingredients: [mockIngredientRef],
        description: {'en': 'A hoppy beer', 'fr': 'Une bière houblonnée'},
        imageUrl: 'http://example.com/image.jpg',
        onTap: true,
      );

      final map = beer.toMap();

      expect(map['name'], equals({'en': 'IPA', 'fr': 'IPA'}));
      expect(map['style'], equals('India Pale Ale'));
      expect(map['alcoholLevel'], equals(6.5));
      expect(map['bitternessLevel'], equals(8.0));
      expect(map['sweetnessLevel'], equals(3.0));
      expect(map['carbonationLevel'], equals(4.0));
      expect(map['ingredients'], equals([mockIngredientRef]));
      expect(map['description'], equals({'en': 'A hoppy beer', 'fr': 'Une bière houblonnée'}));
      expect(map['imageUrl'], equals('http://example.com/image.jpg'));
      expect(map['onTap'], isTrue);
    });
  });
}