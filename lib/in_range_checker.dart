import 'dart:math';

import 'package:osm_bingo/bingo_logic/bingo_card.dart';
import 'package:osm_bingo/bingo_logic/bingo_element.dart';
import 'package:osm_bingo/map_service.dart';
import 'package:vibration/vibration.dart';

class InRangeChecker {
  void checkLocation(final userLat, final userLon) {
    for (var element in BingoCard.flattenedBingoElements) {
      double distanceInMeters = calculateDistance(
        element.latitude,
        element.longitude,
        userLat,
        userLon,
      );
      if (distanceInMeters <= MapService().calculatedRange) {
        if (element.locationStatus == LocationStatus.notSeen) {
          BingoCard.markAsSeen(element.latitude, element.longitude);
          Vibration.vibrate();
        }
      }
    }
  }
}

// Haversine formula to calculate the distance between two points on a sphere
double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
  const R = 6371e3; // Earth's radius in meters
  final phi1 = lat1 * pi / 180; // φ, λ in radians
  final phi2 = lat2 * pi / 180;
  final deltaPhi = (lat2 - lat1) * pi / 180;
  final deltaLambda = (lon2 - lon1) * pi / 180;

  final a =
      sin(deltaPhi / 2) * sin(deltaPhi / 2) +
      cos(phi1) * cos(phi2) * sin(deltaLambda / 2) * sin(deltaLambda / 2);
  final c = 2 * atan2(sqrt(a), sqrt(1 - a));

  return R * c; // in meters
}
