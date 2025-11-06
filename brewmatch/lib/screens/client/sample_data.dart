class IngredientSample {
  const IngredientSample({
    required this.id,
    required this.name,
    required this.category,
    required this.description,
    this.origin,
    this.pairingTip,
  });

  final String id;
  final String name;
  final String category;
  final String description;
  final String? origin;
  final String? pairingTip;
}

const IngredientSample ingredientWheat = IngredientSample(
  id: 'wheat',
  name: 'Blé malté',
  category: 'Céréale',
  description: 'Apporte une texture soyeuse et une mousse dense, avec des notes douces.',
  origin: 'Belgique',
  pairingTip: 'Accords parfaits avec les agrumes et les épices douces.',
);

const IngredientSample ingredientOrange = IngredientSample(
  id: 'orange',
  name: 'Zeste d’orange',
  category: 'Épice / Fruit',
  description: 'Ajoute une fraîcheur acidulée et un parfum fruité aux bières blanches.',
  origin: 'Méditerranée',
  pairingTip: 'Sublime les blanches et les saisons légères.',
);

const IngredientSample ingredientCoriander = IngredientSample(
  id: 'coriander',
  name: 'Graines de coriandre',
  category: 'Épice',
  description: 'Confère une note florale et citronnée discrète.',
  origin: 'Maroc',
  pairingTip: 'À marier avec agrumes et levures belges.',
);

const IngredientSample ingredientBelgianYeast = IngredientSample(
  id: 'belgian-yeast',
  name: 'Levure belge',
  category: 'Levure',
  description: 'Développe des arômes épicés et fruités typiques des bières belges.',
  origin: 'Belgique',
  pairingTip: 'Idéale pour les saisons et les blanches.',
);

const IngredientSample ingredientBarley = IngredientSample(
  id: 'barley',
  name: 'Orge maltée',
  category: 'Céréale',
  description: 'Structure de base de la bière, apporte corps et douceur.',
  origin: 'Royaume-Uni',
  pairingTip: 'Support neutre pour houblons aromatiques.',
);

const IngredientSample ingredientCitra = IngredientSample(
  id: 'citra',
  name: 'Houblon Citra',
  category: 'Houblon',
  description: 'Explosion d’agrumes tropicaux et de fruits exotiques.',
  origin: 'États-Unis',
  pairingTip: 'À associer avec des levures neutres pour un profil houblonné pur.',
);

const IngredientSample ingredientSimcoe = IngredientSample(
  id: 'simcoe',
  name: 'Houblon Simcoe',
  category: 'Houblon',
  description: 'Notes résineuses, pin et fruits à noyau, équilibre l’amertume.',
  origin: 'États-Unis',
  pairingTip: 'Renforce la structure des IPA modernes.',
);

const IngredientSample ingredientUs05 = IngredientSample(
  id: 'us05',
  name: 'Levure US-05',
  category: 'Levure',
  description: 'Levure neutre fermentant proprement, idéale pour IPA.',
  origin: 'États-Unis',
  pairingTip: 'Laisse la vedette aux houblons aromatiques.',
);

const IngredientSample ingredientRoastedBarley = IngredientSample(
  id: 'roasted-barley',
  name: 'Orge torréfiée',
  category: 'Céréale',
  description: 'Apporte couleur sombre, notes de café et cacao.',
  origin: 'Irlande',
  pairingTip: 'Incontournable des stouts et porters.',
);

const IngredientSample ingredientLactose = IngredientSample(
  id: 'lactose',
  name: 'Lactose',
  category: 'Sucre non fermentescible',
  description: 'Adoucit la bière et crée une texture crémeuse.',
  origin: 'France',
  pairingTip: 'Ajoute un corps velouté aux milk stouts.',
);

const IngredientSample ingredientCoffee = IngredientSample(
  id: 'coffee',
  name: 'Café torréfié',
  category: 'Addition aromatique',
  description: 'Arômes intenses de moka et de cacao.',
  origin: 'Colombie',
  pairingTip: 'Parfait avec les dessert chocolatés.',
);

const IngredientSample ingredientVanilla = IngredientSample(
  id: 'vanilla',
  name: 'Gousse de vanille',
  category: 'Épice',
  description: 'Ajoute rondeur et douceur aromatique.',
  origin: 'Madagascar',
  pairingTip: 'Réhausse les stout crémeuses.',
);

const IngredientSample ingredientSaaz = IngredientSample(
  id: 'saaz',
  name: 'Houblon Saaz',
  category: 'Houblon noble',
  description: 'Notes herbacées fines et épices légères.',
  origin: 'République tchèque',
  pairingTip: 'Classique des pils et saisons artisanales.',
);

const IngredientSample ingredientLemonZest = IngredientSample(
  id: 'lemon-zest',
  name: 'Zeste de citron',
  category: 'Épice / Fruit',
  description: 'Apporte vivacité et fraîcheur acidulée.',
  origin: 'Espagne',
  pairingTip: 'Parfait pour les bières d’été et saisons.',
);

const IngredientSample ingredientSaisonYeast = IngredientSample(
  id: 'saison-yeast',
  name: 'Levure saison',
  category: 'Levure',
  description: 'Génère une finale sèche et des esters poivrés.',
  origin: 'Belgique',
  pairingTip: 'Pour des bières rafraîchissantes et sèches.',
);

