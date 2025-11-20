import 'package:flutter_test/flutter_test.dart';

import 'package:brewmatch/core/services/beer_filter_service.dart';
import 'package:brewmatch/core/models/beer.dart';
import 'package:brewmatch/core/models/taste_profile.dart';

void main() {
  late BeerFilterService service;
  setUp(() {
    service = BeerFilterService();
  });

  group('BeerFilterService', () {
    test('calculateMatchScore returns value between 0 and 1', () {
      final beer = Beer.fromMap({
        'name': {'fr': 'Test'},
        'style': 'Ale',
        'alcoholLevel': 5.0,
        'bitternessLevel': 5.0,
        'sweetnessLevel': 5.0,
        'carbonationLevel': 5.0,
      }, id: 't1');

      final profile = TasteProfile(
        bitternessLevel: 5.0,
        sweetnessLevel: 5.0,
        alcoholLevel: 5.0,
        carbonationLevel: 5.0,
      );

      final score = service.calculateMatchScore(beer, profile);
      expect(score, inInclusiveRange(0.0, 1.0));
      expect(score, equals(1.0));
    });

    test('filterBeers sorts by descending relevance', () {
      final beers = [
        Beer.fromMap({'name': {'fr': 'Low Bitter'}, 'style': 'L', 'alcoholLevel': 3.0, 'bitternessLevel': 1.0, 'sweetnessLevel': 5.0, 'carbonationLevel': 5.0}, id: 'b1'),
        Beer.fromMap({'name': {'fr': 'High Bitter'}, 'style': 'H', 'alcoholLevel': 6.0, 'bitternessLevel': 9.0, 'sweetnessLevel': 2.0, 'carbonationLevel': 6.0}, id: 'b2'),
        Beer.fromMap({'name': {'fr': 'Mid Bitter'}, 'style': 'M', 'alcoholLevel': 5.0, 'bitternessLevel': 7.0, 'sweetnessLevel': 3.0, 'carbonationLevel': 5.0}, id: 'b3'),
      ];

      final profile = TasteProfile(bitternessLevel: 8.0, sweetnessLevel: 2.0, alcoholLevel: 5.5, carbonationLevel: 6.0);

      final filtered = service.filterBeers(beers, profile, minThreshold: 0.0);

      // Expect the most bitter to come first
      expect(filtered.first.id, equals('b2'));
      expect(filtered[1].id, equals('b3'));
      expect(filtered[2].id, equals('b1'));
    });

    test('filterBeers respects threshold', () {
      final beers = [
        Beer.fromMap({'name': {'fr': 'Unrelated'}, 'style': 'X', 'alcoholLevel': 1.0, 'bitternessLevel': 0.0, 'sweetnessLevel': 0.0, 'carbonationLevel': 0.0}, id: 'u1'),
        Beer.fromMap({'name': {'fr': 'Close'}, 'style': 'C', 'alcoholLevel': 5.0, 'bitternessLevel': 8.0, 'sweetnessLevel': 2.0, 'carbonationLevel': 6.0}, id: 'c1'),
      ];

      final profile = TasteProfile(bitternessLevel: 8.0, sweetnessLevel: 2.0, alcoholLevel: 5.0, carbonationLevel: 6.0);

      final filteredHigh = service.filterBeers(beers, profile, minThreshold: 0.5);
      expect(filteredHigh.length, equals(1));
      expect(filteredHigh.first.id, equals('c1'));

      final filteredLow = service.filterBeers(beers, profile, minThreshold: 0.0);
      expect(filteredLow.length, equals(2));
    });

    test('calculateMatchScore returns 0 when scaleMax <= 0', () {
      final beer = Beer.fromMap({
        'name': {'fr': 'Any'},
        'style': 'S',
        'alcoholLevel': 5.0,
        'bitternessLevel': 5.0,
        'sweetnessLevel': 5.0,
        'carbonationLevel': 5.0,
      }, id: 'x1');

      final profile = TasteProfile(bitternessLevel: 5.0, sweetnessLevel: 5.0, alcoholLevel: 5.0, carbonationLevel: 5.0);

      final score = service.calculateMatchScore(beer, profile, scaleMax: 0);
      expect(score, equals(0.0));
    });

    test('calculateMatchScore weighting: bitterness heavier than sweetness', () {
      // beerA matches bitterness perfectly, beerB matches sweetness perfectly
      final beerA = Beer.fromMap({
        'name': {'fr': 'A'},
        'style': 'X',
        'alcoholLevel': 5.0,
        'bitternessLevel': 8.0,
        'sweetnessLevel': 0.0,
        'carbonationLevel': 5.0,
      }, id: 'a');

      final beerB = Beer.fromMap({
        'name': {'fr': 'B'},
        'style': 'X',
        'alcoholLevel': 5.0,
        'bitternessLevel': 0.0,
        'sweetnessLevel': 8.0,
        'carbonationLevel': 5.0,
      }, id: 'b');

      final profile = TasteProfile(bitternessLevel: 8.0, sweetnessLevel: 0.0, alcoholLevel: 5.0, carbonationLevel: 5.0);

      final scoreA = service.calculateMatchScore(beerA, profile);
      final scoreB = service.calculateMatchScore(beerB, profile);

      // Because bitterness weight (0.30) > sweetness weight (0.25), beerA should score higher
      expect(scoreA, greaterThan(scoreB));
    });

    test('similarity normalizes with scaleMax correctly', () {
      final beer = Beer.fromMap({
        'name': {'fr': 'Norm'},
        'style': 'N',
        'alcoholLevel': 6.0,
        'bitternessLevel': 6.0,
        'sweetnessLevel': 6.0,
        'carbonationLevel': 6.0,
      }, id: 'n1');

      final profile = TasteProfile(bitternessLevel: 1.0, sweetnessLevel: 1.0, alcoholLevel: 1.0, carbonationLevel: 1.0);

      // diff = 5 -> with scaleMax=10 each sim = 1 - 5/10 = 0.5
      final score10 = service.calculateMatchScore(beer, profile, scaleMax: 10);
      // weighted average should be 0.5 (because all sims equal)
      expect(score10, closeTo(0.5, 1e-9));

      // with scaleMax=5, diff/scaleMax = 1 -> sim = 0
      final score5 = service.calculateMatchScore(beer, profile, scaleMax: 5);
      expect(score5, equals(0.0));
    });
  });
}
