import '../models/beer.dart';
import '../models/taste_profile.dart';

/// Pure-Dart service to filter and rank `Beer` instances against a
/// `TasteProfile`.
///
/// This service does NOT depend on Firestore or any remote datasource and is
/// therefore testable in isolation.
class BeerFilterService {
  BeerFilterService();

  /// Default minimum relevance threshold. Beers with a score below this are
  /// filtered out.
  static const double defaultMinThreshold = 0.4;

  // Weights for the criteria. Sum should be 1.0.
  static const double _wBitterness = 0.30;
  static const double _wSweetness = 0.25;
  static const double _wAlcohol = 0.25;
  static const double _wCarbonation = 0.20;

  /// Filters and sorts [beers] according to [profile].
  ///
  /// - Computes a match score for each beer using [calculateMatchScore].
  /// - Sorts beers by descending score.
  /// - Filters out beers with score < [minThreshold].
  ///
  /// [scaleMax] is used to normalize differences (e.g. 10 if your scale is 0-10).
  List<Beer> filterBeers(
    List<Beer> beers,
    TasteProfile profile, {
    double minThreshold = defaultMinThreshold,
    double scaleMax = 10,
  }) {
    final scored = beers
        .map((b) => _ScoredBeer(b, calculateMatchScore(b, profile, scaleMax: scaleMax)))
        .toList();

    scored.sort((a, b) => b.score.compareTo(a.score));

    return scored.where((s) => s.score >= minThreshold).map((s) => s.beer).toList();
  }

  /// Calculates a match score in [0..1] for [beer] given a user [profile].
  ///
  /// Per-criterion similarity is computed as:
  ///   sim = 1 - (abs(pref - value) / scaleMax)
  /// and clamped to [0,1]. The final score is the weighted sum of the four
  /// similarities.
  double calculateMatchScore(Beer beer, TasteProfile profile, {double scaleMax = 10}) {
    if (scaleMax <= 0) return 0.0;

    double sim(double pref, double val) {
      final diff = (pref - val).abs();
      final raw = 1.0 - (diff / scaleMax);
      return raw.clamp(0.0, 1.0);
    }

    final sBitterness = sim(profile.bitternessLevel, beer.bitternessLevel);
    final sSweetness = sim(profile.sweetnessLevel, beer.sweetnessLevel);
    final sAlcohol = sim(profile.alcoholLevel, beer.alcoholLevel);
    final sCarbonation = sim(profile.carbonationLevel, beer.carbonationLevel);

    final score = _wBitterness * sBitterness +
        _wSweetness * sSweetness +
        _wAlcohol * sAlcohol +
        _wCarbonation * sCarbonation;

    return score.clamp(0.0, 1.0);
  }
}

class _ScoredBeer {
  _ScoredBeer(this.beer, this.score);

  final Beer beer;
  final double score;
}
// No demo `main()` here; unit tests live under `test/`.