const IngredientSample ingredientBrett = IngredientSample(
  id: 'brett',
  name: 'Brettanomyces',
  category: 'Levure sauvage',
  description: 'Développe des notes funky, acidulées et complexes.',
  origin: 'Belgique',
  pairingTip: 'Révèle tout son potentiel dans les lambics.',
);

const IngredientSample ingredientRaspberry = IngredientSample(
  id: 'raspberry',
  name: 'Framboises',
  category: 'Fruit',
  description: 'Apporte couleur rubis et acidité vive.',
  origin: 'Belgique',
  pairingTip: 'Sublime les bières acides et sauvages.',
);

final ingredientCatalog = <IngredientSample>[
  ingredientWheat,
  ingredientOrange,
  ingredientCoriander,
  ingredientBelgianYeast,
  ingredientBarley,
  ingredientCitra,
  ingredientSimcoe,
  ingredientUs05,
  ingredientRoastedBarley,
  ingredientLactose,
  ingredientCoffee,
  ingredientVanilla,
  ingredientSaaz,
  ingredientLemonZest,
  ingredientSaisonYeast,
  ingredientBrett,
  ingredientRaspberry,
];

final ingredientById = {
  for (final ingredient in ingredientCatalog) ingredient.id: ingredient,
};

class BeerSample {
  const BeerSample({
    required this.id,
    required this.name,
    required this.style,
    required this.description,
    required this.alcohol,
    required this.bitterness,
    required this.sweetness,
    required this.carbonation,
    required this.imageAsset,
    required this.ingredientIds,
  });

  final String id;
  final String name;
  final String style;
  final String description;
  final double alcohol;
  final double bitterness;
  final double sweetness;
  final double carbonation;
  final String imageAsset;
  final List<String> ingredientIds;

  List<IngredientSample> get ingredients =>
      ingredientIds.map((id) => ingredientById[id]).whereType<IngredientSample>().toList();

  double matchScore(BeerFilterOptions filters) {
    final weights = {
      'bitterness': 0.35,
      'sweetness': 0.25,
      'alcohol': 0.25,
      'carbonation': 0.15,
    };

    double distance(double a, double b) => (a - b).abs();

    final score = 1 -
        (distance(bitterness, filters.bitterness) * weights['bitterness']! +
            distance(sweetness, filters.sweetness) * weights['sweetness']! +
            distance(alcohol, filters.alcohol) * weights['alcohol']! +
            distance(carbonation, filters.carbonation) * weights['carbonation']!);

    return score.clamp(0, 1);
  }
}

class BeerFilterOptions {
  const BeerFilterOptions({
    required this.bitterness,
    required this.sweetness,
    required this.alcohol,
    required this.carbonation,
  });

  final double bitterness;
  final double sweetness;
  final double alcohol;
  final double carbonation;
}

final mockBeers = <BeerSample>[
  const BeerSample(
    id: 'sunrise-wit',
    name: 'Sunrise Wit',
    style: 'Wheat Beer',
    description: 'Une blanche douce et lumineuse avec des notes d’agrumes et de coriandre.',
    alcohol: 0.45,
    bitterness: 0.3,
    sweetness: 0.6,
    carbonation: 0.7,
    imageAsset: 'assets/mock/sunrise_wit.png',
    ingredientIds: ['wheat', 'orange', 'coriander', 'belgian-yeast'],
  ),
  const BeerSample(
    id: 'hopline-ipa',
    name: 'Hopline IPA',
    style: 'India Pale Ale',
    description: 'Explosion de houblon, agrumes et résine pour les fans d’amertume.',
    alcohol: 0.65,
    bitterness: 0.85,
    sweetness: 0.25,
    carbonation: 0.55,
    imageAsset: 'assets/mock/hopline_ipa.png',
    ingredientIds: ['barley', 'citra', 'simcoe', 'us05'],
  ),
  const BeerSample(
    id: 'velvet-stout',
    name: 'Velvet Stout',
    style: 'Milk Stout',
    description: 'Stout crémeuse avec cacao, café et pointe de vanille.',
    alcohol: 0.7,
    bitterness: 0.4,
    sweetness: 0.75,
    carbonation: 0.35,
    imageAsset: 'assets/mock/velvet_stout.png',
    ingredientIds: ['roasted-barley', 'lactose', 'coffee', 'vanilla'],
  ),
  const BeerSample(
    id: 'citrus-saison',
    name: 'Citrus Saison',
    style: 'Saison',
    description: 'Bière saison sèche et rafraîchissante, avec zeste de citron.',
    alcohol: 0.55,
    bitterness: 0.5,
    sweetness: 0.35,
    carbonation: 0.8,
    imageAsset: 'assets/mock/citrus_saison.png',
    ingredientIds: ['wheat', 'saaz', 'lemon-zest', 'saison-yeast'],
  ),
  const BeerSample(
    id: 'berry-lambic',
    name: 'Berry Lambic',
    style: 'Fruit Lambic',
    description: 'Acidulée et fruitée, parfaite pour les palais aventuriers.',
    alcohol: 0.4,
    bitterness: 0.2,
    sweetness: 0.5,
    carbonation: 0.65,
    imageAsset: 'assets/mock/berry_lambic.png',
    ingredientIds: ['brett', 'raspberry', 'barley', 'wheat'],
  ),
];
