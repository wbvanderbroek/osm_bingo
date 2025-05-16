import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_screenshot/golden_screenshot.dart';
import 'package:osm_bingo/bingo_logic/bingo_card.dart';
import 'package:osm_bingo/screens/bingo_card.dart';

void main() {
  group('BingoCardScreen', () {
    testGoldens('BingoScreenGolden1', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          ),
          home: const BingoCardScreen(),
        ),
      );

      await tester.loadFonts();
      await tester.pump();

      tester.useFuzzyComparator(allowedDiffPercent: 0.005);
      await expectLater(
        find.byType(BingoCardScreen),
        matchesGoldenFile('bingo_screen.png'),
      );
    });

    testGoldens('BingoScreenGolden2', (tester) async {
      for (int i = 0; i < 20; i++) {
        BingoCard.markAsCompleted(
          BingoCard.flattenedBingoElements[i].latitude,
          BingoCard.flattenedBingoElements[i].longitude,
        );
      }

      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          ),
          home: const BingoCardScreen(),
        ),
      );

      assert(BingoCard.score == 40);

      await tester.loadFonts();

      tester.useFuzzyComparator(allowedDiffPercent: 0.005);
      await expectLater(
        find.byType(BingoCardScreen),
        matchesGoldenFile('bingo_screen_half_completed.png'),
      );
    });

    testGoldens('BingoScreenGolden3', (tester) async {
      for (final element in BingoCard.flattenedBingoElements) {
        BingoCard.markAsCompleted(element.latitude, element.longitude);
      }

      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          ),
          home: const BingoCardScreen(),
        ),
      );

      assert(BingoCard.score == 75);

      await tester.loadFonts();
      await tester.pumpAndSettle();

      tester.useFuzzyComparator(allowedDiffPercent: 0.005);
      await expectLater(
        find.byType(BingoCardScreen),
        matchesGoldenFile('bingo_screen_completed.png'),
      );
    });
  });
}
