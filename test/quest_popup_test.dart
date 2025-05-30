import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_screenshot/golden_screenshot.dart';
import 'package:latlong2/latlong.dart';
import 'package:osm_bingo/bingo_logic/bingo_card.dart';
import 'package:osm_bingo/in_range_checker.dart';
import 'package:osm_bingo/map_service.dart';
import 'package:osm_bingo/navigation_service.dart';
import 'package:osm_bingo/screens/map.dart';

void main() {
  group('QuestPopup', () {
    testGoldens('QuestPopup', (tester) async {
      MapService().currentPosition = LatLng(
        BingoCard.flattenedBingoElements[0].latitude,
        BingoCard.flattenedBingoElements[0].longitude,
      );

      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          ),
          navigatorKey: navigatorKey,

          home: const OpenStreetMapScreen(),
        ),
      );
      InRangeChecker().checkLocation(
        MapService().currentPosition.latitude,
        MapService().currentPosition.longitude,
      );

      await tester.loadFonts();
      await tester.pumpAndSettle();
      tester.useFuzzyComparator(allowedDiffPercent: 0.005);
      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('quest_popup.png'),
      );
    });

    testGoldens('NoQuestPopup', (tester) async {
      MapService().currentPosition = LatLng(
        BingoCard.flattenedBingoElements[0].latitude + 5.55,
        BingoCard.flattenedBingoElements[0].longitude + 3.11,
      );

      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          ),
          navigatorKey: navigatorKey,

          home: const OpenStreetMapScreen(),
        ),
      );
      InRangeChecker().checkLocation(
        MapService().currentPosition.latitude,
        MapService().currentPosition.longitude,
      );

      await tester.loadFonts();
      await tester.pumpAndSettle();
      tester.useFuzzyComparator(allowedDiffPercent: 0.005);
      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('no_quest_popup.png'),
      );
    });
  });
}
