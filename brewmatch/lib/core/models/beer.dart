import 'package:cloud_firestore/cloud_firestore.dart';

import '../services/localized_text.dart';

class Beer {
  Beer({
    required this.id,
    required Map<String, String> name,
    required this.style,
    required this.alcoholLevel,
    required this.bitternessLevel,
    required this.sweetnessLevel,
    required this.carbonationLevel,
    Map<String, String>? description,
    required this.ingredients,
    this.imageUrl,
    this.onTap = false,
  }) : name = LocalizedText.normalize(name),
       description = description == null
           ? null
           : LocalizedText.normalize(description);

  final String id;
  final Map<String, String> name;
  final String style;
  final double alcoholLevel;
  final double bitternessLevel;
  final double sweetnessLevel;
  final double carbonationLevel;
  final Map<String, String>? description;
  final List<DocumentReference<Map<String, dynamic>>> ingredients;
  final String? imageUrl;
  final bool onTap;

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'name': name,
      'style': style,
      'alcoholLevel': alcoholLevel,
      'bitternessLevel': bitternessLevel,
      'sweetnessLevel': sweetnessLevel,
      'carbonationLevel': carbonationLevel,
      'ingredients': ingredients,
      'imageUrl': imageUrl,
      'onTap': onTap,
    };
    if (description != null) {
      map['description'] = description;
    }
    return map;
  }

  Beer copyWith({
    String? id,
    Map<String, String>? name,
    String? style,
    double? alcoholLevel,
    double? bitternessLevel,
    double? sweetnessLevel,
    double? carbonationLevel,
    Map<String, String>? description,
    List<DocumentReference<Map<String, dynamic>>>? ingredients,
    String? imageUrl,
    bool? onTap,
    bool clearDescription = false,
  }) {
    return Beer(
      id: id ?? this.id,
      name: name ?? this.name,
      style: style ?? this.style,
      alcoholLevel: alcoholLevel ?? this.alcoholLevel,
      bitternessLevel: bitternessLevel ?? this.bitternessLevel,
      sweetnessLevel: sweetnessLevel ?? this.sweetnessLevel,
      carbonationLevel: carbonationLevel ?? this.carbonationLevel,
      description: clearDescription ? null : (description ?? this.description),
      ingredients: ingredients ?? this.ingredients,
      imageUrl: imageUrl ?? this.imageUrl,
      onTap: onTap ?? this.onTap,
    );
  }

  factory Beer.fromMap(Map<String, dynamic> map, {required String id}) {
    return Beer(
      id: id,
      name: LocalizedText.parse(map['name']),
      style: map['style'] as String? ?? '',
      alcoholLevel: (map['alcoholLevel'] as num?)?.toDouble() ?? 0,
      bitternessLevel: (map['bitternessLevel'] as num?)?.toDouble() ?? 0,
      sweetnessLevel: (map['sweetnessLevel'] as num?)?.toDouble() ?? 0,
      carbonationLevel: (map['carbonationLevel'] as num?)?.toDouble() ?? 0,
      description: LocalizedText.parseOptional(map['description']),
      ingredients: _parseIngredientRefs(map['ingredients']),
      imageUrl: map['imageUrl'] as String?,
      onTap: map['onTap'] as bool? ?? false,
    );
  }

  factory Beer.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data() ?? <String, dynamic>{};
    return Beer.fromMap(data, id: snapshot.id);
  }

  static List<DocumentReference<Map<String, dynamic>>> _parseIngredientRefs(
    dynamic raw,
  ) {
    if (raw is! List) {
      return <DocumentReference<Map<String, dynamic>>>[];
    }

    final firestore = FirebaseFirestore.instance;
    final references = <DocumentReference<Map<String, dynamic>>>[];

    for (final entry in raw) {
      if (entry is DocumentReference<Map<String, dynamic>>) {
        references.add(entry);
        continue;
      }

      if (entry is DocumentReference) {
        references.add(
          entry.withConverter<Map<String, dynamic>>(
            fromFirestore: (snapshot, _) =>
                snapshot.data() ?? <String, dynamic>{},
            toFirestore: (value, _) => value,
          ),
        );
        continue;
      }

      if (entry is String && entry.isNotEmpty) {
        references.add(
          firestore
              .doc(entry)
              .withConverter<Map<String, dynamic>>(
                fromFirestore: (snapshot, _) =>
                    snapshot.data() ?? <String, dynamic>{},
                toFirestore: (value, _) => value,
              ),
        );
      }
    }

    return references;
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
