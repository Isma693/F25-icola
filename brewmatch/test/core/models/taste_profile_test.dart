import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:brewmatch/core/models/taste_profile.dart';
import 'package:brewmatch/core/models/beer.dart';

void main() {
  group('TasteProfile', () {
    test('should create a taste profile with all required fields', () {
      final profile = TasteProfile(
        bitternessLevel: 7.0,
        sweetnessLevel: 3.0,
        alcoholLevel: 5.0,
        carbonationLevel: 4.0,
      );

      expect(profile.bitternessLevel, equals(7.0));
      expect(profile.sweetnessLevel, equals(3.0));
      expect(profile.alcoholLevel, equals(5.0));
      expect(profile.carbonationLevel, equals(4.0));
    });

    test('should convert to and from map correctly', () {
      final profile = TasteProfile(
        bitternessLevel: 7.0,
        sweetnessLevel: 3.0,
        alcoholLevel: 5.0,
        carbonationLevel: 4.0,
      );

      final map = profile.toMap();
      final fromMap = TasteProfile.fromMap(map);

      expect(fromMap.bitternessLevel, equals(profile.bitternessLevel));
      expect(fromMap.sweetnessLevel, equals(profile.sweetnessLevel));
      expect(fromMap.alcoholLevel, equals(profile.alcoholLevel));
      expect(fromMap.carbonationLevel, equals(profile.carbonationLevel));
    });

    test('should handle null values in fromMap', () {
      final profile = TasteProfile.fromMap({});

      expect(profile.bitternessLevel, equals(0.0));
      expect(profile.sweetnessLevel, equals(0.0));
      expect(profile.alcoholLevel, equals(0.0));
      expect(profile.carbonationLevel, equals(0.0));
    });

    test('should create a copy with modified values', () {
      final profile = TasteProfile(
        bitternessLevel: 7.0,
        sweetnessLevel: 3.0,
        alcoholLevel: 5.0,
        carbonationLevel: 4.0,
      );

      final copy = profile.copyWith(
        bitternessLevel: 8.0,
        alcoholLevel: 6.0,
      );

      expect(copy.bitternessLevel, equals(8.0));
      expect(copy.sweetnessLevel, equals(profile.sweetnessLevel));
      expect(copy.alcoholLevel, equals(6.0));
      expect(copy.carbonationLevel, equals(profile.carbonationLevel));
    });

    test('should calculate match score with a beer', () {
      final firestore = FakeFirebaseFirestore();
      final DocumentReference<Map<String, dynamic>> ingredientRef =
          firestore.collection('ingredients').doc('1');

      final profile = TasteProfile(
        bitternessLevel: 7.0,
        sweetnessLevel: 3.0,
        alcoholLevel: 5.0,
        carbonationLevel: 4.0,
      );

      final beer = Beer(
        id: '1',
        name: {'en': 'Test Beer'},
        style: 'Test Style',
        alcoholLevel: 5.0,
        bitternessLevel: 7.0,
        sweetnessLevel: 3.0,
        carbonationLevel: 4.0,
        ingredients: [ingredientRef],
      );

      final score = profile.calculateMatchScore(beer);
      expect(score, equals(1.0)); // Perfect match should give maximum score (1.0)
    });
  });
}
