import 'dart:math';

import 'beer.dart';

class TasteProfile {
  const TasteProfile({
    required this.bitternessLevel,
    required this.sweetnessLevel,
    required this.alcoholLevel,
    required this.carbonationLevel,
  });

  final double bitternessLevel;
  final double sweetnessLevel;
  final double alcoholLevel;
  final double carbonationLevel;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'bitternessLevel': bitternessLevel,
      'sweetnessLevel': sweetnessLevel,
      'alcoholLevel': alcoholLevel,
      'carbonationLevel': carbonationLevel,
    };
  }

  factory TasteProfile.fromMap(Map<String, dynamic> map) {
    return TasteProfile(
      bitternessLevel: (map['bitternessLevel'] as num?)?.toDouble() ?? 0,
      sweetnessLevel: (map['sweetnessLevel'] as num?)?.toDouble() ?? 0,
      alcoholLevel: (map['alcoholLevel'] as num?)?.toDouble() ?? 0,
      carbonationLevel: (map['carbonationLevel'] as num?)?.toDouble() ?? 0,
    );
  }

  TasteProfile copyWith({
    double? bitternessLevel,
    double? sweetnessLevel,
    double? alcoholLevel,
    double? carbonationLevel,
  }) {
    return TasteProfile(
      bitternessLevel: bitternessLevel ?? this.bitternessLevel,
      sweetnessLevel: sweetnessLevel ?? this.sweetnessLevel,
      alcoholLevel: alcoholLevel ?? this.alcoholLevel,
      carbonationLevel: carbonationLevel ?? this.carbonationLevel,
    );
  }

  double calculateMatchScore(Beer beer, {double scaleMax = 10}) {
    final beerProfile = beer.tasteProfile;
    final levels = <double>[
      (bitternessLevel - beerProfile.bitternessLevel).abs(),
      (sweetnessLevel - beerProfile.sweetnessLevel).abs(),
      (alcoholLevel - beerProfile.alcoholLevel).abs(),
      (carbonationLevel - beerProfile.carbonationLevel).abs(),
    ];

    if (scaleMax <= 0) {
      return 0;
    }

    final normalizedScore =
        levels
            .map((value) => max(0, 1 - value / scaleMax))
            .reduce((value, element) => value + element) /
        levels.length;

    return normalizedScore.clamp(0.0, 1.0);
  }
}

extension BeerTasteProfile on Beer {
  TasteProfile get tasteProfile {
    return TasteProfile(
      bitternessLevel: bitternessLevel,
      sweetnessLevel: sweetnessLevel,
      alcoholLevel: alcoholLevel,
      carbonationLevel: carbonationLevel,
    );
  }
}
