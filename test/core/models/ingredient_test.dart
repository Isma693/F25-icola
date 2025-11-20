import 'package:flutter_test/flutter_test.dart';
import 'package:brewmatch/core/models/ingredient.dart';

void main() {
  group('Ingredient', () {
    test('should create an ingredient with all required fields', () {
      final ingredient = Ingredient(
        id: '1',
        name: {'en': 'Hop', 'fr': 'Houblon'},
        category: IngredientCategory.hop,
        isAllergen: false,
      );

      expect(ingredient.id, equals('1'));
      expect(ingredient.name['en'], equals('Hop'));
      expect(ingredient.name['fr'], equals('Houblon'));
      expect(ingredient.category, equals(IngredientCategory.hop));
      expect(ingredient.isAllergen, isFalse);
      expect(ingredient.description, isNull);
    });

    test('should create an ingredient with description', () {
      final ingredient = Ingredient(
        id: '1',
        name: {'en': 'Hop', 'fr': 'Houblon'},
        category: IngredientCategory.hop,
        isAllergen: false,
        description: {'en': 'A bitter hop', 'fr': 'Un houblon amer'},
      );

      expect(ingredient.description?['en'], equals('A bitter hop'));
      expect(ingredient.description?['fr'], equals('Un houblon amer'));
    });

    test('should convert to map correctly', () {
      final ingredient = Ingredient(
        id: '1',
        name: {'en': 'Hop', 'fr': 'Houblon'},
        category: IngredientCategory.hop,
        isAllergen: false,
        description: {'en': 'A bitter hop', 'fr': 'Un houblon amer'},
      );

      final map = ingredient.toMap();

      expect(map['name'], equals({'en': 'Hop', 'fr': 'Houblon'}));
      expect(map['category'], equals('hop'));
      expect(map['isAllergen'], isFalse);
      expect(map['description'], equals({'en': 'A bitter hop', 'fr': 'Un houblon amer'}));
    });

    test('IngredientCategory fromValue should return correct category', () {
      expect(IngredientCategory.fromValue('hop'), equals(IngredientCategory.hop));
      expect(IngredientCategory.fromValue('yeast'), equals(IngredientCategory.yeast));
      expect(IngredientCategory.fromValue('grain'), equals(IngredientCategory.grain));
      expect(IngredientCategory.fromValue('other'), equals(IngredientCategory.other));
      expect(IngredientCategory.fromValue('invalid'), equals(IngredientCategory.other));
    });
  });
}