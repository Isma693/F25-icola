import 'package:cloud_firestore/cloud_firestore.dart';

import '../services/localized_text.dart';

enum IngredientCategory {
  hop('hop'),
  yeast('yeast'),
  grain('grain'),
  other('other');

  const IngredientCategory(this.value);

  final String value;

  static IngredientCategory fromValue(String value) {
    return IngredientCategory.values.firstWhere(
      (category) => category.value == value,
      orElse: () => IngredientCategory.other,
    );
  }
}

class Ingredient {
  Ingredient({
    required this.id,
    required Map<String, String> name,
    required this.category,
    required this.isAllergen,
    Map<String, String>? description,
  }) : name = LocalizedText.normalize(name),
       description = description == null
           ? null
           : LocalizedText.normalize(description);

  final String id;
  final Map<String, String> name;
  final IngredientCategory category;
  final bool isAllergen;
  final Map<String, String>? description;

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'name': name,
      'category': category.value,
      'isAllergen': isAllergen,
    };
    if (description != null) {
      map['description'] = description;
    }
    return map;
  }

  Ingredient copyWith({
    String? id,
    Map<String, String>? name,
    IngredientCategory? category,
    bool? isAllergen,
    Map<String, String>? description,
    bool clearDescription = false,
  }) {
    return Ingredient(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      isAllergen: isAllergen ?? this.isAllergen,
      description: clearDescription ? null : (description ?? this.description),
    );
  }

  factory Ingredient.fromMap(Map<String, dynamic> map, {required String id}) {
    return Ingredient(
      id: id,
      name: LocalizedText.parse(map['name']),
      category: IngredientCategory.fromValue(map['category'] as String? ?? ''),
      isAllergen: map['isAllergen'] as bool? ?? false,
      description: LocalizedText.parseOptional(map['description']),
    );
  }

  factory Ingredient.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
  ) {
    final data = snapshot.data() ?? <String, dynamic>{};
    return Ingredient.fromMap(data, id: snapshot.id);
  }

  String localizedName(String locale) {
    return LocalizedText.resolve(name, locale);
  }

  String localizedDescription(String locale) {
    final localizedMap = description;
    if (localizedMap == null) {
      return '';
    }
    return LocalizedText.resolve(localizedMap, locale);
  }
}
