import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/beer.dart';
import '../models/ingredient.dart';

class SampleData {
  SampleData._();

  static List<Ingredient> ingredients() {
    final items = <Ingredient>[
      Ingredient(
        id: 'mosaic-hop',
        name: <String, String>{'en': 'Mosaic Hop', 'fr': 'Houblon Mosaic'},
        category: IngredientCategory.hop,
        isAllergen: false,
        description: <String, String>{
          'en': 'Aromatic hop delivering tropical and citrus notes.',
          'fr': 'Houblon aromatique aux notes tropicales et d\'agrumes.',
        },
      ),
      Ingredient(
        id: 'pilsner-malt',
        name: <String, String>{'en': 'Pilsner Malt', 'fr': 'Malt Pilsner'},
        category: IngredientCategory.grain,
        isAllergen: true,
        description: <String, String>{
          'en': 'Base malt providing a clean, crisp backbone.',
          'fr': 'Malt de base offrant un profil net et croquant.',
        },
      ),
      Ingredient(
        id: 'munich-malt',
        name: <String, String>{'en': 'Munich Malt', 'fr': 'Malt Munich'},
        category: IngredientCategory.grain,
        isAllergen: true,
        description: <String, String>{
          'en': 'Adds malty sweetness and amber color.',
          'fr': 'Apporte une douceur maltee et une teinte ambree.',
        },
      ),
      Ingredient(
        id: 'belgian-yeast',
        name: <String, String>{'en': 'Belgian Ale Yeast', 'fr': 'Levure belge'},
        category: IngredientCategory.yeast,
        isAllergen: false,
        description: <String, String>{
          'en': 'Classic Belgian yeast with spicy esters.',
          'fr': 'Levure belge classique aux esters epices.',
        },
      ),
      Ingredient(
        id: 'orange-peel',
        name: <String, String>{
          'en': 'Sweet Orange Peel',
          'fr': 'Ecorce d\'orange douce',
        },
        category: IngredientCategory.other,
        isAllergen: false,
        description: <String, String>{
          'en': 'Adds sweet citrus freshness to the finish.',
          'fr': 'Ajoute une touche d\'agrumes douce et rafraichissante.',
        },
      ),
    ];

    _assertUnique(
      items,
      (ingredient) => ingredient.id,
      'Duplicate ingredient id detected',
    );
    _assertUnique(
      items,
      (ingredient) => ingredient.localizedName('en').toLowerCase(),
      'Duplicate ingredient name detected',
    );

    return List<Ingredient>.unmodifiable(items);
  }

  static List<Map<String, dynamic>> ingredientSeedData() {
    return ingredients()
        .map(
          (ingredient) => <String, dynamic>{
            'id': ingredient.id,
            'data': ingredient.toMap(),
          },
        )
        .toList(growable: false);
  }

  static List<Beer> beers(FirebaseFirestore firestore) {
    final items = <Beer>[
      Beer(
        id: 'sunset-ipa',
        name: <String, String>{
          'en': 'Sunset IPA',
          'fr': 'IPA Coucher de Soleil',
        },
        style: 'American IPA',
        alcoholLevel: 6.5,
        bitternessLevel: 8,
        sweetnessLevel: 3,
        carbonationLevel: 6,
        description: <String, String>{
          'en': 'Bright IPA packed with Mosaic hops for juicy tropical aromas.',
          'fr':
              'IPA lumineuse gorgee de houblon Mosaic pour des aromes tropicaux.',
        },
        ingredients: _ingredientRefs(firestore, const <String>[
          'mosaic-hop',
          'pilsner-malt',
          'belgian-yeast',
          'orange-peel',
        ]),
        imageUrl:
            'https://images.unsplash.com/photo-1541557435984-1c79685a082b',
        onTap: true,
      ),
      Beer(
        id: 'midnight-stout',
        name: <String, String>{'en': 'Midnight Stout', 'fr': 'Stout Minuit'},
        style: 'Oatmeal Stout',
        alcoholLevel: 5.8,
        bitternessLevel: 4,
        sweetnessLevel: 6,
        carbonationLevel: 4,
        description: <String, String>{
          'en': 'Smooth stout with roasted malt character and silky mouthfeel.',
          'fr':
              'Stout onctueuse au caractere de malt torrifie et a la texture soyeuse.',
        },
        ingredients: _ingredientRefs(firestore, const <String>[
          'munich-malt',
          'pilsner-malt',
          'belgian-yeast',
        ]),
        imageUrl:
            'https://images.unsplash.com/photo-1516450360452-9312f5e86fc7',
      ),
      Beer(
        id: 'citrus-wit',
        name: <String, String>{'en': 'Citrus Wit', 'fr': 'Witbier Agrume'},
        style: 'Belgian Witbier',
        alcoholLevel: 4.8,
        bitternessLevel: 2,
        sweetnessLevel: 5,
        carbonationLevel: 7,
        description: <String, String>{
          'en':
              'Refreshing wheat beer with bright citrus peel and spice notes.',
          'fr':
              'Biere de ble rafraichissante aux notes d\'ecorce d\'orange et d\'epices.',
        },
        ingredients: _ingredientRefs(firestore, const <String>[
          'pilsner-malt',
          'belgian-yeast',
          'orange-peel',
        ]),
        imageUrl: 'https://images.unsplash.com/photo-1543007630-9710e4a00a20',
      ),
    ];

    _assertUnique(items, (beer) => beer.id, 'Duplicate beer id detected');
    _assertUnique(
      items,
      (beer) => beer.localizedName('en').toLowerCase(),
      'Duplicate beer name detected',
    );

    return List<Beer>.unmodifiable(items);
  }

  static List<Map<String, dynamic>> beerSeedData(FirebaseFirestore firestore) {
    return beers(firestore)
        .map((beer) => <String, dynamic>{'id': beer.id, 'data': beer.toMap()})
        .toList(growable: false);
  }

  static List<DocumentReference<Map<String, dynamic>>> _ingredientRefs(
    FirebaseFirestore firestore,
    List<String> ids,
  ) {
    return ids
        .map((id) => firestore.collection('ingredients').doc(id))
        .toList(growable: false);
  }

  static void _assertUnique<T, K>(
    Iterable<T> entries,
    K Function(T entry) selector,
    String errorMessage,
  ) {
    final seen = <K>{};
    for (final entry in entries) {
      final key = selector(entry);
      if (!seen.add(key)) {
        throw StateError('$errorMessage: $key');
      }
    }
  }
}
